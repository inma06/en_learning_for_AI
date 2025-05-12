const { generateQuestion } = require('../services/openaiService');
const { MongoClient } = require('mongodb');
const Question = require('../models/Question');

// 헤드라인 목록 조회
const getHeadlines = async (req, res) => {
  try {
    const headlines = await Question.distinct('headline', {}, { sort: { date: -1 } });
    res.json({ headlines });
  } catch (error) {
    console.error('[ERROR] Error fetching headlines:', error);
    res.status(500).json({ error: 'Failed to fetch headlines' });
  }
};

// 지정된 개수의 문제 생성
const getQuestions = async (req, res) => {
  try {
    const { count = 20 } = req.body;
    const questionCount = Math.min(Math.max(parseInt(count), 10), 50); // 10~50 사이로 제한
    
    const questions = await Question.find({})
      .sort({ date: -1 })
      .limit(questionCount)
      .select('headline question choices answer date');
    
    if (questions.length === 0) {
      return res.status(404).json({ error: 'No questions found in database' });
    }

    res.json({ 
      totalQuestions: questions.length,
      questions 
    });
  } catch (error) {
    console.error('[ERROR] Error fetching questions:', error);
    res.status(500).json({ error: 'Failed to fetch questions' });
  }
};

// 특정 날짜의 문제 조회
const getQuestionsByDate = async (req, res) => {
  try {
    const { date } = req.params;
    const startDate = new Date(date);
    startDate.setHours(0, 0, 0, 0);
    const endDate = new Date(date);
    endDate.setHours(23, 59, 59, 999);

    const questions = await Question.find({
      date: {
        $gte: startDate,
        $lte: endDate
      }
    }).sort({ date: -1 });

    if (questions.length === 0) {
      return res.status(404).json({ error: 'No questions found for the specified date' });
    }

    res.json({
      date,
      totalQuestions: questions.length,
      questions
    });
  } catch (error) {
    console.error('[ERROR] Error fetching questions by date:', error);
    res.status(500).json({ error: 'Failed to fetch questions by date' });
  }
};

const generateQuestionFromHeadline = async (req, res) => {
  try {
    const { headline } = req.body;

    if (!headline) {
      return res.status(400).json({ error: 'Headline is required' });
    }

    const question = await generateQuestion(headline);
    res.json(question);
  } catch (error) {
    console.error('Error generating question:', error);
    res.status(500).json({ error: 'Failed to generate question' });
  }
};

module.exports = {
  getHeadlines,
  getQuestions,
  getQuestionsByDate,
  generateQuestionFromHeadline
}; 