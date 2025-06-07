import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/question_entity.dart';
import '../../domain/repositories/news_repository.dart';
import '../datasources/news_remote_datasource.dart';
import '../models/question_model.dart';

@LazySingleton(as: NewsRepository)
class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  NewsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Question>>> getQuestions() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuestions = await remoteDataSource.getQuestions();
        return Right(remoteQuestions.map((model) => model.toEntity()).toList());
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Question>> getQuestionById(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuestion = await remoteDataSource.getQuestionById(id);
        return Right(remoteQuestion.toEntity());
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> submitAnswer(
      String questionId, String answer) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.submitAnswer(questionId, answer);
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
