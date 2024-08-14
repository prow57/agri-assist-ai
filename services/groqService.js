import Groq from "groq-sdk";

const groq = new Groq({ apiKey: process.env.GROQ_API_KEY });

const generateResponse = async (prompt: string, model: string) => {
    try {
        const completion = await groq.chat.completions.create({
            messages: [
                {
                    role: "user",
                    content: prompt,
                },
            ],
            model: model,
        });

        return completion.choices[0]?.message?.content || "";
    } catch (error) {
        console.error('Error generating response:', error);
        throw error;
    }
};

export const generateCourse = (prompt: string) => {
    return generateResponse(prompt, "mixtral-8x7b-32768");
};

export const getAiAdvice = (prompt: string) => {
    return generateResponse(prompt, "mixtral-8x7b-32768");
};

export const chatWithAi = (prompt: string) => {
    return generateResponse(prompt, "mixtral-8x7b-32768");
};
