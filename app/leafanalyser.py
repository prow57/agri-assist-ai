# leafanalyser.py

import warnings
warnings.filterwarnings('ignore')

from dotenv import load_dotenv
load_dotenv()
import os

from pydantic import BaseModel
import base64
import requests
import json
import re
# OpenAI API Key
api_key = os.getenv("OPENAI_API_KEY")


class ImageRequest(BaseModel):
    image: str

class LeafAnalyser:
    def run(self, request: ImageRequest):
        base64_image = request.image
        
        print("step 3:done")
        headers = {
            "Content-Type": "application/json",
            "Authorization": f"Bearer {api_key}"
        }

        payload = {
            "model": "gpt-4o-mini",
            "response_format":{ "type": "json_object" },
            "messages": [
                {
                    "role": "system",
                    "content": [
                        {
                            "type": "text",
                            "text": """
            role:Leaf Image Analysis Agent,
            goal:
            Analyze the image of the crop leaf, identify the crop type, estimate size, and detect any diseases, providing a detailed description including level of risk, percentage of affected area, and disease stage.
            do not give any additional text like feedbacks or comments
            Provide concise answers, focus on factual information.
            backstory:
            You use advanced image processing and machine learning techniques to analyze crop images.
            you have been trained on a vast dataset of crop images and disease symptoms, enabling it to identify even subtle signs of disease.
            The agent's algorithms are designed to provide precise and reliable information to ensure farmers can trust the diagnosis.
            """
                        }
                    ]
                },
                {
                    "role": "user",
                    "content": [
                        {
                            "type": "text",
                            "text": """
                                    
            description:
            1. Analyze the image of the crop leaf provided by the user.
            2. Identify the type of crop, estimate its size, and detect the presence of any diseases.
            3. Provide information including the crop type, disease name, detailed description of the disease, level of risk, percentage of health of the spot, estimated size, the disease's stage and symptoms observed.

            expected_output:
            A JSON object with the crop type, disease name, detailed description of the disease, level of risk, percentage of health of the spot, estimated size, the disease's stage and symptoms observed.
            structure:
                {
                "crop_type": "<string>",               // Type of the crop
                "disease_name": "<string or None>",    // Name of the detected disease or None
                "description": "<string>",             // Detailed description of the disease
                "level_of_risk": "<string>",           // Level of risk (e.g., "Low", "Medium", "High")
                "percentage": <integer>,               // Percentage of health (0-100)
                "estimated_size": "<string>",          // Estimated size of the crop or area affected
                "stage": "<string or None>",           // Disease stage or None if healthy
                "symptoms": [
                "<string>",                          // Symptom 1
                "<string>"                           // Symptom 2
                ]
                }
                do not give any additional text like feedbacks or comments
                Provide concise answers, focus on factual information.
                            """
                        },
                        {
                            "type": "image_url",
                            "image_url": {
                                "url": f"data:image/jpeg;base64,{base64_image}"
                            }
                        }
                    ]
                }
            ],
            "max_tokens": 300
        }

        response = requests.post("https://api.openai.com/v1/chat/completions", headers=headers, json=payload)
        
        print("step 4:done")
         # Parse the response from the OpenAI Vision API
        openai_response = response.json()
        print(openai_response)
        print("step 5:done")
        return openai_response['choices'][0]['message']['content']

        # Extract JSON from the content
        json_match = re.search(r'```json\n(.*?)\n```', content, re.DOTALL)
        if json_match:
            json_string = json_match.group(1)
            leaf_analysis_result = json.loads(json_string)
        else:
            leaf_analysis_result = json.loads(content)  # Return the parsed JSON directly


        print("step 6:done")

        return leaf_analysis_result  # Return the parsed JSON directly
