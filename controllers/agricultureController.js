const groqService = require('../services/groqService');

// Generate Course or Lesson
const generateCourse = async (req, res) => {
    const { category, topic } = req.body;
        const prompt = `Generate a detailed course on ${category} with a focus on ${topic}. Include sections on Introduction, Best Practices, Challenges, and Conclusion.`;

            try {
                    const course = await groqService.generateCourse(prompt);
                            res.status(200).json({ course });
                                } catch (error) {
                                        res.status(500).json({ message: 'Error generating course', error });
                                            }
                                            };

                                            // AI Advice
                                            const getAiAdvice = async (req, res) => {
                                                const { cropType, farmingMethods, issues } = req.body;
                                                    const prompt = `Provide farming advice for ${cropType} using the following methods: ${farmingMethods}. Address the following issues: ${issues}.`;

                                                        try {
                                                                const advice = await groqService.generateCourse(prompt);
                                                                        res.status(200).json({ advice });
                                                                            } catch (error) {
                                                                                    res.status(500).json({ message: 'Error providing advice', error });
                                                                                        }
                                                                                        };

                                                                                        // Chat Conversation
                                                                                        const chatWithAi = async (req, res) => {
                                                                                            const { question } = req.body;
                                                                                                const prompt = `Answer the following agricultural question: ${question}`;

                                                                                                    try {
                                                                                                            const response = await groqService.generateCourse(prompt);
                                                                                                                    res.status(200).json({ response });
                                                                                                                        } catch (error) {
                                                                                                                                res.status(500).json({ message: 'Error in chat conversation', error });
                                                                                                                                    }
                                                                                                                                    };

                                                                                                                                    module.exports = {
                                                                                                                                        generateCourse,
                                                                                                                                            getAiAdvice,
                                                                                                                                                chatWithAi
                                                                                                                                                };
                                                                                                                                                