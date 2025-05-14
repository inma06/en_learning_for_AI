import 'package:flutter_riverpod/flutter_riverpod.dart';

// 사용자가 선택한 한 페이지당 질문 개수를 관리하는 프로바이더
// 기본값은 10으로 설정 (API의 현재 기본값과 동일하게)
final selectedQuestionLimitProvider = StateProvider<int>((ref) => 10);
