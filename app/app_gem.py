# Warning control
import warnings
warnings.filterwarnings('ignore')

from dotenv import load_dotenv
load_dotenv()
import os

from crewai import Agent, Task, Crew, Process

from crewai_tools import SerperDevTool,  ScrapeWebsiteTool, WebsiteSearchTool

from pydantic import BaseModel, Field

from langchain_groq import ChatGroq

from langchain_google_genai import ChatGoogleGenerativeAI

# Set gemini pro as llm
groq_api_key = os.getenv("GROQ_API_KEY")
groq_api_base = os.getenv("GROQ_API_BASE")
groq_model_name = os.getenv("GROQ_MODEL_NAME")

chat = ChatGroq(
temperature=0,
groq_api_key=groq_api_key,
model_name=groq_model_name,
base_url= groq_api_base

)

llm = ChatGoogleGenerativeAI(model="gemini-1.5-flash",
                             verbose = True,
                             temperature = 0.5,
                             google_api_key="AIzaSyD2L2LnpS3cW-ih1UtSXwljLGX-5JiLBJY")


#create searches
search_tool = SerperDevTool()

scrape_tool = ScrapeWebsiteTool()


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
    role="Disease Research and Information Extraction Agent",
    goal="Search the internet using RAG techniques to find the most relevant websites discussing solutions for the identified disease, and extract detailed guidance and recommendations from those websites.",
    backstory=(
        "This agent combines the roles of performing in-depth internet searches and extracting relevant information. "
        "It filters out unreliable sources, focusing on scientific articles, agricultural forums, and trusted websites, "
        "and then processes the data to provide clear and actionable recommendations."
    ),
    tools=[search_tool, scrape_tool],
    allow_delegation=False,
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


class LeafImageAnalysisOutput(BaseModel):
    crop_type: str | None = Field(description='Type of the crop')
    disease_name: str | None= Field(description='Name of the detected disease None if the crop is healthy')
    description: str| None  = Field(description='detailed description of the disease')
    level_of_risk: str | None = Field(description='Level of risk')
    percentage: int | None= Field(description='Percentage of heath of the spot:100% very health')
    estimated_size: str | None = Field(description='Estimated size of the crop height')
    stage: str | None = Field(description='Disease stage None if the crop is healthy')
    symptoms: list[str] | None = Field(description='List of symptoms observed')


class DiseaseResearchOutput(BaseModel):
    relevant_websites: list[str] | None = Field(description='List of relevant websites for disease solutions')
    general_information: list[str] | None = Field(description='General information about the diagnosed disease.')
    recommended_treatments: list[str] | None = Field(description='Recommended treatments for the diagnosed disease.')

class GuidanceGenerationOutput(BaseModel):
    treatment_steps: list[str] | None  = Field(description='Steps to treatment plan of the disease')
    ingredients: dict[str, str] | None = Field(description='Ingredients used in the treatment and their quantities')

class CumulativeOutput(BaseModel):
    leaf_analysis: LeafImageAnalysisOutput = Field(default=None, description='Results from leaf image analysis')
    disease_research: DiseaseResearchOutput = Field(default=None, description='Results from disease research')
    guidance_generation: GuidanceGenerationOutput = Field(default=None, description='Generated guidance and ingredients')
# Define the agents


leaf_image_analysis_task = Task(
    description=(
        "1. Analyze the image of the crop leaf provided by the user.\n"
        "2. Identify the type of crop, estimate its size, and detect the presence of any diseases.\n"
        "3. Provide a inormations including the crop type, disease name, detailed description of the disease, level of risk, percentage of heath of the spot, estimated size, the disease's stage and symptoms observed."
    ),
    expected_output=(
        """A JSON object with the crop type, disease name, detailed description of the disease, level of risk, percentage of heath of the spot, estimated size, the disease's stage and symptoms observed.
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
    tools=[],  # Specify any tools if needed
#     output_json=LeafImageAnalysisOutput,
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
    tools=[],  # Specify any tools if needed
#     output_json=DiseaseResearchOutput,
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
    tools=[],  # Specify any tools if needed
#     output_json=GuidanceGenerationOutput,
    output_file="guidance_generation_output.json",
    agent=guidance_generation_agent,
)
# Defining the crew
# from transformers import AutoModel
#
# embedding_model = AutoModel.from_pretrained('jinaai/jina-embeddings-v2-base-en', trust_remote_code=True)

# Create a Single Crew
email_crew = Crew(
    agents=[leaf_image_analysis_agent, disease_research_agent, guidance_generation_agent],
    tasks=[leaf_image_analysis_task, disease_research_task, guidance_generation_task],
    process=Process.sequential,
#     memory=True,
    verbose=True,
#     embedder=embedding_model,
)

# Execution Flow
print("Crew: Working on Email Task")
emails_output = email_crew.kickoff()