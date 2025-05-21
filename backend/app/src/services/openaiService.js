const { OpenAI } = require('openai');
const dotenv = require('dotenv');
const path = require('path');

dotenv.config({ path: path.resolve(__dirname, '../../.env') });

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});

const generateQuestion = async (headline) => {
  try {
    const prompt = `Create a multiple choice question based on this news headline: "${headline}"
    Format the response as a JSON object with the following structure:
    {
      "question": "The question text",
      "choices": ["Option A", "Option B", "Option C", "Option D"],
      "answer": "The correct answer"
    }
    Make sure the question is clear and the choices are plausible but only one is correct.`;

    const completion = await openai.chat.completions.create({
      messages: [{ role: "user", content: prompt }],
      model: "gpt-3.5-turbo",
      response_format: { type: "json_object" },
    });

    const response = JSON.parse(completion.choices[0].message.content);
    return response;
  } catch (error) {
    console.error('OpenAI API Error:', error);
    throw new Error('Failed to generate question');
  }
};

module.exports = {
  generateQuestion,
}; 