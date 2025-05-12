const express = require('express');
const cors = require('cors');
const morgan = require('morgan');
const helmet = require('helmet');
const path = require('path');
require('dotenv').config({ path: path.resolve(__dirname, '../../.env') });

const connectDB = require('./config/database');
const authRoutes = require('./routes/auth');
const learningMaterialRoutes = require('./routes/learningMaterial');
const openaiRoutes = require('./routes/openai');

// Express 앱 생성
const app = express();

// 미들웨어
app.use(helmet());
app.use(cors());
app.use(morgan('dev'));
app.use(express.json());

// 라우트
app.use('/api/auth', authRoutes);
app.use('/api/materials', learningMaterialRoutes);
app.use('/api/openai', openaiRoutes);

// 에러 핸들링
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ message: '서버 오류가 발생했습니다.' });
});

// 서버 시작
const PORT = process.env.PORT || 3001;

const start = async () => {
  try {
    await connectDB();
    app.listen(PORT, () => {
      console.log(`Server is running on port ${PORT}`);
    });
  } catch (error) {
    console.error('Failed to start server:', error);
    process.exit(1);
  }
};

start(); 