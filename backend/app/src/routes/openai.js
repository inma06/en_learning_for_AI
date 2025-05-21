const express = require('express');
const router = express.Router();
const { 
  getHeadlines,
  getQuestions,
  getQuestionsByDate
} = require('../controllers/openaiController');
const apiLimiter = require('../middlewares/rateLimiter');
const cache = require('../middlewares/cache');

// 모든 라우트에 rate limiter 적용
router.use(apiLimiter);

// 헤드라인 목록 조회 (5분 캐시)
router.get('/headlines', cache(300), getHeadlines);

// 문제 목록 조회 (5분 캐시)
router.get('/questions', cache(300), getQuestions);
router.post('/questions', getQuestions);

// 특정 날짜의 문제 조회 (5분 캐시)
router.get('/questions/date/:date', cache(300), getQuestionsByDate);

module.exports = router; 