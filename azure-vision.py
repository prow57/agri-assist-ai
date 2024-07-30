import os
import io
from dotenv import load_dotenv
load_dotenv()
import time
from msrest.authentication import CognitiveServicesCredentials
from azure.cognitiveservices.vision.computervision import ComputerVisionClient
from azure.cognitiveservices.vision.computervision.models import OperationStatusCodes, VisualFeatureTypes
import requests # pip install requests
from PIL import Image, ImageDraw, ImageFont
ENDPOINT=os.getenv("AZURE_OPENAI_VISION_ENDPOINT")
API_KEY=os.getenv("AZURE_OPENAI_VISION_KEY")

computervision_client = ComputerVisionClient(ENDPOINT, CognitiveServicesCredentials(API_KEY))

remote_image_url = "https://www.almanac.com/sites/default/files/styles/or/public/image_nodes/early-blight-AmBNPHOTO-ss.jpeg"
'''
Describe an Image - remote
This example describes the contents of an image with the confidence score.
'''
print("===== Describe an image - remote =====")
# Call API
description_results = computervision_client.describe_image(remote_image_url,prompt="can you detect the crop")

# Get the captions (descriptions) from the response, with confidence level
print("Description of remote image: ")
if len(description_results.captions) == 0:
    print("No description detected.")
else:
    for caption in description_results.captions:
        print("'{}' with confidence {:.2f}%".format(caption.text, caption.confidence * 100))
print()
'''
Describe an Image - local
This example describes the contents of an image with the confidence score.
'''
# print("===== Describe an Image - local =====")
# # Open local image file
# local_image_path = "Images/Landmark.jpg"
# local_image = open(local_image_path, "rb")
#
# # Call API
# description_result = computervision_client.describe_image_in_stream(local_image)
#
# # Get the captions (descriptions) from the response, with confidence level
# print("Description of local image: ")
# if len(description_result.captions) == 0:
#     print("No description detected.")
# else:
#     for caption in description_result.captions:
#         print("'{}' with confidence {:.2f}%".format(caption.text, caption.confidence * 100))
#
# '''
# END - Describe an Image - local
# '''
#
