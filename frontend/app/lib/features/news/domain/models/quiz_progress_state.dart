import 'package:hive/hive.dart';
import 'package:language_learning_app/features/news/presentation/providers/news_quiz_provider.dart'; // For QuestionPartType enum

part 'quiz_progress_state.g.dart'; // Hive generator가 생성할 파일

@HiveType(typeId: 0) // 고유한 typeId
class QuizProgressState extends HiveObject {
  // HiveObject를 상속받으면 Box에서 직접 객체 관리 용이
  @HiveField(0)
  final String? questionId; // 현재 Question 객체의 ID (MongoDB의 _id)

  @HiveField(1)
  final int questionDisplayIndex; // 현재 페이지 내 Question 객체의 인덱스

  @HiveField(2)
  final String currentQuestionPartTypeString; // QuestionPartType.toString()

  @HiveField(3)
  final int currentPageForApi; // API 호출을 위한 현재 페이지 번호

  @HiveField(4)
  final int selectedLimit; // 사용자가 선택한 문제 수

  @HiveField(5)
  final DateTime lastSavedAt; // 저장 시각

  QuizProgressState({
    this.questionId,
    required this.questionDisplayIndex,
    required this.currentQuestionPartTypeString,
    required this.currentPageForApi,
    required this.selectedLimit,
    required this.lastSavedAt,
  });

  // 편의를 위해 QuestionPartType으로 변환하는 getter
  QuestionPartType get currentQuestionPartType {
    if (currentQuestionPartTypeString ==
        QuestionPartType.fillInTheBlank.toString()) {
      return QuestionPartType.fillInTheBlank;
    }
    return QuestionPartType.mainIdea; // 기본값 또는 다른 경우
  }
}
