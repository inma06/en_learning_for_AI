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

const Question = mongoose.model('Question', questionSchema);

module.exports = Question; 