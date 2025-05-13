import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:language_learning_app/services/api_service.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([http.Client])
import 'api_service_test.mocks.dart';

void main() {
  late ApiService apiService;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    apiService = ApiService(client: mockClient);
  });

  tearDown(() {
    apiService.dispose();
  });

  group('ApiService Tests', () {
    test('getQuestions returns QuestionResult on success', () async {
      final mockResponse = '''
        {
          "questions": [
            {
              "headline": "Test Headline",
              "question": "Test Question",
              "choices": ["A", "B", "C", "D"],
              "answer": "A",
              "difficulty": "easy",
              "category": "vocabulary",
              "date": "2024-03-20T00:00:00.000Z"
            }
          ],
          "totalPages": 1,
          "currentPage": 1
        }
      ''';

      when(mockClient.get(any)).thenAnswer(
        (_) async => http.Response(mockResponse, 200),
      );

      final result = await apiService.getQuestions();

      expect(result.questions.length, 1);
      expect(result.totalPages, 1);
      expect(result.currentPage, 1);
      expect(result.questions[0].headline, 'Test Headline');
    });

    test('getQuestions throws exception on error', () async {
      when(mockClient.get(any)).thenAnswer(
        (_) async => http.Response('Error', 500),
      );

      expect(
        () => apiService.getQuestions(),
        throwsException,
      );
    });

    test('submitAnswer sends correct data', () async {
      when(mockClient.post(any,
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response('', 200));

      await apiService.submitAnswer(
        questionId: 'test-id',
        answer: 'A',
        isCorrect: true,
      );

      verify(
        mockClient.post(
          any,
          headers: {'Content-Type': 'application/json'},
          body: '{"answer":"A","isCorrect":true}',
        ),
      ).called(1);
    });

    test('submitAnswer throws exception on error', () async {
      when(mockClient.post(any,
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response('Error', 500));

      expect(
        () => apiService.submitAnswer(
          questionId: 'test-id',
          answer: 'A',
          isCorrect: true,
        ),
        throwsException,
      );
    });
  });
}
