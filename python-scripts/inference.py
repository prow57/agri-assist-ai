import numpy as np
import json
from tensorflow.keras.models import load_model
from tensorflow.keras.preprocessing import image
import openai
import sys

# Load the trained model
model = load_model('leaf_disease_model_2024-07-21_12-48-45.h5')

# Define the API key for OpenAI GPT



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
    # Load and preprocess the image
    img = image.load_img(img_path, target_size=(150, 150))
    img_array = image.img_to_array(img) / 255.0
    img_array = np.expand_dims(img_array, axis=0)

    # Predict the disease
    predictions = model.predict(img_array)
    disease_idx = np.argmax(predictions[0])
    
    # Map the predicted class to a disease name
    disease_mapping = {0: "Disease A", 1: "Disease B"}  # Update as per your dataset
    disease_name = disease_mapping[disease_idx]

    # Generate description and suggestions
    description, suggestions = generate_description_and_suggestions(disease_name)

    return disease_name, description, suggestions

if __name__ == "__main__":
    img_path = sys.argv[1]
    disease_name, description, suggestions = predict_disease(img_path)

    # Output the prediction as JSON
    output = {
        'disease': disease_name,
        'description': description,
        'suggestions': suggestions
    }
    print(json.dumps(output))
