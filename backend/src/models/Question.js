const mongoose = require('mongoose');

const questionSchema = new mongoose.Schema({
  headline: {
    type: String,
    required: true,
    trim: true
  },
  paragraph: {
    type: String,
    required: true
  },
  question: {
    type: String,
    required: true
  },
  choices: [{
    type: String,
    required: true
  }],
  answer: {
    type: String,
    required: true
  },
  difficulty: {
    type: String,
    enum: ['easy', 'medium', 'hard'],
    required: true,
    default: 'medium'
  },
  category: {
    type: String,
    enum: ['business', 'technology', 'science', 'health', 'entertainment', 'sports', 'general'],
    required: true,
    default: 'general'
  },
  createdAt: {
    type: Date,
    required: true,
    default: Date.now
  }
});

// 인덱스 생성
questionSchema.index({ headline: 1, createdAt: -1 });
questionSchema.index({ createdAt: -1 });
questionSchema.index({ difficulty: 1, category: 1 });

const Question = mongoose.model('Question', questionSchema);

module.exports = Question; 