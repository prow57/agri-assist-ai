import warnings
import logging

# Suppress the specific TracerProvider warning
warnings.filterwarnings("ignore", message="Overriding of current TracerProvider is not allowed")

# Optionally, you can also set the logging level to suppress other warnings
logging.getLogger("opentelemetry").setLevel(logging.ERROR)

from dotenv import load_dotenv
load_dotenv()
import os
import base64
import io
from PIL import Image

from fastapi import FastAPI
from fastapi.responses import JSONResponse
from pydantic import BaseModel, Field

from crewai import Agent, Task, Crew, Process
from crewai_tools import SerperDevTool, ScrapeWebsiteTool
from langchain_openai import ChatOpenAI

import uvicorn
from app.leafanalyser import LeafAnalyser
# Initialize FastAPI app
app = FastAPI()
leaf_image_analysis_agent=LeafAnalyser()

# Initialize tools
search_tool = SerperDevTool()
scrape_tool = ScrapeWebsiteTool()

disease_research_agent = Agent(
    role="Disease Research Agent",
    goal="Research and extract information on identified crop diseases.",
    backstory="Specialized in agricultural research and data extraction from reliable sources.",
    tools=[search_tool, scrape_tool],
    allow_delegation=False,
    max_execution_time=10,
    verbose=True
)

guidance_generation_agent = Agent(
    role="Guidance Generation Agent",
    goal="Generate treatment guidance based on disease information and crop size.",
    backstory="Expert in creating precise, actionable treatment plans for crop diseases.",
    allow_delegation=False,
    verbose=True
)

disease_research_task = Task(
    description="Research the identified disease '{disease_name}' for the crop type '{crop_type}' and extract relevant information.",
    expected_output="""A JSON object with a list of relevant websites, general information, and recommended treatments for the diagnosed disease.
            structure:
            
            relevant_websites: [
                  <string>,                          // URL to relevant website 1
                  <string>",                         // URL to relevant website 2
                ....
                ],general_information: [
                  <string>,                          // General information 1
                  <string>,                          // General information 2
                ...
                ],recommended_treatments: [
                  <string>,                          // Recommended treatment 1
                  <string>,                          // Recommended treatment 2
                ...
                ]
          
            do not give any additional text like feedbacks or comments
            Provide concise answers, focus on factual information.""",
    agent=disease_research_agent,
)

guidance_generation_task = Task(
    description="Generate treatment guidance for '{disease_name}' on '{crop_type}' with an estimated size of '{estimated_size}'.",
    expected_output="""A JSON object with the treatment steps and ingredients.
                    structure:
                
                 treatment_steps: [
                   <string>,                          // Treatment step 1
                   <string>,                          // Treatment step 2
                 ...
                 ],
                 ingredients: [
                   <string>,                          // Ingredient name and quantity
                   <string>,                          // Ingredient name and quantity
                 ...
                 ]
                
            do not give any additional text like feedbacks or comments
            Provide concise answers, focus on factual information.""",
    agent=guidance_generation_agent,
)

# Define output models
class LeafImageAnalysisOutput(BaseModel):
    crop_type: str | None = Field(description='Type of the crop')
    disease_name: str | None = Field(description='Name of the detected disease or None if healthy')
    description: str | None = Field(description='Detailed description of the disease')
    level_of_risk: str | None = Field(description='Level of risk')
    percentage: int | None = Field(description='Percentage of health (0-100)')
    estimated_size: str | None = Field(description='Estimated size of the crop')
    stage: str | None = Field(description='Disease stage or None if healthy')
    symptoms: list[str] | None = Field(description='List of observed symptoms')

class DiseaseResearchOutput(BaseModel):
    relevant_websites: list[str] | None = Field(description='List of relevant websites for disease solutions')
    general_information: list[str] | None = Field(description='General information about the diagnosed disease')
    recommended_treatments: list[str] | None = Field(description='Recommended treatments for the diagnosed disease')

class GuidanceGenerationOutput(BaseModel):
    treatment_steps: list[str] | None = Field(description='Steps for disease treatment')
    ingredients: list[str] | None = Field(description='Ingredients and their quantities for treatment')

class CumulativeOutput(BaseModel):
    leaf_analysis: LeafImageAnalysisOutput = Field(description='Results from leaf image analysis')
    disease_research: DiseaseResearchOutput = Field(description='Results from disease research')
    guidance_generation: GuidanceGenerationOutput = Field(description='Generated guidance and ingredients')

class ImageRequest(BaseModel):
    image: str

main_crew = Crew(
    agents=[disease_research_agent, guidance_generation_agent],
    tasks=[disease_research_task, guidance_generation_task],
    process=Process.sequential,
    verbose=True
)
import json
import logging

@app.post("/analyze-leaf/")
async def analyze_leaf(request: ImageRequest):
    print("step 1:done")
    leaf_analyser = LeafAnalyser()

    print("step 2:done")
    leaf_analysis_result = leaf_analyser.run(request)
    
    # Parse the JSON string into a Python dictionary
    leaf_analysis_dict = json.loads(leaf_analysis_result)
    
    leaf_analysis = LeafImageAnalysisOutput(**leaf_analysis_dict)
    
    # Prepare inputs for main_crew
    crew_inputs = {
        "disease_name": leaf_analysis.disease_name,
        "crop_type": leaf_analysis.crop_type,
        "estimated_size": leaf_analysis.estimated_size
    }
    
    # Perform disease research and guidance generation
    main_crew_result = main_crew.kickoff(inputs=crew_inputs)

# Parse results

    
    print("step 8:done")
    def parse_task_result(task, output_model):
        output = task.output
        result = output.raw
        if output.json_dict:
            result = json.dumps(output.json_dict, indent=2)
        if output.pydantic:
            result = output.pydantic
        if isinstance(result, str):
            try:
                return output_model.parse_raw(result)
            except json.JSONDecodeError:
                return output_model.parse_obj(json.loads(result))
        elif isinstance(result, dict):
            return output_model.parse_obj(result)
        else:
            raise ValueError(f"Unexpected task result type: {type(result)}")

    disease_research = parse_task_result(disease_research_task, DiseaseResearchOutput)
    guidance_generation = parse_task_result(guidance_generation_task, GuidanceGenerationOutput)

    # Compile final output
    cumulative_output = CumulativeOutput(
        leaf_analysis=leaf_analysis,
        disease_research=disease_research,
        guidance_generation=guidance_generation
    )

    return JSONResponse(content=cumulative_output.dict())