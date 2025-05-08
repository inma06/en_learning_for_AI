import 'package:dart_openai/dart_openai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OpenAIService {
  final String apiKey;
  final http.Client _client;

  OpenAIService({required this.apiKey}) : _client = http.Client();

  Future<String> convertToEnglish(String text) async {
    try {
      final prompt = '''
Convert the following Korean text or Korean-accented English to proper English.
If the input is in Korean, translate it to English.
If the input is in Korean-accented English, correct it to proper English.
Keep the meaning as close as possible to the original.

Input: $text

Output only the English text, without any explanations or additional text.''';

      final response = await _client.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {
              'role': 'system',
              'content':
                  'You are a Korean to English translator and pronunciation corrector.',
            },
            {
              'role': 'user',
              'content': prompt,
            },
          ],
          'temperature': 0.3,
          'max_tokens': 100,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'].trim();
      } else {
        throw Exception('Failed to convert text: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error converting text: $e');
    }
  }

  Future<String> getResponse(String prompt) async {
    try {
      final response = await _client.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {
              'role': 'system',
              'content': 'You are a helpful English teacher.',
            },
            {
              'role': 'user',
              'content': prompt,
            },
          ],
          'temperature': 0.7,
          'max_tokens': 150,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'].trim();
      } else {
        throw Exception('Failed to get response: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting response: $e');
    }
  }

  Future<String> getConversationResponse(String text) async {
    return getResponse('''
The student said: $text

Please respond in a friendly and helpful way. Keep your response concise and natural.''');
  }

  Future<String> assessEnglishLevel(String text,
      {required int questionCount}) async {
    if (questionCount == 0) {
      return getResponse('''
You are an English teacher assessing a Korean student's speaking level.
Ask a simple question to start the assessment.
Keep the question very basic and easy to understand.
Do not include any explanations or additional text, just the question.''');
    } else if (questionCount < 2) {
      return getResponse('''
Previous answer: $text
Question number: ${questionCount + 1}

Ask a follow-up question that is slightly more challenging than the previous one.
Keep the question appropriate for the student's level based on their previous answer.
Do not include any explanations or additional text, just the question.''');
    } else {
      return getResponse('''
Based on the student's answers, determine their English level (A1, A2, B1, B2, C1, or C2) and provide brief feedback.
Format your response exactly like this:
Level: [level]
Feedback: [one sentence feedback]''');
    }
  }
}

final openAIServiceProvider = Provider<OpenAIService>((ref) {
  final apiKey = dotenv.env['OPENAI_API_KEY'] ?? '';
  if (apiKey.isEmpty) {
    throw Exception('OpenAI API key not found in environment variables');
  }
  return OpenAIService(apiKey: apiKey);
});
