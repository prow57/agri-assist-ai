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
            role="Agricultural Course Topic Selector",
            goal="Select a new and relevant agricultural course topic",
            backstory="Expert in agricultural education with deep knowledge of current trends and needs in the field",
            tools=[self.search_tool],
            verbose=True
        )

        content_and_metadata_agent = Agent(
            role="Agricultural Course Content and Metadata Creator",
            goal="Create comprehensive course content, tags, and references for the selected topic",
            backstory="Experienced agricultural educator with skills in curriculum development, research, and information organization",
            tools=[self.search_tool, self.scrape_tool],
            verbose=True
        )

        topic_selection_task = Task(
            description=f"Select a new agricultural course topic not present in this list: {', '.join(history)}. The topic should be relevant, current, and beneficial for agricultural education.",
            agent=topic_selection_agent,
            expected_output=""" A JSON object with the following structure:
            {
            "topic":"a single string containing the selected agricultural course topic."
            }
            """
        )

        content_and_metadata_task = Task(
            description="Create a detailed course outline, key content points, 5-10 relevant tags, and 3-5 authoritative reference links for the selected agricultural topic. Include main sections, important concepts, and practical applications.",
            agent=content_and_metadata_agent,
            expected_output="""
            A JSON object with the following structure:

                "content": "Detailed course outline and key content points",
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
        return f"An illustrative image representing the agricultural topic: {topic}. The image should incorporate key elements from the course content, including {content[:100]}..."