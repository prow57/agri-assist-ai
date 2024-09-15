# croplibrary.py
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

class CropInfoManager:
    def __init__(self, output_file='crop_info_output.json'):
        self.openai_api_key = openai_api_key
        self.serper_api_key = serper_api_key
        self.output_file = output_file
        self.processed_crops = self.load_processed_crops()

    def get_serper_info(self, crop_name):
        url = "https://google.serper.dev/search"
        payload = json.dumps({
            "q": f"for farmers {crop_name} crop information in malawi"
        })
        headers = {
            'X-API-KEY': self.serper_api_key,
            'Content-Type': 'application/json'
        }
        response = requests.request("POST", url, headers=headers, data=payload)
        return response.json()

    def get_crop_info(self, crop_name):
        serper_info = self.get_serper_info(crop_name)
        
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
                    "content": "You are a Crop Information Specialist. Provide detailed, accurate, and comprehensive information about crops to help farmers make informed decisions."
                },
                {
                    "role": "user",
                    "content": f"""Provide detailed information about {crop_name} based on this search result: {json.dumps(serper_info)}. If not specified in search results just answer from your knowledge. Format the response as a JSON object with the following structure:
                        {{
                        "crop_name": "<string>",                  // Name of the crop
                        "scientific_name": "<string>",            // Scientific name of the crop
                        "description": "<string>",                // friendly Description of the crop
                        "planting_information": {{
                            "optimal_planting_time": "<string>",    // Optimal time for planting (e.g., "Spring", "Summer", "Autumn", "Winter")
                            "geographic_location": [
                            {{
                                "region": "<string>",               // Region where the crop is grown (e.g., "North America", "Europe", "Asia")
                                "climate_type": "<string>",         // Climate type (e.g., "Tropical", "Subtropical", "Temperate", "Arid", "Polar")
                                "soil_type": "<string>",            // Soil type (e.g., "Loamy", "Clay", "Sandy", "Silty", "Peaty", "Saline")
                                "recommended_varieties": [
                                "<string>"                      // Recommended variety 1 (e.g., "Hard Red Winter", "Soft Red Winter")
                                ]
                            }}
                            ],
                            "seeding_rate": "<string>",             // Seeding rate (e.g., "120-150 kg/ha")
                            "planting_depth": "<string>"            // Planting depth (e.g., "2-3 cm")
                        }},
                        "growth_cycle": {{
                            "germination_period": "<string>",       // Germination period (e.g., "7-10 days")
                            "vegetative_stage": "<string>",         // Duration of vegetative stage (e.g., "30-40 days")
                            "flowering_period": "<string>",         // Flowering period (e.g., "20-25 days")
                            "maturation_period": "<string>"         // Maturation period (e.g., "30-40 days")
                        }},
                        "pests_and_diseases": [
                            {{
                            "name": "<string>",                   // Name of the pest or disease (e.g., "Rust", "Aphids")
                            "type": "<string>",                   // Type of the pest or disease (e.g., "Fungal", "Bacterial", "Viral", "Insect", "Nematode")
                            "symptoms": "<string>",               // Symptoms caused by the pest or disease (e.g., "Yellow-orange spots on leaves", "Curling leaves, honeydew")
                            "prevention": "<string>",             // Prevention methods (e.g., "Resistant varieties", "Proper spacing", "Natural predators", "Crop rotation")
                            "treatment": "<string>"               // Treatment methods (e.g., "Fungicide application", "Insecticide application", "Organic treatments")
                            }}
                        ],
                        "watering_requirements": {{
                            "frequency": "<string>",                // Frequency of watering (e.g., "Every 7-10 days", "Daily", "Every 2 weeks")
                            "method": [
                            "<string>"                          // Watering method 1 (e.g., "Drip irrigation", "Sprinkler", "Surface irrigation", "Subsurface irrigation")
                            ],
                            "amount": "<string>"                   // Amount of water required (e.g., "25-35 mm per week", "1-2 liters per plant")
                        }},
                        "nutrient_requirements": {{
                            "fertilizer_type": [
                            {{
                                "name": "<string>",                // Name of the fertilizer (e.g., "Nitrogen", "Phosphorus", "Potassium", "Calcium", "Magnesium")
                                "application_rate": "<string>"     // Application rate (e.g., "50-100 kg/ha")
                            }}
                            ],
                            "soil_pH": "<string>"                  // Soil pH range (e.g., "6.0-7.0", "5.5-6.5")
                        }},
                        "harvesting_information": {{
                            "harvest_time": "<string>",             // Time of harvesting (e.g., "Late spring to early summer", "Fall")
                            "indicators": "<string>",               // Indicators of readiness for harvest (e.g., "Grain moisture content 12-14%", "Color change")
                            "methods": "<string>"                  // Harvesting methods (e.g., "Combine harvesting", "Manual harvesting")
                        }},
                        "storage_information": {{
                            "conditions": "<string>",               // Storage conditions (e.g., "Cool, dry place", "Well-ventilated area")
                            "shelf_life": "<string>",               // Shelf life of the crop (e.g., "6-12 months", "1 year")
                            "pests": [
                            "<string>"                         // Pest 1 (e.g., "Grain weevils", "Moths")
                            ]
                        }},
                        "market_information": {{
                            "average_yield": "<string>",            // Average yield (e.g., "3-4 tons/ha", "2.5-3 tons/ha")
                            "market_price": "<string>",             // Market price (e.g., "200-250 USD/ton", "150-200 USD/ton")
                            "demand_trends": "<string>"             // Trends in market demand (e.g., "High demand in baking industry", "Stable demand")
                        }},
                        "related_crops": [
                            "<string>"                             // Related crop 1 (e.g., "Barley", "Rye")
                        ],
                        "additional_resources": [
                            {{
                            "type": "<string>",                  // Type of resource (e.g., "Website", "Research Paper", "Book")
                            "link": "<string>",                  // Link to the resource
                            "title": "<string or null>"          // Title of the resource (nullable for non-paper resources)
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
        openai_response=response.json()
        content = openai_response['choices'][0]['message']['content']
        return json.loads(content)

    def load_processed_crops(self):
        # Load processed crop names from the existing JSON file, if it exists
        if os.path.exists(self.output_file):
            with open(self.output_file, 'r') as file:
                data = json.load(file)
                return {crop['crop_name'] for crop in data}
        return set()

    def append_to_json_file(self, data):
        # Append the new crop data to the JSON file
        if not os.path.exists(self.output_file):
            with open(self.output_file, 'w') as file:
                json.dump([], file)  # Create an empty JSON array if file does not exist

        with open(self.output_file, 'r+') as file:
            existing_data = json.load(file)
            existing_data.append(data)
            file.seek(0)
            json.dump(existing_data, file, indent=2)

    def get_crop_description(self, crop_name):
        if not crop_name or crop_name.strip() == "":
            raise ValueError("Crop name is required and cannot be empty.")

        crop_name = crop_name.strip()
        if crop_name in self.processed_crops:
            # Read the existing data and return the description if it exists
            with open(self.output_file, 'r') as file:
                data = json.load(file)
                for crop in data:
                    if crop['crop_name'].lower() == crop_name.lower():
                        return crop
            # If we get here, the crop wasn't found in the file
            return None
        else:
            # Fetch new data if not already processed
            print(f"Fetching data for crop: {crop_name}")
            crop_info = self.get_crop_info(crop_name)
            self.append_to_json_file(crop_info)
            self.processed_crops.add(crop_name)
            return crop_info
