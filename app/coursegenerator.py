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
            role="Agricultural Course Innovator",
            goal="Identify practical and impactful agricultural course topics",
            backstory="A seasoned agronomist with a passion for empowering farmers through education, specializing in practical solutions and innovative techniques for everyday challenges",
            tools=[self.search_tool],
            verbose=True
        )

        content_and_metadata_agent = Agent(
            role="Practical Agricultural Course Developer",
            goal="Develop actionable course content, practical tips, and valuable references for the chosen topic",
            backstory="An expert in agricultural practices with a strong background in curriculum development and hands-on farming experience, dedicated to creating courses that empower farmers with useful skills and knowledge",
            tools=[self.search_tool, self.scrape_tool],
            verbose=True
        )

        topic_selection_task = Task(
            description=(
                f"Identify a new agricultural course topic not present in this list: {', '.join(history)}. "
                "The topic should focus on providing farmers with practical tips, tricks, and advice for solving daily challenges. "
                "It should include specific information about managing common diseases, optimizing crop yields, or innovative farming techniques "
                "that are relevant, current, and beneficial for farmers' education."
            ),
            agent=topic_selection_agent,
            expected_output=""" 
            A JSON object with the following structure:
            {
            "topic":"a single string containing the selected agricultural course topic."
            }
            """
        )

        content_and_metadata_task = Task(
            description=(
                "Create a detailed course outline for the selected agricultural topic, focusing on practical applications and real-world scenarios. "
                "Identify key content points that include actionable tips and tricks for farmers, as well as 2-5 relevant tags and 1-3 authoritative reference links. "
                "Outline should include main sections, critical concepts, and strategies that can be directly applied by farmers to improve their daily operations."
            ),
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
        return (
            f"Design a visually striking and realistic course thumbnail for the agricultural topic: '{topic}'. "
            f"The image should be highly attractive and focus on one key element that encapsulates the essence of the course. "
            f"Include realistic details that highlight the main theme from the course content, such as {content[:100]}... "
            f"The thumbnail should be appealing and clearly convey the core idea of the course."
        )