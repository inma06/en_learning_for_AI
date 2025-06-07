import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/question_entity.dart';
import '../repositories/news_repository.dart';

@lazySingleton
class GetQuestions implements UseCase<List<Question>, NoParams> {
  final NewsRepository repository;

  GetQuestions(this.repository);

  @override
  Future<Either<Failure, List<Question>>> call(NoParams params) async {
    return await repository.getQuestions();
  }
}
