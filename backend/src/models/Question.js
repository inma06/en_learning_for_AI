const mongoose = require('mongoose');

// Sub-schema for Main Idea Question
const MainIdeaQuestionSchema = new mongoose.Schema({
  question: { type: String, required: true },
  choices: [{ type: String, required: true }], // Should be an array of 5 strings
  answer: { type: String, required: true },
  difficulty: { 
    type: String, 
    enum: ['easy', 'medium', 'hard'], 
    required: true 
  }
}, {_id: false});

// Sub-schema for Fill In The Blank Question
const FillInTheBlankQuestionSchema = new mongoose.Schema({
  question_text_with_blank: { type: String, required: true },
  question_prompt: { type: String, required: true },
  choices: [{ type: String, required: true }], // Should be an array of 5 strings
  answer: { type: String, required: true },
  difficulty: { 
    type: String, 
    enum: ['easy', 'medium', 'hard'], 
    required: true 
  }
}, {_id: false});

// Main Question Schema
const QuestionSchema = new mongoose.Schema({
  headline: {
    type: String,
    required: true,
    trim: true,
    // unique: true // 이전에 크롤러에서 headlines_collection과 questions_collection 양쪽에서 headline unique를 관리했었음.
                 // questions_collection에 headline unique는 유지하는 것이 좋음.
  },
  paragraph: {
    type: String,
    required: true
  },
  source: { // source 필드 추가
    type: String,
    required: true,
    trim: true
  },
  main_idea_question: {
    type: MainIdeaQuestionSchema,
    required: false // main_idea_question 또는 fill_in_the_blank_question 중 하나 이상은 있어야 함을 나타내거나, 둘 다 있을 수 있음
  },
  fill_in_the_blank_question: {
    type: FillInTheBlankQuestionSchema,
    required: false 
  },
  createdAt: {
    type: Date,
    default: Date.now,
    required: true
  }
});

// 인덱스 생성
QuestionSchema.index({ headline: 1 }, { unique: true }); // headline은 고유해야 함
QuestionSchema.index({ createdAt: -1 });
// 필요하다면 source, difficulty 등에 대한 인덱스도 추가 가능
// QuestionSchema.index({ source: 1 });
// QuestionSchema.index({ "main_idea_question.difficulty": 1 });
// QuestionSchema.index({ "fill_in_the_blank_question.difficulty": 1 });


// 스키마 유효성 검사: main_idea_question 또는 fill_in_the_blank_question 중 하나는 반드시 존재해야 함
QuestionSchema.pre('validate', function(next) {
  if (!this.main_idea_question && !this.fill_in_the_blank_question) {
    next(new Error('At least one type of question (main_idea_question or fill_in_the_blank_question) must be present.'));
  } else {
    // 각 질문 유형의 choices가 5개인지 검증 (만약 해당 질문 유형이 존재한다면)
    if (this.main_idea_question && this.main_idea_question.choices.length !== 5) {
      next(new Error('Main idea question must have 5 choices.'));
    }
    if (this.fill_in_the_blank_question && this.fill_in_the_blank_question.choices.length !== 5) {
      next(new Error('Fill in the blank question must have 5 choices.'));
    }
    next();
  }
});


const Question = mongoose.model('Question', QuestionSchema);

module.exports = Question; 