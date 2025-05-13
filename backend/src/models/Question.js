const mongoose = require('mongoose');

const questionSchema = new mongoose.Schema({
  headline: {
    type: String,
    required: true,
    trim: true
  },
  source: {
    type: String,
    required: true,
    enum: ['CNN', 'BBC', 'Reuters'],
    default: 'CNN'
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
  userResponses: [{
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true
    },
    selectedAnswer: {
      type: String,
      required: true
    },
    isCorrect: {
      type: Boolean,
      required: true
    },
    answeredAt: {
      type: Date,
      default: Date.now
    }
  }],
  createdAt: {
    type: Date,
    required: true,
    default: Date.now
  },
  date: {
    type: Date,
    required: true,
    default: Date.now
  }
});

// 인덱스 생성
questionSchema.index({ headline: 1, date: -1 });
questionSchema.index({ date: -1 });
questionSchema.index({ difficulty: 1, category: 1 });
questionSchema.index({ 'userResponses.userId': 1 });

const Question = mongoose.model('Question', questionSchema);

module.exports = Question; 