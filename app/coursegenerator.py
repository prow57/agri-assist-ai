from crewai import Crew, Agent, Task
from crewai_tools import SerperDevTool, ScrapeWebsiteTool
import json
from app.validator import TopicSelectionOutput, ContentAndMetadataOutput
class CourseGenerator:
    def __init__(self):
        self.search_tool = SerperDevTool()
        self.scrape_tool = ScrapeWebsiteTool()

    def generate_course(self, history: list[str]):
        topic_selection_agent = Agent(
            role="Agricultural Content Curator",
            goal="Identify engaging and impactful agricultural topics for social media posts",
            backstory="A seasoned agronomist with a knack for crafting engaging content that resonates with farmers, specializing in practical solutions and innovative techniques for everyday challenges",
            tools=[self.search_tool],
            verbose=True
        )

        content_and_metadata_agent = Agent(
            role="Agricultural Content Creator",
            goal="Develop concise, actionable, and engaging social media content related to the chosen agricultural topic",
            backstory="An expert in agricultural practices with extensive experience in communicating practical tips and advice in an engaging manner, tailored for social media audiences",
            tools=[self.search_tool, self.scrape_tool],
            verbose=True
        )

        topic_selection_task = Task(
            description=(
                f"Identify a new agricultural topic not present in this list: [{', '.join(history)}]. "
                "The topic should focus on providing farmers with practical tips, tricks, or advice for solving daily challenges. "
                "It must be short, relevant, and random, aimed at sparking interest and offering immediate value."
            ),
            agent=topic_selection_agent,
            expected_output=""" 
            A JSON object with the following structure:
            {
            "topic":"a single string containing the selected agricultural topic."
            }
            """
        )

        content_and_metadata_task = Task(
            description=(
                "Create a concise and engaging social media post for the selected agricultural topic. "
                "The content should be practical, actionable, and limited to 500 characters. "
                "Include 2-5 relevant tags and 1-3 authoritative reference links to credible sources."
            ),
            agent=content_and_metadata_agent,
            expected_output="""
            A JSON object with the following structure:

                "content": "Short, engaging social media content (maximum 500 characters)",
                "tags": ["tag1", "tag2", "tag3", ...],
                "references": [
                    "Reference link 1 (preferably from .edu, .gov, or reputable agricultural organizations)",
                    "Reference link 2",
                    "Reference link 3",
                    ...
                ]
            """
        )

        crew = Crew(
            agents=[topic_selection_agent, content_and_metadata_agent],
            tasks=[topic_selection_task, content_and_metadata_task],
            verbose=True
        )
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
        
        result = crew.kickoff()
        #the problem is here...
        # Parse the results
        topic_selection= parse_task_result(topic_selection_task,TopicSelectionOutput)
        content_and_metadata = parse_task_result(content_and_metadata_task, ContentAndMetadataOutput)
            
        return {
            "topic": topic_selection.topic,
            "content": content_and_metadata.content,
            "tags": content_and_metadata.tags,
            "references": content_and_metadata.references
        }
    def generate_image_prompt(self, topic: str, content: str) -> str:
        return (
            f"Create a hyper-realistic, post thumbnail for the agricultural topic: '{topic}'. "
            f"The image should be visually stunning, capturing attention immediately with one key element that perfectly represents the essence of the course. "
            f"Include intricate and lifelike details that highlight the main theme from the post content, such as {content[:100]}... "
            f"Use keywords like 'hyper-realism,' 'vivid,' 'detailed,' 'immersive,' and 'impactful' to ensure the thumbnail is both awe-inspiring and clearly communicates the core idea of the course in an unforgettable way."
        )
