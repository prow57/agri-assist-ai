import streamlit as st
import requests
import base64
from PIL import Image
import io
import json



def encode_image(image):
    buffered = io.BytesIO()
    image.save(buffered, format="PNG")
    return base64.b64encode(buffered.getvalue()).decode('utf-8')

def call_api(image):
    api_url = "http://localhost:8000/analyze-leaf/"  # Update this if your API is hosted elsewhere
    
    encoded_image = encode_image(image)
    payload = {"image": encoded_image}
    
    response = requests.post(api_url, json=payload)
    return response.json()

def display_results(results):
    st.header("Analysis Results")
    
    st.subheader("Leaf Analysis")
    leaf_analysis = results["leaf_analysis"]
    st.write(f"Crop Type: {leaf_analysis['crop_type']}")
    st.write(f"Disease Name: {leaf_analysis['disease_name']}")
    st.write(f"Description: {leaf_analysis['description']}")
    st.write(f"Risk Level: {leaf_analysis['level_of_risk']}")
    st.write(f"Health Percentage: {leaf_analysis['percentage']}%")
    st.write(f"Estimated Size: {leaf_analysis['estimated_size']}")
    st.write(f"Stage: {leaf_analysis['stage']}")
    st.write("Symptoms:")
    for symptom in leaf_analysis['symptoms']:
        st.write(f"- {symptom}")
    
    st.subheader("Disease Research")
    disease_research = results["disease_research"]
    st.write("Relevant Websites:")
    for website in disease_research['relevant_websites']:
        st.write(f"- {website}")
    st.write("General Information:")
    for info in disease_research['general_information']:
        st.write(f"- {info}")
    st.write("Recommended Treatments:")
    for treatment in disease_research['recommended_treatments']:
        st.write(f"- {treatment}")
    
    st.subheader("Treatment Guidance")
    guidance = results["guidance_generation"]
    st.write("Treatment Steps:")
    for step in guidance['treatment_steps']:
        st.write(f"- {step}")
    st.write("Ingredients:")
    for ingredient in guidance['ingredients']:
        st.write(f"- {ingredient}")

st.title("Crop Leaf Analysis")

uploaded_file = st.file_uploader("Choose a leaf image...", type=["jpg", "jpeg", "png"])

if uploaded_file is not None:
    image = Image.open(uploaded_file)
    image = image.resize((250, 250))
    st.image(image, caption='Uploaded Image', use_column_width=True)
    
    if st.button('Analyze'):
        with st.spinner('Analyzing...'):
            results = call_api(image)
        display_results(results)

st.sidebar.info("This application analyzes crop leaf images to identify diseases and provide treatment guidance.")