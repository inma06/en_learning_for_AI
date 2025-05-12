const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');
const { protect } = require('../middlewares/auth');

// 인증 라우트
router.post('/register', authController.register);
router.post('/login', authController.login);
router.post('/social', authController.socialAuth);
router.get('/me', protect, authController.getCurrentUser);

module.exports = router; 