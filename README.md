# AI 기반 영어 학습 애플리케이션

Flutter를 사용하여 Feature-based Clean Architecture와 Riverpod 상태 관리를 적용한 혁신적인 AI 기반 영어 학습 애플리케이션입니다.

## 프로젝트 구조

```
lib/
├── core/
│   ├── config/      # App configurations
│   ├── error/       # Error handling
│   ├── network/     # Network configurations
│   ├── storage/     # Local storage setup
│   └── utils/       # Utility functions
│
├── features/
│   ├── auth/        # Authentication
│   ├── learning/    # Learning
│   ├── profile/     # User profile
│   └── settings/    # App settings
│   └── Each feature follows Clean Architecture:
│       ├── data/
│       │   ├── datasources/  # Data sources
│       │   ├── models/       # Data models
│       │   └── repositories/ # Repository implementations
│       ├── domain/
│       │   ├── entities/     # Business entities
│       │   ├── repositories/ # Repository interfaces
│       │   └── usecases/     # Use cases
│       └── presentation/
│           ├── providers/    # State management
│           ├── screens/      # Screens
│           └── widgets/      # Widgets
```

## 기술 스택

- **상태 관리**: Riverpod
- **아키텍처**: Feature-based Clean Architecture
- **네트워크**: Dio + Retrofit
- **로컬 저장소**: Hive + SharedPreferences
- **코드 생성**: Freezed, JSON Serializable
- **기타**: Logger, Intl, Flutter DotEnv

## 설치 방법

1. **필수 조건**
   - Flutter SDK (>=3.1.3)
   - Dart SDK (>=3.1.3)

2. **설치**
   ```bash
   # 저장소 복제
   git clone [repository-url]
   cd language_learning_app

   # 의존성 설치
   flutter pub get
   ```

3. **환경 설정**
   - 프로젝트 루트에 `.env` 파일 생성
   - 필요한 환경 변수 추가 (API keys, etc.)

4. **코드 생성**
   ```bash
   # 코드 생성 실행
   flutter pub run build_runner build --delete-conflicting-outputs

   # 또는 개발 중 자동 생성 모드
   flutter pub run build_runner watch
   ```

5. **앱 실행**
   ```bash
   flutter run
   ```

## 개발 가이드라인

### 코드 생성
프로젝트에서 사용하는 코드 생성 도구들:
- Freezed: Immutable models
- JSON Serializable: JSON parsing
- Riverpod Generator: State management
- Retrofit Generator: API clients

### 상태 관리
- Riverpod를 사용한 상태 관리
- 의존성 주입을 위한 프로바이더 패턴 사용
- 복잡한 상태 관리를 위한 StateNotifier 활용

### 아키텍처
프로젝트는 Clean Architecture 원칙을 따릅니다:
- **데이터 계층**: 저장소 구현, 데이터 모델, 데이터 소스
- **도메인 계층**: 비즈니스 로직, 엔티티, 저장소 인터페이스
- **프레젠테이션 계층**: UI 컴포넌트와 상태 관리

### 추천 IDE 확장 프로그램
- Flutter
- Dart
- Flutter Widget Snippets
- Awesome Flutter Snippets
- Flutter Intl
- Error Lens
- GitLens
- Better Comments

## 기여 방법
[기여 가이드라인 추가 예정]

## 라이선스
[라이선스 정보 추가 예정]
