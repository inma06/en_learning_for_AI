import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/question_entity.dart';

abstract class NewsRepository {
  Future<Either<Failure, List<Question>>> getQuestions();
  Future<Either<Failure, Question>> getQuestionById(String id);
  Future<Either<Failure, void>> submitAnswer(String questionId, String answer);
}
