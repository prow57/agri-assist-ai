import streamlit as st
import requests
import base64
from PIL import Image
import io
import json
import os

# File to store course history
COURSE_HISTORY_FILE = 'course_history.json'

def encode_image(image):
    buffered = io.BytesIO()
    image.save(buffered, format="PNG")
    return base64.b64encode(buffered.getvalue()).decode('utf-8')

def call_api(endpoint, payload):
    api_url = f"http://37.187.29.19:6932/{endpoint}"  # Update this if your API is hosted elsewhere
    response = requests.post(api_url, json=payload)
    return response.json()

def load_course_history():
    if os.path.exists(COURSE_HISTORY_FILE):
        with open(COURSE_HISTORY_FILE, 'r') as f:
            return json.load(f)
    return []

def save_course_history(course):
    history = load_course_history()
    history.append(course)
    with open(COURSE_HISTORY_FILE, 'w') as f:
        json.dump(history, f)

def get_previous_topics():
    history = load_course_history()
    return [course['topic'] for course in history]

def display_leaf_analysis_results(results):
    leaf_analysis = results["leaf_analysis"]
    if leaf_analysis['crop_type'] == "Unknown":
        st.header(f"Please retake the image")
        return
    st.header("Analysis Results")
    st.subheader("Leaf Analysis")
    st.write(f"Crop Type: {leaf_analysis['crop_type']}")
    st.write(f"Health Percentage: {leaf_analysis['percentage']}%")
    if leaf_analysis['disease_name'] != "None":
        st.write(f"Disease Name: {leaf_analysis['disease_name']}")
        st.write(f"Description: {leaf_analysis['description']}")
        st.write(f"Risk Level: {leaf_analysis['level_of_risk']}")
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

def display_course_results(results):
    st.header("Generated Course")
    st.subheader(results["topic"])
    st.write("Content:")
    st.write(results["content"])
    st.write("Tags:")
    for tag in results["tags"]:
        st.write(f"- {tag}")
    st.write("References:")
    for ref in results["references"]:
        st.write(f"- {ref}")
    st.image(results["image_url"], caption="Generated Course Image")

    # Save the new course to history
    save_course_history(results)

st.title("Agricultural Analysis and Course Generation")

tab1, tab2 = st.tabs(["Leaf Analysis", "Course Generation"])

with tab1:
    st.header("Crop Leaf Analysis")
    uploaded_file = st.file_uploader("Choose a leaf image...", type=["jpg", "jpeg", "png"])

    if uploaded_file is not None:
        image = Image.open(uploaded_file)
        image = image.resize((250, 250))
        st.image(image, caption='Uploaded Image', use_column_width=True)
        
        if st.button('Analyze Leaf'):
            with st.spinner('Analyzing...'):
                encoded_image = encode_image(image)
                results = call_api("analyze-leaf/", {"image": encoded_image})
            display_leaf_analysis_results(results)

with tab2:
    st.header("Course Generation")
    
    # Display previous topics
    st.subheader("Previous Course Topics")
    previous_topics = get_previous_topics()
    for topic in previous_topics:
        st.write(f"- {topic}")

    if st.button('Generate New Course'):
        with st.spinner('Generating course...'):
            results = call_api("course-generation/", {"history": previous_topics})
        display_course_results(results)

    # Option to view full course history
    if st.checkbox("View Full Course History"):
        st.subheader("Full Course History")
        full_history = load_course_history()
        for course in full_history:
            st.write(f"Topic: {course['topic']}")
            st.write(f"Content: {course['content'][:100]}...")  # Show first 100 characters
            st.write("---")

st.sidebar.info("This application analyzes crop leaf images to identify diseases, provide treatment guidance, and generate agricultural courses.")