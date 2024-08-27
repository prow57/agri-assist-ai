// services/groqService.js
const Groq = require('groq-sdk');

// Initialize Groq client with API key from environment variables
const groq = new Groq({ apiKey: process.env.GROQ_API_KEY });

// Function to generate course content
const generateCourse = async (prompt) => {
  try {
    const response = await groq.chat.completions.create({
      messages: [{ role: 'user', content: prompt }],
      model: 'mixtral-8x7b-32768',
    });

    return response.choices[0]?.message?.content || 'No content generated';
  } catch (error) {
    console.error('Error generating course:', error);
    throw new Error('Failed to generate course content.');
  }
};

// Function to get AI advice
const getAiAdvice = async (prompt) => {
  try {
    const response = await groq.chat.completions.create({
      messages: [{ role: 'user', content: prompt }],
      model: 'mixtral-8x7b-32768',
    });

    return response.choices[0]?.message?.content || 'No advice provided';
  } catch (error) {
    console.error('Error getting AI advice:', error);
    throw new Error('Failed to get AI advice.');
  }
};

// Function to chat with AI
const chatWithAi = async (prompt) => {
  try {
    const response = await groq.chat.completions.create({
      messages: [{ role: 'user', content: prompt }],
      model: 'mixtral-8x7b-32768',
    });

    return response.choices[0]?.message?.content || 'No response from AI';
  } catch (error) {
    console.error('Error in AI chat:', error);
    throw new Error('Failed to get chat response.');
  }
};

module.exports = {
  generateCourse,
  getAiAdvice,
  chatWithAi,
};
