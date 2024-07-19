# agri-assist-ai

Open-TechZ hackathon group

### Project Description: AgriVision AI

**Project Name:** AgriAssist AI

**Overview:**
AgriAssist-AI is an innovative AI-driven agricultural advisory and system designed to empower farmers with advanced tools for optimizing their farming practices. Making use of  cutting-edge technologies in machine learning and computer vision, AgriAssist-AI provides real-time insights and recommendations to enhance crop health, soil quality, and overall farm productivity.

**Project Structure:**
This repository is structured as follows:

backend/: This directory contains the backend code of the agriAssist-AI platform, including the API endpoints, database models, and business logic implemented in Python using the Flask framework.
frontend/: On this branch you will find the frontend code for the AgriAssist-AI platform, implemented using JavaScript, React, and Dart. 
model-ai/: This directory contains the trained Generative AI models used by Afrochat to enhance the platform's capabilities. The models are implemented using Python-based AI/ML libraries, and they play a crucial role in solving specific problems such as visual question answering (VQA).
datalibrary/: This directory contains the source data library for training AI and ML models


**Key Features:**
1. **Leaf Scanning:**
   - Utilize advanced AI image processing and machine learning techniques to detect and diagnose leaf diseases.
   - Provide farmers with actionable recommendations for treating and preventing crop diseases.

2. **Soil Detection:**
   - Analyze soil samples using AI models to determine soil health and nutrient levels.
   - Offer tailored advice on soil management practices to improve crop yield.

3. **Weather Updates:**
   - Integrate with reliable weather APIs to provide real-time weather forecasts and alerts.
   - Help farmers plan their activities based on accurate weather predictions.

4. **Market Prices:**
   - Provide up-to-date market prices for various crops to help farmers make informed selling decisions.
   - Integrate with local market data providers and governmental agricultural departments.

5. **USSD Access:**
   - Enable farmers to access key features and information via USSD, ensuring accessibility even without internet connectivity.
   - Offer a simple and intuitive interface for farmers to interact with the system using basic mobile phones.

6. **Personalized Advice:**
   - **Input:** Text-based input for describing issues and receiving advice.
   - **Response:** Text-based AI-generated advice based on the specific agriculture farming data that it has been trained.

**Technical Implementation:**
- **Frontend:** Developed using Flutter for cross-platform mobile application, ensuring a seamless user experience on both Android and iOS devices.
- **Backend:** Built with NodeJs for high performance and scalability, supporting RESTful APIs for communication between frontend and backend.
- **AI/ML:** Implemented using OpenCV and Tenarflow for developing and training models for leaf scanning and soil detection, and OpenCV for image processing.
- **Database:** Firebase Firestore for real-time data storage and offline capabilities.
- **Cloud Hosting:** Deployed on AWS for robust and scalable cloud infrastructure.
- **USSD Integration:** Using Twilio or Africa's Talking for USSD and SMS functionalities.

**Impact:**
AgriAssist-AI aims to revolutionize the agricultural sector by providing farmers with the tools and insights they need to make data-driven decisions. By enhancing crop health, improving soil quality, and offering timely weather and market information, AgriVision AI empowers farmers to increase productivity, reduce costs, and ultimately achieve better yields and profitability.

**Target Users:**
- Small to medium-scale farmers seeking to optimize their farming practices.
- Agricultural extension officers providing support and advice to farmers.
- Agribusinesses looking to leverage technology for improved farm management.

**Goal:**
To create a sustainable and prosperous agricultural ecosystem by harnessing the power of artificial intelligence and making advanced agricultural insights accessible to every farmer.