import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/word.dart';
import '../models/word_list.dart';
import '../models/learning_report.dart';
import '../models/wrong_answer.dart';
import '../../../../core/services/openai_service.dart';

class VocabularyService {
  final Ref ref;
  final List<WrongAnswer> _wrongAnswers = [];
  static const String _masteredWordsKey = 'mastered_words';

  VocabularyService(this.ref);

  Future<String> generateConversationWithWords(WordList wordList) async {
    final openAIService = ref.read(openAIServiceProvider);
    final words = wordList.words
        .where((word) => !word.isMastered)
        .map((word) => word.english)
        .toList();

    final prompt = '''
Generate a natural conversation in English that incorporates these words naturally:
${words.join(', ')}

The conversation should:
1. Be casual and natural
2. Use the words in context
3. Be about 5-6 exchanges long
4. Include questions that encourage using the target words
''';

    return await openAIService.generateText(prompt);
  }

  Future<LearningReport> generateLearningReport(WordList wordList) async {
    final openAIService = ref.read(openAIServiceProvider);

    // 분석할 데이터 준비
    final incorrectWords = wordList.mostIncorrectWords;
    final incorrectCountByWord = {
      for (var word in wordList.words) word.english: word.wrongCount
    };

    // 평균 정확도 계산 수정
    final totalWords = wordList.totalWords;
    final masteredWords = wordList.masteredWords;
    final averageAccuracy = totalWords > 0 ? masteredWords / totalWords : 0.0;

    // AI에게 분석 요청
    final prompt = '''
Analyze this vocabulary learning data and provide recommendations:

Words with most mistakes:
${incorrectWords.take(5).map((w) => '- ${w.english}: ${w.wrongCount} mistakes').join('\n')}

Total words: $totalWords
Mastered words: $masteredWords
Average accuracy: ${(averageAccuracy * 100).toStringAsFixed(1)}%

Based on this data:
1. List 5 words that need the most review
2. Suggest 5 new words that would be good to learn next
3. Provide a brief analysis of learning patterns
''';

    final analysis = await openAIService.generateText(prompt);

    // 추천 단어 추출
    final recommendedWords = _extractRecommendedWords(analysis);

    return LearningReport(
      wordListId: wordList.id,
      generatedAt: DateTime.now(),
      mostIncorrectWords: incorrectWords,
      recentlyPracticedWords: wordList.recentlyPracticedWords,
      incorrectCountByWord: incorrectCountByWord,
      averageAccuracy: averageAccuracy,
      totalWords: totalWords,
      masteredWords: masteredWords,
      recommendedWords: recommendedWords,
    );
  }

  List<String> _extractRecommendedWords(String analysis) {
    // AI 응답에서 추천 단어 추출 로직
    final lines = analysis.split('\n');
    final recommendedWords = <String>[];

    for (var line in lines) {
      if (line.contains('recommend') || line.contains('suggest')) {
        final words = line
            .split(RegExp(r'[,\s]+'))
            .where((word) => word.length > 2)
            .take(5)
            .toList();
        recommendedWords.addAll(words);
      }
    }

    return recommendedWords.take(5).toList();
  }

  Future<WordList> createNewWordList(List<String> words) async {
    final openAIService = ref.read(openAIServiceProvider);
    final wordDetails = <Word>[];

    for (var word in words) {
      final prompt = '''
Provide the Korean translation and an example sentence for this English word: $word

Format:
Translation: [Korean meaning]
Example: [English example sentence]
''';

      final response = await openAIService.generateText(prompt);
      final translation = _extractTranslation(response);
      final example = _extractExample(response);

      wordDetails.add(Word(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        english: word,
        korean: translation,
        example: example,
        lastPracticed: DateTime.now(),
      ));
    }

    return WordList(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Recommended Words',
      description: 'Words recommended based on your learning patterns',
      words: wordDetails,
      createdAt: DateTime.now(),
      lastStudied: DateTime.now(),
    );
  }

  String _extractTranslation(String response) {
    final match = RegExp(r'Translation:\s*(.+)').firstMatch(response);
    return match?.group(1)?.trim() ?? '';
  }

  String _extractExample(String response) {
    final match = RegExp(r'Example:\s*(.+)').firstMatch(response);
    return match?.group(1)?.trim() ?? '';
  }

  Future<WordList> getWordList(String userId) async {
    // TODO: 백엔드 연동 시 실제 API 호출로 대체
    return WordList(
      id: 'temp',
      title: '기본 단어장',
      description: '기본 단어 학습',
      words: [],
      createdAt: DateTime.now(),
      lastStudied: DateTime.now(),
    );
  }

  Future<void> updateWordProgress(Word word, bool isCorrect,
      {String? userAnswer}) async {
    if (isCorrect) {
      word.isMastered = true;
      word.wrongCount = 0;
      word.accuracy = 1.0;
      await _saveMasteredWord(word.id);
    } else {
      word.isMastered = false;
      word.wrongCount = word.wrongCount + 1;
      word.accuracy = 0.0;
      _wrongAnswers.add(
        WrongAnswer(
          wordId: word.id,
          english: word.english,
          korean: word.korean,
          wrongDate: DateTime.now(),
          wrongCount: word.wrongCount,
          userAnswer: userAnswer,
        ),
      );
    }
  }

  Future<void> _saveMasteredWord(String wordId) async {
    final prefs = await SharedPreferences.getInstance();
    final masteredWords = prefs.getStringList(_masteredWordsKey) ?? [];
    if (!masteredWords.contains(wordId)) {
      masteredWords.add(wordId);
      await prefs.setStringList(_masteredWordsKey, masteredWords);
    }
  }

  Future<List<String>> getMasteredWordIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_masteredWordsKey) ?? [];
  }

  Future<void> loadMasteredStatus(WordList wordList) async {
    final masteredWordIds = await getMasteredWordIds();
    for (var word in wordList.words) {
      word.isMastered = masteredWordIds.contains(word.id);
    }
  }

  Future<List<WrongAnswer>> getWrongAnswers() async {
    // TODO: 백엔드 연동 시 실제 API 호출로 대체
    return _wrongAnswers;
  }

  Future<List<Word>> getFrequentlyWrongWords() async {
    // TODO: 백엔드 연동 시 실제 API 호출로 대체
    final wrongWords = _wrongAnswers
        .where((wa) => wa.wrongCount >= 3)
        .map((wa) => Word(
              id: wa.wordId,
              english: wa.english,
              korean: wa.korean,
              lastPracticed: wa.wrongDate,
              wrongCount: wa.wrongCount,
              accuracy: 0.0,
            ))
        .toList();
    return wrongWords;
  }
}

final vocabularyServiceProvider = Provider<VocabularyService>((ref) {
  return VocabularyService(ref);
});
