import joblib
import json
from tensorflow.keras.preprocessing import image
import numpy as np
import openai

# Load the custom model wrapper
leaf_model = joblib.load('leaf_disease_model.pkl')



def generate_description_and_suggestions(disease_name):
    prompt = f"The detected disease is {disease_name}. Provide a detailed description of this disease and actionable suggestions for treatment."
    
    response = openai.Completion.create(
        engine="text-davinci-003",
        prompt=prompt,
        max_tokens=150
    )
    
    text = response.choices[0].text.strip()
    description, suggestions = text.split("Suggestions:")
    
    return description.strip(), suggestions.strip()

def predict_disease(img_path):
    # Predict the disease
    disease_idx = leaf_model.predict(img_path)
    
    # Map the predicted class to a disease name
    disease_mapping = {0: "Healthy", 1: "Powdery", 2: "Rust"}  # Update as per your dataset
    disease_name = disease_mapping[disease_idx]

    # Generate description and suggestions
    description, suggestions = generate_description_and_suggestions(disease_name)

    return disease_name, description, suggestions

if __name__ == "__main__":
    import sys
    img_path = sys.argv[1]
    disease_name, description, suggestions = predict_disease(img_path)

    # Output the prediction as JSON
    output = {
        'disease': disease_name,
        'description': description,
        'suggestions': suggestions
    }
    print(json.dumps(output))
