# Agri-Assist-AI

Open-TechZ Hackathon Group

### Project Description: AgriAssist AI

**Project Name:** AgriAssist AI

**Overview:**
AgriAssist-AI is an innovative AI-driven agricultural advisory system designed to empower farmers with advanced tools for optimizing their farming practices. Leveraging cutting-edge technologies in machine learning and computer vision, AgriAssist AI provides real-time insights and recommendations to enhance crop health, soil quality, and overall farm productivity.

**Key Features:**
1. **Leaf Scanning:**
   - Utilize advanced image processing and machine learning techniques to detect and diagnose leaf diseases.
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
   - **Response:** Text-based AI-generated advice.

**Technical Implementation:**
- **Frontend:** Developed using Flutter for a cross-platform mobile application, ensuring a seamless user experience on both Android and iOS devices.
- **Backend:** Built with Node.js for high performance and scalability, supporting RESTful APIs for communication between frontend and backend.
- **AI/ML:** Implemented using TensorFlow for developing and training models for leaf scanning and soil detection, and OpenCV for image processing.
- **Database:** Firebase Firestore for real-time data storage and offline capabilities.
- **Cloud Hosting:** Deployed on AWS for robust and scalable cloud infrastructure.
- **USSD Integration:** Leveraging Twilio or Africa's Talking for USSD and SMS functionalities.

**Impact:**
AgriAssist AI aims to revolutionize the agricultural sector by providing farmers with the tools and insights they need to make data-driven decisions. By enhancing crop health, improving soil quality, and offering timely weather and market information, AgriAssist AI empowers farmers to increase productivity, reduce costs, and ultimately achieve better yields and profitability.

**Target Users:**
- Small to medium-scale farmers seeking to optimize their farming practices.
- Agricultural extension officers providing support and advice to farmers.
- Agribusinesses looking to leverage technology for improved farm management.

**Vision:**
To create a sustainable and prosperous agricultural ecosystem by harnessing the power of artificial intelligence and making advanced agricultural insights accessible to every farmer.

## Getting the AI Model Locally

To get the AgriAssist AI model running locally, follow these steps:

1. **Clone the Project:**
   ```bash
   git clone https://github.com/prow57/agri-assist-ai.git
   ```
2. **Navigate to the Project Directory:**
   ```bash
   cd agri-assist-ai
   ```
3. **Install Python Virtual Environment:**
   ```bash
   python3 -m venv venv
   ```
4. **Activate the Virtual Environment:**
   - On Windows:
     ```bash
     venv\Scripts\activate
     ```
   - On macOS/Linux:
     ```bash
     source venv/bin/activate
     ```
5. **Install the Required Dependencies:**
   ```bash
   pip install -r requirements.txt
   ```
6. **Setup Environment Variables:**
   ```bash
   cp .env.example .env
   ```
   - Fill in the environment variables in the `.env` file.

7. **Run the Application:**
   ```bash
   uvicorn api:app --reload
   ```
