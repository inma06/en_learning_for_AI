const express = require('express');
const router = express.Router();
const { 
  getHeadlines,
  getQuestions,
  getQuestionsByDate
} = require('../controllers/openaiController');

// 헤드라인 목록 조회
router.get('/headlines', getHeadlines);

// 문제 목록 조회 (GET - 기본 10개, POST - 개수 지정)
router.get('/questions', getQuestions);
router.post('/questions', getQuestions);

// 특정 날짜의 문제 조회
router.get('/questions/date/:date', getQuestionsByDate);

module.exports = router; 