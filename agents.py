import os
from crewai import Agent
from langchain_groq import ChatGroq

from crewai_tools import SerperDevTool,  ScrapeWebsiteTool, WebsiteSearchTool

search_tool = SerperDevTool()
scrape_tool = ScrapeWebsiteTool()
class CustomAgents:
    def __init__(self):
        self.llm = ChatGroq(
            api_key=os.getenv("GROQ_API_KEY"),
            model="llama3-8b-8192",
        )
    def create_agent(self, role):
        descriptions = {
            "Leaf Image Analysis Agent":
            {   "goal":("Analyze the image of the crop leaf, identify the crop type, estimate size, and detect any diseases, providing a detailed description including level of risk, percentage of affected area, and disease stage."),
                "backstory":(
                    "you utilize advanced image processing and machine learning techniques to analyze crop images. "
                    "your has been trained on a vast dataset of crop images and disease symptoms, enabling it to identify even subtle signs of disease. "
                    "your algorithms are designed to provide precise and reliable information to ensure farmers can trust the diagnosis."),
                "tools":[]
            },
            "Disease Research Agent":
            {   "goal":("Search the internet using Retrieval-Augmented Generation (RAG) techniques to find the most relevant websites that discuss solutions for the identified disease."),
                "backstory":(
                    "Equipped with natural language processing capabilities, this agent performs in-depth internet searches to gather the latest and most relevant information. "
                    "It filters out unreliable sources and focuses on scientific articles, agricultural forums, and trusted websites to ensure that the information provided is accurate and useful."),
                 "tools":[search_tool, scrape_tool],
            },
            "Information Extraction Agent":
            {   "goal":"Extract detailed guidance and recommendations from the list of websites provided by the Disease Research Agent.",
                "backstory":(
                    "This agent uses web scraping techniques to extract relevant information from the selected websites. "
                    "It processes and organizes the data into a user-friendly format, ensuring that the recommendations are clear and actionable."),
                 "tools":[scrape_tool],
            },
            "Guidance Generation Agent":
            {   "goal":("Generate detailed guidance and the required ingredients based on the information extracted by the Information Extraction Agent and the estimated size of the crop."),
                "backstory":
                    ("This agent focuses on providing precise ingredient measurements and step-by-step instructions to help farmers effectively treat their crops."),
                "tools":[],
            }
           }

        return Agent(
            role=role,
            backstory=descriptions[role]["backstory"],
            goal=descriptions[role]["goal"],
            tools=descriptions[role]["tools"],
            verbose=True,
            llm=self.llm,
            max_rpm=29,
        )
