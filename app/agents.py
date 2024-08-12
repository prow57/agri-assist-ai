from crewai import Agent
from crewai_tools import SerperDevTool, ScrapeWebsiteTool

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