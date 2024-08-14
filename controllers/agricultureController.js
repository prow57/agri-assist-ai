import { generateCourse, getAiAdvice, chatWithAi } from '../services/groqService';

// Generate Course or Lesson
export const generateCourseController = async (req, res) => {
    const { category, topic } = req.body;
    const prompt = `Generate a detailed course/lesson on ${category} with a focus on ${topic}. Include a structure or sections on Introduction, Best Practices, Methods, Challenges, and Conclusion. Their should be suitable for country Malawi. You can add or remove any sections based on the topic`;

    try {
        const course = await generateCourse(prompt);
        res.status(200).json({ course });
    } catch (error) {
        res.status(500).json({ message: 'Error generating course', error });
    }
};

// AI Advice
export const getAiAdviceController = async (req, res) => {
    const { cropType, farmingMethods, issues } = req.body;
    const prompt = `Provide farming advice for ${cropType} which is using the following farming methods: ${farmingMethods}. Address the following issues and add any recommendations: ${issues}.`;

    try {
        const advice = await getAiAdvice(prompt);
        res.status(200).json({ advice });
    } catch (error) {
        res.status(500).json({ message: 'Error providing advice', error });
    }
};

// Chat Conversation
export const chatWithAiController = async (req, res) => {
    const { question } = req.body;
    const prompt = `Answer the following agricultural question and remember you are representing Agriassist-AI. Make sure your answers are only about Agriculture. Do not say anything that has nothing to do with Agriculture. The answers should relate to Malawi Agriculture Farming.: ${question}`;

    try {
        const response = await chatWithAi(prompt);
        res.status(200).json({ response });
    } catch (error) {
        res.status(500).json({ message: 'Error in chat conversation', error });
    }
};
