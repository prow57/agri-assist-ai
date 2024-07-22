from crewai import Task

from pydantic import BaseModel, Field

class LeafImageAnalysisOutput(BaseModel):
    crop_type: str = Field(description='Type of the crop')
    disease_name: str = Field(description='Name of the detected disease')
    description: str = Field(description='detailed description of the disease')
    level_of_risk: str = Field(description='Level of risk')
    percentage: int = Field(description='Percentage of heath of the spot:100% very health')
    estimated_size: str = Field(description='Estimated size of the crop height')
    stage: str = Field(description='Disease stage')
    symptoms: list[str] | None = Field(description='Symptoms observed')

class DiseaseResearchOutput(BaseModel):
    relevant_websites: list[str] | None  = Field(description='List of relevant websites for disease solutions')

class InformationExtractionOutput(BaseModel):
    general_information: list[str] | None  = Field(description='general informatiosn about the diagnosed disease.')
    recommanded_treatement: list[str] | None = Field(description='recommanded treatements of the diagnosed disease.')

class GuidanceGenerationOutput(BaseModel):
    treatment_steps: list[str] | None  = Field(description='Steps to treatment plan of the disease')
    ingredients: dict[str, str] | None = Field(description='Ingredients used in the treatment and their quantities')

class CumulativeOutput(BaseModel):
    leaf_analysis: LeafImageAnalysisOutput = Field(default=None, description='Results from leaf image analysis')
    disease_research: DiseaseResearchOutput = Field(default=None, description='Results from disease research')
    information_extraction: InformationExtractionOutput = Field(default=None, description='Extracted information and guidance')
    guidance_generation: GuidanceGenerationOutput = Field(default=None, description='Generated guidance and ingredients')
# Define the agents

class CustomTasks:
    def __init__(self):
        pass

    def create_task(self, agent, CropDisease, task_type):
        tasks = {
            "leaf_image_analysis_task": {
                "description":("about:{CropDisease}"
        "1. Analyze the image of the crop leaf provided by the user.\n"
        "2. Identify the type of crop, estimate its size, and detect the presence of any diseases.\n"
        "3. Provide a inormations including the crop type, disease name, detailed description of the disease, level of risk, percentage of heath of the spot, estimated size, the disease's stage and symptoms observed."
    ),
                "expected_output":(
        "A JSON object with the crop type, disease name, detailed description of the disease, level of risk, percentage of heath of the spot, estimated size, the disease's stage and symptoms observed."
    ),
                "tools":[],
                "output_json":LeafImageAnalysisOutput,
                "output_file":"leaf_image_analysis_output.json",

            },
            "disease_research_task": {
                "description":(
        "1. Perform an internet search to find the most relevant websites that discuss solutions for the identified disease.\n"
        "2. Filter out unreliable sources and focus on scientific articles, agricultural forums, and trusted websites."
    ),
                "expected_output":"A JSON object with a list of relevant websites.",
                "tools":[],
                "output_json":DiseaseResearchOutput,
                "output_file":"disease_research_output.json",

            },
            "information_extraction_task": {
                "description":(
        "1. Scrape the list of websites provided by the Disease Research Agent.\n"
        "2. Extract the most relevant information and how to treat the diagnosed disease."
    ),
                "expected_output":"A JSON object with general information and the recommanded treatement of the diagnosed disease.",
                "tools":[],
                "output_json":InformationExtractionOutput,
                "output_file":"information_extraction_output.json",

            },
            "guidance_generation_task": {
                "description":(
        "1. Generate detailed guidance and the required ingredients based on the extracted information and the estimated size of the crop."
    ),
                "expected_output":"A JSON object with the treatment steps and ingredients.",
                "tools":[],
                "output_json":GuidanceGenerationOutput,
                "output_file":"guidance_generation_output.json",

            },
        }


        return Task(
            description=tasks[task_type]["description"],
            expected_output=tasks[task_type]["expected_output"],
            tools=tasks[task_type]["tools"],
            output_json=tasks[task_type]["output_json"],
            output_file=tasks[task_type]["output_file"],
            agent=agent,
        )
