import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/news_repository.dart';

@lazySingleton
class SubmitAnswer implements UseCase<void, SubmitAnswerParams> {
  final NewsRepository repository;

  SubmitAnswer(this.repository);

  @override
  Future<Either<Failure, void>> call(SubmitAnswerParams params) async {
    return await repository.submitAnswer(params.questionId, params.answer);
  }
}

class SubmitAnswerParams extends Equatable {
  final String questionId;
  final String answer;

  const SubmitAnswerParams({
    required this.questionId,
    required this.answer,
  });

  @override
  List<Object> get props => [questionId, answer];
}
