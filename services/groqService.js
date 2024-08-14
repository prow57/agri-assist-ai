const axios = require('axios');

const groqApiUrl = process.env.GROQ_API_URL;
const groqApiKey = process.env.GROQ_API_KEY;

const headers = {
    'Content-Type': 'application/json',
        'Authorization': `Bearer ${groqApiKey}`
        };

        const generateCourse = async (prompt) => {
            try {
                    const response = await axios.post(groqApiUrl, {
                                model: "text-davinci-002", // replace with your specific model
                                            prompt: prompt,
                                                        max_tokens: 1500, // adjust token count based on course content
                                                                    temperature: 0.7 // adjust for creativity
                                                                            }, { headers });

                                                                                    return response.data.choices[0].text;
                                                                                        } catch (error) {
                                                                                                console.error('Error generating course:', error);
                                                                                                        throw error;
                                                                                                            }
                                                                                                            };

                                                                                                            module.exports = {
                                                                                                                generateCourse
                                                                                                                };
