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
    const { 
      difficulty,
      category,
      page = 1,
      limit = 10
    } = req.query;

    // 쿼리 조건 구성
    const query = {};
    if (difficulty) query.difficulty = difficulty;
    if (category) query.category = category;

    // 페이지네이션 계산
    const skip = (parseInt(page) - 1) * parseInt(limit);
    const totalQuestions = await Question.countDocuments(query);

    const questions = await Question.find(query)
      .sort({ createdAt: -1 })
      .skip(skip)
      .limit(parseInt(limit))
      .select('headline paragraph question choices answer createdAt difficulty category');
    
    if (questions.length === 0) {
      return res.status(404).json({ error: 'No questions found in database' });
    }

    res.json({ 
      totalQuestions,
      currentPage: parseInt(page),
      totalPages: Math.ceil(totalQuestions / parseInt(limit)),
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
    startDate.setUTCHours(0, 0, 0, 0);
    const endDate = new Date(date);
    endDate.setUTCHours(23, 59, 59, 999);

    const questions = await Question.find({
      createdAt: {
        $gte: startDate,
        $lte: endDate
      }
    }).sort({ createdAt: -1 })
      .select('headline paragraph question choices answer createdAt difficulty category');

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