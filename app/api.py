import warnings
import logging
import os
import base64
import io
import json
from PIL import Image
from dotenv import load_dotenv
from fastapi import FastAPI
from fastapi.responses import JSONResponse
import uvicorn
from openai import OpenAI
from app.leafanalyser import LeafAnalyser
from app.coursegenerator import CourseGenerator
from fastapi import HTTPException
from app.crew import main_crew
from app.tasks import disease_research_task, guidance_generation_task
from app.validator import *
# Suppress warnings and set logging level
warnings.filterwarnings("ignore", message="Overriding of current TracerProvider is not allowed")
logging.getLogger("opentelemetry").setLevel(logging.ERROR)

# Load environment variables
load_dotenv()

# Initialize FastAPI app
app = FastAPI()
leaf_image_analysis_agent = LeafAnalyser()

@app.post("/analyze-leaf/")
async def analyze_leaf(request: ImageRequest):
    print("step 1:done")
    leaf_analyser = LeafAnalyser()

    print("step 2:done")
    leaf_analysis_result = leaf_analyser.run(request)

    # Check if leaf_analysis_result is already a dict
    if not isinstance(leaf_analysis_result, dict):
        # If it's not a dict, assume it's a JSON string and parse it
        leaf_analysis_dict = json.loads(leaf_analysis_result)
    else:
        # If it's already a dict, use it directly
        leaf_analysis_dict = leaf_analysis_result

    leaf_analysis = LeafImageAnalysisOutput(**leaf_analysis_dict)
    
    # Prepare inputs for main_crew
    crew_inputs = {
        "disease_name": leaf_analysis.disease_name,
        "crop_type": leaf_analysis.crop_type,
        "percentage": leaf_analysis.percentage,
        "estimated_size": leaf_analysis.estimated_size
    }

    if crew_inputs["disease_name"] == "None" or crew_inputs["crop_type"] == "Unknown":
        output_leaf_analysis = {"leaf_analysis": crew_inputs}
        return JSONResponse(content=output_leaf_analysis)

    # Perform disease research and guidance generation
    main_crew_result = main_crew.kickoff(inputs=crew_inputs)

    print("step 8:done")
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

    disease_research = parse_task_result(disease_research_task, DiseaseResearchOutput)
    guidance_generation = parse_task_result(guidance_generation_task, GuidanceGenerationOutput)

    # Compile final output
    cumulative_output = CumulativeOutput(
        leaf_analysis=leaf_analysis,
        disease_research=disease_research,
        guidance_generation=guidance_generation
    )

    return JSONResponse(content=cumulative_output.dict())


@app.post("/course-generation/")
async def course_generation(request: CourseRequest):
    coursegenerator = CourseGenerator()
    
    # Generate a new course
    course_result = coursegenerator.generate_course(request.history)
    
    if not course_result:
        raise HTTPException(status_code=400, detail="Unable to generate a new unique course")
    
    # Generate image prompt
    image_prompt = coursegenerator.generate_image_prompt(course_result['topic'], course_result['content'])
    
    # Generate image using DALL-E 3
    image_url = generate_image(image_prompt)
    
    # Prepare the response
    response = {
        "topic": course_result['topic'],
        "content": course_result['content'],
        "tags": course_result['tags'],
        "references": course_result['references'],
        "image_url": image_url
    }
    
    return JSONResponse(content=response)

def generate_image(prompt: str) -> str:
    try:
        client = OpenAI()
        response = client.images.generate(
            model="dall-e-3",
            prompt=prompt,
            size="720x960",
            quality="standard",
            n=1,
        )
        return response.data[0].url
    except Exception as e:
        print(f"Error generating image: {str(e)}")
        return "https://placeholder.com/image?text=Image+generation+failed"

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)