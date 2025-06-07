import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'wrong_answer_model.dart';

@singleton
class HiveService {
  static const String _wrongAnswersBoxName = 'wrong_answers';

  Box<WrongAnswer>? _wrongAnswersBox;

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(WrongAnswerAdapter());
    _wrongAnswersBox = await Hive.openBox<WrongAnswer>(_wrongAnswersBoxName);
  }

  Future<void> saveWrongAnswer(WrongAnswer wrongAnswer) async {
    await _wrongAnswersBox?.put(wrongAnswer.questionId, wrongAnswer);
  }

  Future<void> deleteWrongAnswer(String questionId) async {
    await _wrongAnswersBox?.delete(questionId);
  }

  List<WrongAnswer> getAllWrongAnswers() {
    return _wrongAnswersBox?.values.toList() ?? [];
  }

  WrongAnswer? getWrongAnswer(String questionId) {
    return _wrongAnswersBox?.get(questionId);
  }

  bool hasWrongAnswer(String questionId) {
    return _wrongAnswersBox?.containsKey(questionId) ?? false;
  }

  Future<void> clearAllWrongAnswers() async {
    await _wrongAnswersBox?.clear();
  }

  int get wrongAnswersCount => _wrongAnswersBox?.length ?? 0;
}
