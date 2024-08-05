const axios = require('axios');

exports.analyzeCrop = async (imageUrl) => {
    const response = await axios.post(
            'https://plant.id/api/v3/health_assessment',
                    {
                                api_key: process.env.PLANT_ID_API_KEY,
                                            images: [imageUrl],
                                                        organs: ['leaf']
                                                                }
                                                                    );

                                                                        if (response.data.status === 'error') {
                                                                                throw new Error(response.data.error.message);
                                                                                    }

                                                                                        return response.data.health_assessment;
                                                                                        };

                                                                                        exports.generateSuggestions = async (healthAssessment) => {
                                                                                            const prompt = `Provide detailed suggestions for the following crop health issues: ${JSON.stringify(healthAssessment)}`;

                                                                                                const response = await axios.post(
                                                                                                        'https://api.openai.com/v1/engines/davinci-codex/completions',
                                                                                                                {
                                                                                                                            prompt: prompt,
                                                                                                                                        max_tokens: 200,
                                                                                                                                                    n: 1,
                                                                                                                                                                stop: null,
                                                                                                                                                                            temperature: 0.7
                                                                                                                                                                                    },
                                                                                                                                                                                            {
                                                                                                                                                                                                        headers: {
                                                                                                                                                                                                                        'Authorization': `Bearer ${process.env.OPENAI_API_KEY}`
                                                                                                                                                                                                                                    }
                                                                                                                                                                                                                                            }
                                                                                                                                                                                                                                                );

                                                                                                                                                                                                                                                    return response.data.choices[0].text.trim();
                                                                                                                                                                                                                                                    };
