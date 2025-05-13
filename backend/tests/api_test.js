const request = require('supertest');
const mongoose = require('mongoose');
const app = require('../src/app');
const Question = require('../src/models/question');

describe('API Tests', () => {
  beforeAll(async () => {
    await mongoose.connect(process.env.MONGODB_URI || 'mongodb://localhost:27017/test');
  });

  afterAll(async () => {
    await mongoose.connection.dropDatabase();
    await mongoose.connection.close();
  });

  beforeEach(async () => {
    await Question.deleteMany({});
  });

  describe('GET /api/questions', () => {
    it('should return empty list when no questions exist', async () => {
      const response = await request(app)
        .get('/api/questions')
        .expect(200);

      expect(response.body.questions).toEqual([]);
      expect(response.body.totalPages).toBe(0);
      expect(response.body.currentPage).toBe(1);
    });

    it('should return paginated questions', async () => {
      const questions = Array.from({ length: 15 }, (_, i) => ({
        headline: `Headline ${i + 1}`,
        question: `Question ${i + 1}`,
        choices: ['A', 'B', 'C', 'D'],
        answer: 'A',
        difficulty: 'easy',
        category: 'vocabulary',
        date: new Date(),
      }));

      await Question.insertMany(questions);

      const response = await request(app)
        .get('/api/questions?page=1&limit=10')
        .expect(200);

      expect(response.body.questions.length).toBe(10);
      expect(response.body.totalPages).toBe(2);
      expect(response.body.currentPage).toBe(1);
    });

    it('should filter questions by difficulty', async () => {
      const questions = [
        {
          headline: 'Easy Question',
          question: 'Easy Question',
          choices: ['A', 'B', 'C', 'D'],
          answer: 'A',
          difficulty: 'easy',
          category: 'vocabulary',
          date: new Date(),
        },
        {
          headline: 'Hard Question',
          question: 'Hard Question',
          choices: ['A', 'B', 'C', 'D'],
          answer: 'A',
          difficulty: 'hard',
          category: 'vocabulary',
          date: new Date(),
        },
      ];

      await Question.insertMany(questions);

      const response = await request(app)
        .get('/api/questions?difficulty=easy')
        .expect(200);

      expect(response.body.questions.length).toBe(1);
      expect(response.body.questions[0].difficulty).toBe('easy');
    });

    it('should filter questions by category', async () => {
      const questions = [
        {
          headline: 'Vocabulary Question',
          question: 'Vocabulary Question',
          choices: ['A', 'B', 'C', 'D'],
          answer: 'A',
          difficulty: 'easy',
          category: 'vocabulary',
          date: new Date(),
        },
        {
          headline: 'Grammar Question',
          question: 'Grammar Question',
          choices: ['A', 'B', 'C', 'D'],
          answer: 'A',
          difficulty: 'easy',
          category: 'grammar',
          date: new Date(),
        },
      ];

      await Question.insertMany(questions);

      const response = await request(app)
        .get('/api/questions?category=vocabulary')
        .expect(200);

      expect(response.body.questions.length).toBe(1);
      expect(response.body.questions[0].category).toBe('vocabulary');
    });
  });

  describe('POST /api/questions/:id/answer', () => {
    it('should submit answer and return result', async () => {
      const question = await Question.create({
        headline: 'Test Question',
        question: 'Test Question',
        choices: ['A', 'B', 'C', 'D'],
        answer: 'A',
        difficulty: 'easy',
        category: 'vocabulary',
        date: new Date(),
      });

      const response = await request(app)
        .post(`/api/questions/${question.headline}/answer`)
        .send({
          answer: 'A',
          isCorrect: true,
        })
        .expect(200);

      expect(response.body.success).toBe(true);

      const updatedQuestion = await Question.findOne({ headline: question.headline });
      expect(updatedQuestion.userResponses).toHaveLength(1);
      expect(updatedQuestion.userResponses[0].answer).toBe('A');
      expect(updatedQuestion.userResponses[0].isCorrect).toBe(true);
    });

    it('should return 404 for non-existent question', async () => {
      await request(app)
        .post('/api/questions/non-existent/answer')
        .send({
          answer: 'A',
          isCorrect: true,
        })
        .expect(404);
    });
  });
}); 