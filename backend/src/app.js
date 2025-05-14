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

// CORS 옵션 설정
const corsOptions = {
  origin: '*', // 실제 프로덕션에서는 특정 도메인들로 제한하는 것이 좋습니다. 예: 'http://localhost:12345' 또는 ['http://localhost:12345', 'https://your-app.com']
  methods: "GET,HEAD,PUT,PATCH,POST,DELETE",
  credentials: true, // 쿠키 등 자격 증명 정보 허용 여부
  optionsSuccessStatus: 204 // 일부 레거시 브라우저 (IE11, various SmartTVs)는 204를 반환
};
app.use(cors(corsOptions));
// app.use(cors()); // 기존 cors() 호출은 주석 처리하거나 삭제합니다.

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