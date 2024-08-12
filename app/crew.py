from crewai import Crew, Process
from app.agents import disease_research_agent, guidance_generation_agent
from app.tasks import disease_research_task, guidance_generation_task

main_crew = Crew(
    agents=[disease_research_agent, guidance_generation_agent],
    tasks=[disease_research_task, guidance_generation_task],
    process=Process.sequential,
    verbose=True
)