# livestocklibrary.py
import warnings
warnings.filterwarnings('ignore')

from dotenv import load_dotenv
load_dotenv()
import os
import base64
import requests
import json
import re
from pydantic import BaseModel

# API Keys
openai_api_key = os.getenv("OPENAI_API_KEY")
serper_api_key = os.getenv("SERPER_API_KEY")

class LivestockInfoManager:
    def __init__(self, output_file='livestock_info_output.json'):
        self.openai_api_key = openai_api_key
        self.serper_api_key = serper_api_key
        self.output_file = output_file
        self.processed_livestock = self.load_processed_livestock()

    def get_serper_info(self, livestock_name):
        url = "https://google.serper.dev/search"
        payload = json.dumps({
            "q": f"for farmers {livestock_name} livestock information in malawi"
        })
        headers = {
            'X-API-KEY': self.serper_api_key,
            'Content-Type': 'application/json'
        }
        response = requests.request("POST", url, headers=headers, data=payload)
        return response.json()

    def get_livestock_info(self, livestock_name):
        serper_info = self.get_serper_info(livestock_name)
        
        headers = {
            "Content-Type": "application/json",
            "Authorization": f"Bearer {self.openai_api_key}"
        }

        payload = {
            "model": "gpt-4o",
            "response_format": {"type": "json_object"},
            "messages": [
                {
                    "role": "system",
                    "content": "You are a Livestock Information Specialist. Provide detailed, accurate, and comprehensive information about livestock to help farmers make informed decisions."
                },
                {
                    "role": "user",
                    "content": f"""Provide detailed information about {livestock_name} based on this search result: {json.dumps(serper_info)}. If not specified in search results just answer from your knowledge. Format the response as a JSON object with the following structure:
                        {{
                            "livestock_name": "<string>",
                            "scientific_name": "<string>",
                            "description": "<string>",
                            "care_information": {{
                                "optimal_housing_conditions": {{
                                    "space_requirements": "<string>",
                                    "temperature_range": "<string>",
                                    "ventilation": "<string>"
                                }},
                                "feeding_requirements": {{
                                    "diet_type": "<string>",
                                    "feed_frequency": "<string>",
                                    "special_nutrients": [
                                        "<string>"
                                    ]
                                }},
                                "health_care": {{
                                    "common_diseases": [
                                        {{
                                            "name": "<string>",
                                            "symptoms": "<string>",
                                            "prevention": "<string>",
                                            "treatment": "<string>"
                                        }}
                                    ],
                                    "vaccination_schedule": [
                                        {{
                                            "vaccine": "<string>",
                                            "age_to_vaccinate": "<string>"
                                        }}
                                    ]
                                }},
                                "breeding_information": {{
                                    "breeding_season": "<string>",
                                    "gestation_period": "<string>",
                                    "offspring_care": "<string>"
                                }}
                            }},
                            "production_information": {{
                                "milk_or_eggs": {{
                                    "yield_per_day": "<string>",
                                    "quality_parameters": "<string>"
                                }},
                                "meat": {{
                                    "average_weight": "<string>",
                                    "market_value": "<string>"
                                }}
                            }},
                            "market_information": {{
                                "market_demand": "<string>",
                                "price_trends": "<string>"
                            }},
                            "related_livestock": [
                                "<string>"
                            ],
                            "additional_resources": [
                                {{
                                    "type": "<string>",
                                    "link": "<string>",
                                    "title": "<string or null>"
                                }}
                            ]
                        }}
                    Provide concise answers, focus on factual information.
                    """
                }
            ],
            "max_tokens": 1500
        }

        response = requests.post("https://api.openai.com/v1/chat/completions", headers=headers, json=payload)
        openai_response = response.json()
        content = openai_response['choices'][0]['message']['content']
        return json.loads(content)

    def load_processed_livestock(self):
        if os.path.exists(self.output_file):
            with open(self.output_file, 'r') as file:
                data = json.load(file)
                return {livestock['livestock_name'] for livestock in data}
        return set()

    def append_to_json_file(self, data):
        if not os.path.exists(self.output_file):
            with open(self.output_file, 'w') as file:
                json.dump([], file)

        with open(self.output_file, 'r+') as file:
            existing_data = json.load(file)
            existing_data.append(data)
            file.seek(0)
            json.dump(existing_data, file, indent=2)

    def get_livestock_description(self, livestock_name):
        if not livestock_name or livestock_name.strip() == "":
            raise ValueError("Livestock name is required and cannot be empty.")

        livestock_name = livestock_name.strip()
        if livestock_name in self.processed_livestock:
            with open(self.output_file, 'r') as file:
                data = json.load(file)
                for livestock in data:
                    if livestock['livestock_name'].lower() == livestock_name.lower():
                        return livestock
            return None
        else:
            print(f"Fetching data for livestock: {livestock_name}")
            livestock_info = self.get_livestock_info(livestock_name)
            self.append_to_json_file(livestock_info)
            self.processed_livestock.add(livestock_name)
            return livestock_info