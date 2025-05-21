const rateLimit = require('express-rate-limit');

const apiLimiter = rateLimit({
  windowMs: 60 * 1000, // 1분
  max: 60, // IP당 최대 60회 요청
  message: {
    error: '너무 많은 요청이 발생했습니다. 1분 후에 다시 시도해주세요.'
  },
  standardHeaders: true,
  legacyHeaders: false,
});

module.exports = apiLimiter; 