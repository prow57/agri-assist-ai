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
            goal="Identify engaging and impactful agricultural topics for comprehensive online courses",
            backstory="A seasoned agronomist with a Ph.D. in Agricultural Sciences and 15 years of experience in both academic research and practical farming. Known for identifying cutting-edge agricultural trends and translating complex concepts into accessible learning materials.",
            tools=[self.search_tool],
            verbose=True
        )

        content_and_metadata_agent = Agent(
            role="Agricultural Course Creator",
            goal="Develop comprehensive, engaging, and practical online courses on agricultural topics with detailed content",
            backstory="An expert in agricultural education with a Master's in Instructional Design and a background in developing award-winning e-learning materials for agricultural universities and extension programs. Skilled at creating immersive learning experiences that combine theoretical knowledge with hands-on applications.",
            tools=[self.search_tool, self.scrape_tool],
            verbose=True
        )

        topic_selection_task = Task(
            description=(
                f"Identify a new agricultural topic not present in this list: [{', '.join(history)}]. "
                "The topic should be specific and suitable for a detailed course, focusing on providing farmers with in-depth knowledge and practical skills. "
                "It could cover a specific crop, season, commonly faced problem, specific disease, or insect. "
                "It should address current challenges or innovations in agriculture, aiming to significantly improve farming practices or sustainability."
            ),
            agent=topic_selection_agent,
            expected_output=""" 
            A JSON object with the following structure:
            {
            "topic":"a single string containing the selected agricultural topic for a comprehensive course."
            }
            """
        )

        content_and_metadata_task = Task(
            description=(
                "Create a detailed and comprehensive course on the selected agricultural topic. The course should be structured in Markdown format as follows:\n\n"
                "# [Course Title]\n\n"
                "## Course Description\n"
                "[Provide a detailed overview of the course, its importance, and what learners will gain. (150-200 words)]\n\n"
                "## Learning Objectives\n"
                "[List 4-6 specific, measurable learning objectives]\n\n"
                "## Course Outline\n"
                "[Provide a brief overview of the main sections of the course]\n\n"
                "## Introduction\n"
                "[Detailed introduction to the topic, including its significance in agriculture, historical context, and current relevance. (400-500 words)]\n\n"
                "## [Main Section 1]\n"
                "[Detailed content for the first main section, including subsections, examples, and practical applications. (800-1000 words)]\n\n"
                "## [Main Section 2]\n"
                "[Detailed content for the second main section, including subsections, examples, and practical applications. (800-1000 words)]\n\n"
                "## [Main Section 3]\n"
                "[Detailed content for the third main section, including subsections, examples, and practical applications. (800-1000 words)]\n\n"
                "## Practical Application\n"
                "[Provide detailed, step-by-step instructions for a hands-on activity or real-world application of the course content. (400-500 words)]\n\n"
                "## Conclusion\n"
                "[Summarize key points, reinforce main takeaways, and provide guidance for further learning or implementation. (300-400 words)]\n\n"
                "## Additional Resources\n"
                "[List and briefly describe 5-7 supplementary materials (e.g., videos, articles, tools) for further learning]\n\n"
                "Ensure the content is practical, actionable, and engaging. Use clear, concise language suitable for online learning. "
                "Include relevant examples, case studies, and current best practices throughout the course. "
                "Add 5-7 relevant tags and 3-5 authoritative reference links to credible sources (preferably .edu, .gov, or reputable agricultural organizations)."
            ),
            agent=content_and_metadata_agent,
            expected_output="""
            A JSON object with the following structure:
            {
                "content": "Full detailed markdown structured course content as specified in the description",
                "tags": ["tag1", "tag2", "tag3", ...],
                "references": [
                    "Reference link 1",
                    "Reference link 2",
                    "Reference link 3",
                    ...
                ]
            }
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
        
        topic_selection = parse_task_result(topic_selection_task, TopicSelectionOutput)
        content_and_metadata = parse_task_result(content_and_metadata_task, ContentAndMetadataOutput)

        return {
            "topic": topic_selection.topic,
            "content": content_and_metadata.content,
            "tags": content_and_metadata.tags,
            "references": content_and_metadata.references
        }

    def generate_image_prompt(self, topic: str, content: str) -> str:
        return (
            f"Create a visually stunning course thumbnail for the agricultural topic: '{topic}'. "
            f"The image should be eye-catching and professional, suitable for an online learning platform. "
            f"It should feature a central element that encapsulates the essence of the course, surrounded by subtle visual cues representing various aspects of the curriculum. "
            f"Style: Photorealistic, highly detailed, with a modern and clean look. "
            f"Composition: Cinematic, with thoughtful use of depth of field to draw focus to the main subject. "
            f"Lighting: Use dramatic lighting to create a sense of importance and engagement. "
            f"Color Palette: Choose colors that reflect the agricultural theme while remaining vibrant and attractive. "
            f"Text Integration: Leave space for potential course title overlay. "
            f"Technical Specifications: Ultra high resolution (8K), HDR, suitable for both digital displays and print materials. "
            f"Overall Mood: Inspiring, educational, and professional, conveying the value and depth of the course content."
        )