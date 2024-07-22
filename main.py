# Warning control
import warnings
warnings.filterwarnings('ignore')
import os
from crewai import Crew
from agents import CustomAgents
from tasks import CustomTasks

from dotenv import load_dotenv
load_dotenv() 
# Set up environment variables

class CropDiseaseProfessionalCrew:
    def __init__(self, CropDisease):
        self.CropDisease = CropDisease
        self.agents = CustomAgents()
        self.tasks = CustomTasks()

    def run(self):
        agents = {
            "LeafImageAnalysisAgent": self.agents.create_agent("Leaf Image Analysis Agent"),
            "DiseaseResearchAgent": self.agents.create_agent("Disease Research Agent"),
            "InformationExtractionAgent": self.agents.create_agent("Information Extraction Agent"),
            "GuidanceGenerationAgent": self.agents.create_agent("Guidance Generation Agent"),
        }

        tasks = {
            "leaf_image_analysis_task": self.tasks.create_task(agents["LeafImageAnalysisAgent"], self.CropDisease, "leaf_image_analysis_task"),
            "disease_research_task": self.tasks.create_task(agents["DiseaseResearchAgent"], self.CropDisease, "disease_research_task"),
            "information_extraction_task": self.tasks.create_task(agents["InformationExtractionAgent"], self.CropDisease, "information_extraction_task"),
            "guidance_generation_task": self.tasks.create_task(agents["GuidanceGenerationAgent"], self.CropDisease, "guidance_generation_task"),
        }

        crew = Crew(
            agents=list(agents.values()),
            tasks=list(tasks.values()),
            verbose=False
        )

        return crew.kickoff()

if __name__ == "__main__":
    print("Welcome to the Crop Disease Professional Crew Setup")
    print("------------------------------------------------")
    CropDisease = input("What Crop Disease do you suffering from? ").strip()

    automation_crew = CropDiseaseProfessionalCrew(CropDisease)
    final_recommandation = automation_crew.run()

    print("\n\n########################")
    print("## Here are the results of the final recommandations:")
    print("########################\n")
    print(business_plan)
