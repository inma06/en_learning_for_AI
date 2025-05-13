/// 앱의 모든 라우트 경로를 상수로 정의하는 파일
///
/// 이 파일의 목적:
/// 1. 라우트 경로 문자열을 한 곳에서 중앙 관리
/// 2. 경로 문자열의 오타 방지
/// 3. IDE의 자동완성 지원
/// 4. 경로 변경 시 한 곳만 수정하면 되도록 관리
///
/// 사용 예시:
/// ```dart
/// context.push(AppRoutes.home);
/// context.go(AppRoutes.login);
/// ```

class AppRoutes {
  /// 스플래시 화면
  static const String splash = '/';

  /// 권한 요청 화면
  static const String permissions = '/permissions';

  /// 로그인 화면
  static const String login = '/login';

  /// 메인 화면 (홈)
  static const String home = '/home';

  /// 말하기 연습 화면
  static const String speakingPractice = '/practice/speaking';

  /// 듣기 연습 화면
  static const String listeningPractice = '/practice/listening';

  /// 쓰기 연습 화면
  static const String writingPractice = '/practice/writing';

  /// 단어 연습 화면
  static const String vocabularyPractice = '/practice/vocabulary';
}
