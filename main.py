# Warning control
import warnings
warnings.filterwarnings('ignore')

from dotenv import load_dotenv
load_dotenv() 
import os

from crewai import Agent, Task, Crew, Process

from IPython.display import Markdown

from crewai_tools import SerperDevTool,  ScrapeWebsiteTool, WebsiteSearchTool

from pydantic import BaseModel, Field

from langchain_core.prompts import ChatPromptTemplate

from langchain_groq import ChatGroq

search_tool = SerperDevTool()
scrape_tool = ScrapeWebsiteTool()
groq_api_key = os.getenv("GROQ_API_KEY")
groq_api_base = os.getenv("GROQ_API_BASE")
groq_model_name = os.getenv("GROQ_MODEL_NAME")

chat = ChatGroq(
temperature=0,
groq_api_key=groq_api_key,
model_name=groq_model_name
)

leaf_image_analysis_agent = Agent(
    role="Leaf Image Analysis Agent",
    goal="Analyze the image of the crop leaf, identify the crop type, estimate size, and detect any diseases, providing a detailed description including level of risk, percentage of affected area, and disease stage.",
    backstory=(
        "This agent utilizes advanced image processing and machine learning techniques to analyze crop images. "
        "It has been trained on a vast dataset of crop images and disease symptoms, enabling it to identify even subtle signs of disease. "
        "The agent's algorithms are designed to provide precise and reliable information to ensure farmers can trust the diagnosis."
    ),
    allow_delegation=False,
    verbose=True,
    llm=chat

)

disease_research_agent = Agent(
    role="Disease Research Agent",
    goal="Search the internet using Retrieval-Augmented Generation (RAG) techniques to find the most relevant websites that discuss solutions for the identified disease.",
    backstory=(
        "Equipped with natural language processing capabilities, this agent performs in-depth internet searches to gather the latest and most relevant information. "
        "It filters out unreliable sources and focuses on scientific articles, agricultural forums, and trusted websites to ensure that the information provided is accurate and useful."
    ),
    tools=[search_tool, scrape_tool],
    allow_delegation=False,
    verbose=True,
    llm=chat
)
information_extraction_agent = Agent(
    role="Information Extraction Agent",
    goal="Extract detailed guidance and recommendations from the list of websites provided by the Disease Research Agent.",
    backstory=(
        "This agent uses web scraping techniques to extract relevant information from the selected websites. "
        "It processes and organizes the data into a user-friendly format, ensuring that the recommendations are clear and actionable."
    ),
    allow_delegation=False,
    tools=[scrape_tool],
    verbose=True,
    llm=chat
)
guidance_generation_agent = Agent(
    role="Guidance Generation Agent",
    goal="Generate detailed guidance and the required ingredients based on the information extracted by the Information Extraction Agent and the estimated size of the crop.",
    backstory=(
        "This agent focuses on providing precise ingredient measurements and step-by-step instructions to help farmers effectively treat their crops."
    ),
    allow_delegation=False,
    verbose=True,
    llm=chat
)

# Defining the agents
# Define a Pydantic model for venue details
# (demonstrating Output as Pydantic)
# class VenueDetails(BaseModel):
#     age: int = Field(default='twelve',description='Age of the user',examples=['marcelo@mail.com'])
#     address: str = Field(exclude=True)
#     capacity: Decimal = Field(max_digits=5, decimal_places=2)
#     booking_status: str = Field(max_length=10)

# Defining the tasks



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


leaf_image_analysis_task = Task(
    description=(
        "1. Analyze the image of the crop leaf provided by the user.\n"
        "2. Identify the type of crop, estimate its size, and detect the presence of any diseases.\n"
        "3. Provide a inormations including the crop type, disease name, detailed description of the disease, level of risk, percentage of heath of the spot, estimated size, the disease's stage and symptoms observed."
    ),
    expected_output=(
        "A JSON object with the crop type, disease name, detailed description of the disease, level of risk, percentage of heath of the spot, estimated size, the disease's stage and symptoms observed."
    ),
    tools=[],  # Specify any tools if needed
    output_json=LeafImageAnalysisOutput,
    output_file="leaf_image_analysis_output.json",
    agent=leaf_image_analysis_agent,
)

disease_research_task = Task(
    description=(
        "1. Perform an internet search to find the most relevant websites that discuss solutions for the identified disease.\n"
        "2. Filter out unreliable sources and focus on scientific articles, agricultural forums, and trusted websites."
    ),
    expected_output="A JSON object with a list of relevant websites.",
    tools=[],  # Specify any tools if needed
    output_json=DiseaseResearchOutput,
    output_file="disease_research_output.json",
    agent=disease_research_agent,
)

information_extraction_task = Task(
    description=(
        "1. Scrape the list of websites provided by the Disease Research Agent.\n"
        "2. Extract the most relevant information and how to treat the diagnosed disease."
    ),
    expected_output="A JSON object with general information and the recommanded treatement of the diagnosed disease.",
    tools=[],  # Specify any tools if needed
    output_json=InformationExtractionOutput,
    output_file="information_extraction_output.json",
    agent=information_extraction_agent,
)

guidance_generation_task = Task(
    description=(
        "1. Generate detailed guidance and the required ingredients based on the extracted information and the estimated size of the crop."
    ),
    expected_output="A JSON object with the treatment steps and ingredients.",
    tools=[],  # Specify any tools if needed
    output_json=GuidanceGenerationOutput,
    output_file="guidance_generation_output.json",
    agent=guidance_generation_agent,
)
# Defining the crew

crew = Crew(
    agents=[leaf_image_analysis_agent, disease_research_agent, information_extraction_agent, guidance_generation_agent],
    tasks=[leaf_image_analysis_task, disease_research_task, information_extraction_task, guidance_generation_task],
    process=Process.sequential,
    memory=True,
    verbose=True,
    embedder={
      "provider": "azure_openai",
      "config": {
          "model": "text-embedding-ada-002",
          "deployment_name": "agri_assistant_ai",
          "api_key": os.getenv("AZURE_OPENAI_KEY"),
          "api_base": os.getenv("AZURE_OPENAI_ENDPOINT"),
          "endpoint": os.getenv("AZURE_OPENAI_ENDPOINT")
      }
  }
)

# Example input and kickoff

inputs = {
    "topic": "Crop Disease Detection"
}

result = crew.kickoff(inputs=inputs)
