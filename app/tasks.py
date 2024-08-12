from crewai import Task
from app.agents import disease_research_agent, guidance_generation_agent

disease_research_task = Task(
    description="Research the identified disease '{disease_name}' for the crop type '{crop_type}' and extract relevant information.",
    expected_output="""A JSON object with a list of relevant websites, general information, and recommended treatments for the diagnosed disease.
            structure:
            
            relevant_websites: [
                  <string>,                          // URL to relevant website 1
                  <string>",                         // URL to relevant website 2
                ....
                ],general_information: [
                  <string>,                          // General information 1
                  <string>,                          // General information 2
                ...
                ],recommended_treatments: [
                  <string>,                          // Recommended treatment 1
                  <string>,                          // Recommended treatment 2
                ...
                ]
          
            do not give any additional text like feedbacks or comments
            Provide concise answers, focus on factual information.""",
    agent=disease_research_agent,
)

guidance_generation_task = Task(
    description="Generate treatment guidance for '{disease_name}' on '{crop_type}' with an estimated size of '{estimated_size}'.",
    expected_output="""A JSON object with the treatment steps and ingredients.
                    structure:
                
                 treatment_steps: [
                   <string>,                          // Treatment step 1
                   <string>,                          // Treatment step 2
                 ...
                 ],
                 ingredients: [
                   <string>,                          // Ingredient name and quantity
                   <string>,                          // Ingredient name and quantity
                 ...
                 ]
                
            do not give any additional text like feedbacks or comments
            Provide concise answers, focus on factual information.""",
    agent=guidance_generation_agent,
)