# api.py

import warnings
warnings.filterwarnings('ignore')

from dotenv import load_dotenv
load_dotenv()
import os

from crewai import Agent, Task, Crew, Process
from crewai_tools import SerperDevTool, ScrapeWebsiteTool
from pydantic import BaseModel, Field
from fastapi import FastAPI
from fastapi.responses import JSONResponse
import base64
import requests
import json
import uvicorn
# Create searches
search_tool = SerperDevTool()
scrape_tool = ScrapeWebsiteTool()

leaf_image_analysis_agent = Agent(
    role="Leaf Image Analysis Agent",
    goal="Analyze the image of the crop leaf, identify the crop type, estimate size, and detect any diseases, providing a detailed description including level of risk, percentage of affected area, and disease stage.",
    backstory=(
        "You use advanced image processing and machine learning techniques to analyze crop images. "
        "you have been trained on a vast dataset of crop images and disease symptoms, enabling it to identify even subtle signs of disease. "
        "The agent's algorithms are designed to provide precise and reliable information to ensure farmers can trust the diagnosis."
    ),
    allow_delegation=False,
    verbose=True
)

disease_research_agent = Agent(
    role="Disease Research and Information Extraction Agent",
    goal="Search the internet using RAG techniques to find the most relevant websites discussing solutions for the identified disease, and extract detailed guidance and recommendations from those websites.",
    backstory=(
        "This agent combines the roles of performing in-depth internet searches and extracting relevant information. "
        "It filters out unreliable sources, focusing on scientific articles, agricultural forums, and trusted websites, "
        "and then processes the data to provide clear and actionable recommendations."
    ),
    tools=[search_tool, scrape_tool],
    allow_delegation=False,
    verbose=True
)

guidance_generation_agent = Agent(
    role="Guidance Generation Agent",
    goal="Generate detailed guidance and the required ingredients based on the information extracted by the Information Extraction Agent and the estimated size of the crop.",
    backstory=(
        "This agent focuses on providing precise ingredient measurements and step-by-step instructions to help farmers effectively treat their crops."
    ),
    allow_delegation=False,
    verbose=True
)

class LeafImageAnalysisOutput(BaseModel):
    crop_type: str | None = Field(description='Type of the crop')
    disease_name: str | None = Field(description='Name of the detected disease None if the crop is healthy')
    description: str | None = Field(description='Detailed description of the disease')
    level_of_risk: str | None = Field(description='Level of risk')
    percentage: int | None = Field(description='Percentage of health of the spot:100% very health')
    estimated_size: str | None = Field(description='Estimated size of the crop height')
    stage: str | None = Field(description='Disease stage None if the crop is healthy')
    symptoms: list[str] | None = Field(description='List of symptoms observed')

class DiseaseResearchOutput(BaseModel):
    relevant_websites: list[str] | None = Field(description='List of relevant websites for disease solutions')
    general_information: list[str] | None = Field(description='General information about the diagnosed disease.')
    recommended_treatments: list[str] | None = Field(description='Recommended treatments for the diagnosed disease.')

class GuidanceGenerationOutput(BaseModel):
    treatment_steps: list[str] | None = Field(description='Steps to treatment plan of the disease')
    ingredients: dict[str, str] | None = Field(description='Ingredients used in the treatment and their quantities')

class CumulativeOutput(BaseModel):
    leaf_analysis: LeafImageAnalysisOutput = Field(default=None, description='Results from leaf image analysis')
    disease_research: DiseaseResearchOutput = Field(default=None, description='Results from disease research')
    guidance_generation: GuidanceGenerationOutput = Field(default=None, description='Generated guidance and ingredients')

leaf_image_analysis_task = Task(
    description=(
        "1. Analyze the image of the crop leaf provided by the user.\n"
        "2. Identify the type of crop, estimate its size, and detect the presence of any diseases.\n"
        "3. Provide information including the crop type, disease name, detailed description of the disease, level of risk, percentage of health of the spot, estimated size, the disease's stage and symptoms observed."
    ),
    expected_output=(
        """A JSON object with the crop type, disease name, detailed description of the disease, level of risk, percentage of health of the spot, estimated size, the disease's stage and symptoms observed.
        structure:
            {
            "crop_type": "<string>",               // Type of the crop
            "disease_name": "<string or None>",    // Name of the detected disease or None
            "description": "<string>",             // Detailed description of the disease
            "level_of_risk": "<string>",           // Level of risk (e.g., "Low", "Medium", "High")
            "percentage": <integer>,               // Percentage of health (0-100)
            "estimated_size": "<string>",          // Estimated size of the crop or area affected
            "stage": "<string or None>",           // Disease stage or None if healthy
            "symptoms": [
              "<string>",                          // Symptom 1
              "<string>"                           // Symptom 2
            ]
            }
            do not give any additional text like feedbacks or comments
            Provide concise answers, focus on factual information.
        """
    ),
    tools=[],
    output_file="leaf_image_analysis_output.json",
    agent=leaf_image_analysis_agent,
)

disease_research_task = Task(
    description=(
        "1. Perform an internet search to find the most relevant websites that discuss solutions for the identified disease.\n"
        "2. Filter out unreliable sources and focus on scientific articles, agricultural forums, and trusted websites.\n"
        "3. Scrape the list of websites.\n"
        "4. Extract the most relevant information and recommended treatments for the diagnosed disease."
    ),
    expected_output="""A JSON object with a list of relevant websites, general information, and recommended treatments for the diagnosed disease.
            structure:
            {
                "relevant_websites": [
                  "<string>",                          // URL to relevant website 1
                  "<string>"                           // URL to relevant website 2
                ],
                "general_information": [
                  "<string>",                          // General information 1
                  "<string>"                           // General information 2
                ],
                "recommended_treatments": [
                  "<string>",                          // Recommended treatment 1
                  "<string>"                           // Recommended treatment 2
                ]
            }
            do not give any additional text like feedbacks or comments
            Provide concise answers, focus on factual information.
    """,
    tools=[],
    output_file="disease_research_output.json",
    agent=disease_research_agent,
)

guidance_generation_task = Task(
    description=(
        "1. Generate detailed guidance and the required ingredients based on the extracted information and the estimated size of the crop."
    ),
    expected_output="""A JSON object with the treatment steps and ingredients.
                    structure:
                {
                 "treatment_steps": [
                   "<string>",                          // Treatment step 1
                   "<string>"                           // Treatment step 2
                 ],
                 "ingredients": {
                   "<string>": "<string>",              // Ingredient name and quantity
                   "<string>": "<string>"               // Ingredient name and quantity
                 }
                }
            do not give any additional text like feedbacks or comments
            Provide concise answers, focus on factual information.
    """,
    tools=[],
    output_file="guidance_generation_output.json",
    agent=guidance_generation_agent,
)

crew = Crew(
    agents=[disease_research_agent, guidance_generation_agent],
    tasks=[disease_research_task, guidance_generation_task],
    process=Process.sequential,
    verbose=True,
)

app = FastAPI()

# OpenAI API Key
api_key = os.getenv("OPENAI_API_KEY")


class ImageRequest(BaseModel):
    image: str

@app.post("/analyze-leaf/")
async def analyze_leaf(request: ImageRequest):
    base64_image = request.image
    headers = {
        "Content-Type": "application/json",
        "Authorization": f"Bearer {api_key}"
    }

    payload = {
        "model": "gpt-4o-mini",
        "messages": [
               {
                "role": "system",
                "content": [
                    {
                        "type": "text",
                        "text": """
        role:Leaf Image Analysis Agent,
        goal:
        Analyze the image of the crop leaf, identify the crop type, estimate size, and detect any diseases, providing a detailed description including level of risk, percentage of affected area, and disease stage.
        backstory:
        You use advanced image processing and machine learning techniques to analyze crop images.
        you have been trained on a vast dataset of crop images and disease symptoms, enabling it to identify even subtle signs of disease.
        The agent's algorithms are designed to provide precise and reliable information to ensure farmers can trust the diagnosis.
    
        description:
        1. Analyze the image of the crop leaf provided by the user.
        2. Identify the type of crop, estimate its size, and detect the presence of any diseases.
        3. Provide information including the crop type, disease name, detailed description of the disease, level of risk, percentage of health of the spot, estimated size, the disease's stage and symptoms observed.

        expected_output:
        A JSON object with the crop type, disease name, detailed description of the disease, level of risk, percentage of health of the spot, estimated size, the disease's stage and symptoms observed.
        structure:
            {
            "crop_type": "<string>",               // Type of the crop
            "disease_name": "<string or None>",    // Name of the detected disease or None
            "description": "<string>",             // Detailed description of the disease
            "level_of_risk": "<string>",           // Level of risk (e.g., "Low", "Medium", "High")
            "percentage": <integer>,               // Percentage of health (0-100)
            "estimated_size": "<string>",          // Estimated size of the crop or area affected
            "stage": "<string or None>",           // Disease stage or None if healthy
            "symptoms": [
              "<string>",                          // Symptom 1
              "<string>"                           // Symptom 2
            ]
            }
            do not give any additional text like feedbacks or comments
            Provide concise answers, focus on factual information.
        """
                    }
                ]
            },
            {
                "role": "user",
                "content": [
                    {
                        "type": "text",
                        "text": "Analyze this leaf image and provide details about the crop type, disease presence, and risk level."
                    },
                    {
                        "type": "image_url",
                        "image_url": {
                            "url": f"data:image/jpeg;base64,{base64_image}"
                        }
                    }
                ]
            }
        ],
        "max_tokens": 300
    }

    response = requests.post("https://api.openai.com/v1/chat/completions", headers=headers, json=payload)

    if response.status_code != 200:
        return JSONResponse(content={"error": "Failed to analyze image with OpenAI API"}, status_code=500)

    # Parse the response from the OpenAI Vision API
    openai_response = response.json()
    leaf_analysis_result = openai_response.get('choices', [])[0].get('message', {}).get('content', {})


    inputs = { "input":{
        "crop_type":leaf_analysis_result.get("crop_type"),
        "disease_name":leaf_analysis_result.get("disease_name"),
        "description":leaf_analysis_result.get("description"),
        "level_of_risk":leaf_analysis_result.get("level_of_risk"),
        "percentage":leaf_analysis_result.get("percentage"),
        "estimated_size":leaf_analysis_result.get("estimated_size"),
        "stage":leaf_analysis_result.get("stage"),
        "symptoms":leaf_analysis_result.get("symptoms")
    }
    }

    result = crew.kickoff(inputs=inputs)
    
    # Load results from the output files
    with open("leaf_image_analysis_output.json", "r") as f:
        leaf_analysis = LeafImageAnalysisOutput.parse_raw(f.read())
    with open("disease_research_output.json", "r") as f:
        disease_research = DiseaseResearchOutput.parse_raw(f.read())
    with open("guidance_generation_output.json", "r") as f:
        guidance_generation = GuidanceGenerationOutput.parse_raw(f.read())

    cumulative_output = CumulativeOutput(
        leaf_analysis=leaf_analysis,
        disease_research=disease_research,
        guidance_generation=guidance_generation
    )

    return JSONResponse(content=cumulative_output.dict())

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)

