from pydantic import BaseModel, Field

class LeafImageAnalysisOutput(BaseModel):
    crop_type: str = Field(description='Type of the crop "Unknown" if there is no crop')
    disease_name: str | None = Field(description='Name of the detected disease or None if healthy')
    description: str | None = Field(description='Detailed description of the disease')
    level_of_risk: str | None = Field(description='Level of risk')
    percentage: int | None = Field(description='Percentage of health (0-100)')
    estimated_size: str | None = Field(description='Estimated size of the crop')
    stage: str | None = Field(description='Disease stage or None if healthy')
    symptoms: list[str] | None = Field(description='List of observed symptoms')

class DiseaseResearchOutput(BaseModel):
    relevant_websites: list[str] | None = Field(description='List of relevant websites for disease solutions')
    general_information: list[str] | None = Field(description='General information about the diagnosed disease')
    recommended_treatments: list[str] | None = Field(description='Recommended treatments for the diagnosed disease')

class GuidanceGenerationOutput(BaseModel):
    treatment_steps: list[str] | None = Field(description='Steps for disease treatment')
    ingredients: list[str] | None = Field(description='Ingredients and their quantities for treatment')

class CumulativeOutput(BaseModel):
    leaf_analysis: LeafImageAnalysisOutput = Field(description='Results from leaf image analysis')
    disease_research: DiseaseResearchOutput = Field(description='Results from disease research')
    guidance_generation: GuidanceGenerationOutput = Field(description='Generated guidance and ingredients')

class ImageRequest(BaseModel):
    image: str

class CourseRequest(BaseModel):
    history: list[str]

class TopicSelectionOutput(BaseModel):
    topic: str | None = Field(description='topic selected related to the agriculture')

class ContentAndMetadataOutput(BaseModel):
    content: str | None = Field(description='Detailed course outline and key content points related to the selected topic')
    tags: list[str] | None = Field(description='List of tags related to the topic and content generated')
    references: list[str] | None = Field(description='List of reference link')
