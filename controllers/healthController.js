const plantIdService = require('../services/plantIdService');

exports.healthAssessment = async (req, res) => {
    const { imageUrl } = req.body;

        try {
                const healthAssessment = await plantIdService.analyzeCrop(imageUrl);
                        const suggestions = await plantIdService.generateSuggestions(healthAssessment);

                                res.json({
                                            healthAssessment,
                                                        suggestions
                                                                });
                                                                    } catch (error) {
                                                                            console.error(error);
                                                                                    res.status(500).json({ error: 'An error occurred while processing the health assessment.' });
                                                                                        }
                                                                                        };
                                                                                        