// services/groqService.js
const Groq = require('groq-sdk');

const groq = new Groq({ apiKey: process.env.GROQ_API_KEY });

const generateCourse = async (prompt) => {
  const response = await groq.chat.completions.create({
    messages: [{ role: 'user', content: prompt }],
    model: 'mixtral-8x7b-32768',
  });

  return response.choices[0]?.message?.content || '';
};

const getAiAdvice = async (prompt) => {
  const response = await groq.chat.completions.create({
    messages: [{ role: 'user', content: prompt }],
    model: 'mixtral-8x7b-32768',
  });

  return response.choices[0]?.message?.content || '';
};

const chatWithAi = async (prompt) => {
  const response = await groq.chat.completions.create({
    messages: [{ role: 'user', content: prompt }],
    model: 'mixtral-8x7b-32768',
  });

  return response.choices[0]?.message?.content || '';
};

module.exports = {
  generateCourse,
  getAiAdvice,
  chatWithAi,
};
