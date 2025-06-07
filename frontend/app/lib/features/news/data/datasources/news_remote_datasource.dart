import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../models/question_model.dart';

abstract class NewsRemoteDataSource {
  Future<List<QuestionModel>> getQuestions();
  Future<QuestionModel> getQuestionById(String id);
  Future<void> submitAnswer(String questionId, String answer);
}

@LazySingleton(as: NewsRemoteDataSource)
class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final DioClient dioClient;

  NewsRemoteDataSourceImpl(this.dioClient);

  @override
  Future<List<QuestionModel>> getQuestions() async {
    try {
      final response = await dioClient.dio.get('/openai/questions');
      print('API Response Status: ${response.statusCode}');
      print('API Response Data Keys: ${response.data.keys}');
      print('Questions Length: ${response.data['questions']?.length}');

      final List<dynamic> data = response.data['questions'];
      return data.map((json) => QuestionModel.fromJson(json)).toList();
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      print('DioException Response: ${e.response?.data}');
      throw Exception('Failed to get questions: ${e.message}');
    }
  }

  @override
  Future<QuestionModel> getQuestionById(String id) async {
    try {
      final response = await dioClient.dio.get('/openai/questions/$id');
      return QuestionModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to get question: ${e.message}');
    }
  }

  @override
  Future<void> submitAnswer(String questionId, String answer) async {
    try {
      final url = '/openai/questions/$questionId/answer';
      print('Submitting answer to URL: $url');
      print('Question ID: $questionId');
      print('Answer: $answer');

      await dioClient.dio.post(url, data: {
        'answer': answer,
      });
    } on DioException catch (e) {
      print('DioException in submitAnswer: ${e.message}');
      print('DioException Response: ${e.response?.data}');
      throw Exception('Failed to submit answer: ${e.message}');
    }
  }
}
