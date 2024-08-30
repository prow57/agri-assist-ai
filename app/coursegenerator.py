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
            role="African Agricultural Content Curator",
            goal="Identify relevant and impactful agricultural topics for traditional farmers in Malawi and Africa",
            backstory="An experienced agronomist with deep knowledge of traditional African farming practices and 20 years of experience working with smallholder farmers across various African countries. Specializes in identifying practical, low-tech solutions to common agricultural challenges in the region.",
            tools=[self.search_tool],
            verbose=True
        )

        content_and_metadata_agent = Agent(
            role="African Agricultural Course Creator",
            goal="Develop comprehensive, practical, and easily applicable courses for traditional farmers in Malawi and Africa",
            backstory="An agricultural extension expert with extensive experience in creating educational materials for rural African communities. Skilled at translating complex agricultural concepts into simple, actionable advice that respects local traditions and resources.",
            tools=[self.search_tool, self.scrape_tool],
            verbose=True
        )

        topic_selection_task = Task(
            description=(
                f"Identify a new agricultural topic not present in this list: [{', '.join(history)}]. "
                "The topic should be highly relevant for traditional farmers in Malawi or Africa in general. "
                "Focus on issues that can be addressed with locally available resources and simple techniques. "
                "Consider topics related to specific local crops, common pests or diseases, soil management, water conservation, "
                "or sustainable farming practices that don't require advanced technologies. "
                "The topic should address real challenges faced by smallholder farmers and offer practical, low-cost solutions."
            ),
            agent=topic_selection_agent,
            expected_output=""" 
            A JSON object with the following structure:
            {
            "topic":"a single string containing the selected agricultural topic relevant for traditional African farmers."
            }
            """
        )

        content_and_metadata_task = Task(
            description=(
                "Create a detailed and comprehensive course on the selected agricultural topic, specifically tailored for traditional farmers in Malawi or Africa. "
                "The course must be relevant to their context, simple to apply with existing infrastructure, and not require advanced technologies. "
                "Use clear, simple language and plenty of practical examples. Structure the course in Markdown format as follows:\n\n"
                "# [Course Title in Simple, Clear Language]\n\n"
                "## Course Description\n"
                "[Provide a detailed overview of the course, its importance for African farmers, and what they will gain. Emphasize practical, low-cost applications. (150-200 words)]\n\n"
                "## Learning Objectives\n"
                "[List 4-6 specific, achievable learning objectives relevant to traditional African farming contexts]\n\n"
                "## Course Outline\n"
                "[Provide a brief overview of the main sections of the course, using simple terms]\n\n"
                "## Introduction\n"
                "[Introduce the topic, explaining its significance in African agriculture. Include local context and traditional practices. (400-500 words)]\n\n"
                "## [Main Section 1]\n"
                "[Detailed content for the first main section, including subsections, local examples, and practical applications using available resources. (800-1000 words)]\n\n"
                "## [Main Section 2]\n"
                "[Detailed content for the second main section, focusing on low-tech, affordable solutions. Include step-by-step instructions and tips. (800-1000 words)]\n\n"
                "## [Main Section 3]\n"
                "[Detailed content for the third main section, addressing common challenges and offering simple, effective solutions. (800-1000 words)]\n\n"
                "## Practical Application\n"
                "[Provide detailed, step-by-step instructions for a hands-on activity using locally available materials. Include alternatives for different resources. (400-500 words)]\n\n"
                "## Conclusion\n"
                "[Summarize key points, reinforce main takeaways, and provide guidance for implementation in local farming contexts. (300-400 words)]\n\n"
                "## Additional Resources\n"
                "[List and briefly describe 5-7 supplementary materials, focusing on resources accessible in rural African settings (e.g., local extension services, radio programs, community workshops)]\n\n"
                "Ensure the content is practical, actionable, and relevant to traditional African farming contexts. "
                "Use clear, simple language and avoid technical jargon. Include local examples, traditional wisdom, and culturally appropriate practices. "
                "Focus on solutions that can be implemented with minimal resources and basic tools. "
                "Add 5-7 relevant tags and 3-5 reference links to credible sources, preferably including African agricultural organizations or local extension services."
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
                    return output_model.parse_obj(result)
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
            f"Create a visually engaging course thumbnail for the agricultural topic: '{topic}', specifically designed for traditional farmers in Malawi or Africa. "
            f"The image should be culturally appropriate and easily recognizable to rural African communities. "
            f"Feature a central element that represents a common farming practice or tool used in traditional African agriculture. "
            f"Include visual cues that reflect the local environment, crops, and farming methods. "
            f"Style: Realistic and relatable, with a warm and inviting feel. "
            f"Composition: Clear and straightforward, focusing on the main subject with minimal distractions. "
            f"Lighting: Natural, outdoor lighting that's typical of African farming settings. "
            f"Color Palette: Rich, earthy tones that reflect the African landscape and traditional farming contexts. "
            f"Text Integration: Leave space for a course title in a local language or simple English. "
            f"Overall Mood: Positive, empowering, and reflective of local agricultural practices and challenges. "
            f"Ensure the image is respectful of local cultures and accurately represents African farming contexts."
        )