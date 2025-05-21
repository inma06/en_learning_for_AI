const mongoose = require('mongoose');

const learningMaterialSchema = new mongoose.Schema({
  title: {
    type: String,
    required: true,
    trim: true,
  },
  content: {
    type: String,
    required: true,
  },
  source: {
    type: String,
    required: true,
    enum: ['CNN', 'BBC', 'Reuters'],
  },
  originalUrl: {
    type: String,
    required: true,
  },
  publishedAt: {
    type: Date,
    required: true,
  },
  difficulty: {
    type: String,
    enum: ['beginner', 'intermediate', 'advanced'],
    required: true,
  },
  category: {
    type: String,
    enum: ['business', 'technology', 'science', 'health', 'entertainment', 'sports'],
    required: true,
  },
  vocabulary: [{
    word: String,
    definition: String,
    example: String,
  }],
  questions: [{
    type: {
      type: String,
      enum: ['multiple_choice', 'fill_blank', 'true_false'],
      required: true,
    },
    question: {
      type: String,
      required: true,
    },
    options: [String],
    correctAnswer: {
      type: String,
      required: true,
    },
    explanation: String,
  }],
  aiGenerated: {
    type: Boolean,
    default: true,
  },
  status: {
    type: String,
    enum: ['draft', 'published', 'archived'],
    default: 'draft',
  },
  metadata: {
    wordCount: Number,
    readingTime: Number, // in minutes
    aiModel: String,
    generationDate: Date,
  },
}, {
  timestamps: true,
});

// 인덱스 생성
learningMaterialSchema.index({ title: 'text', content: 'text' });
learningMaterialSchema.index({ source: 1, publishedAt: -1 });
learningMaterialSchema.index({ difficulty: 1, category: 1 });

const LearningMaterial = mongoose.model('LearningMaterial', learningMaterialSchema);

module.exports = LearningMaterial; 