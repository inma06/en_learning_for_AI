# AI 기반 영어 학습 애플리케이션

Flutter를 사용한 AI 기반 영어 학습 애플리케이션입니다.

## 주요 기능

- 소셜 로그인 (Google, Apple)
- 자동 로그인
- 학습 화면
- 연습 화면
- 프로필 관리

## 프로젝트 구조

Clean Architecture 패턴을 적용하여 다음과 같은 구조로 구성되어 있습니다:

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

## 사용된 주요 라이브러리

### 상태 관리
- **flutter_riverpod**: 상태 관리 라이브러리
  - Provider보다 강력한 기능과 타입 안정성 제공
  - 의존성 주입 용이
  - 테스트 용이성
  - 코드 재사용성과 유지보수성 향상

### 데이터 모델링
- **freezed**: 불변 데이터 클래스 생성
  - 보일러플레이트 코드 감소
  - 타입 안정성 강화
  - copyWith, ==, toString 등 자동 생성

### 로컬 스토리지
- **hive**: NoSQL 데이터베이스
  - 빠른 데이터 접근
  - 사용자 정보 저장
- **shared_preferences**: 키-값 저장소
  - 간단한 데이터 저장
  - 토큰 관리

### HTTP 통신 (추가 예정)
- **dio**: HTTP 클라이언트
  - HTTP 요청 처리
  - 인터셉터, 요청/응답 변환
  - 에러 처리
- **retrofit**: API 인터페이스 정의
  - API 엔드포인트를 인터페이스로 정의
  - 자동 구현체 생성
  - 타입 안정성과 코드 재사용성 향상

## Dio와 Retrofit을 함께 사용하는 이유

1. **코드 품질**
   - Retrofit이 API 인터페이스를 깔끔하게 정의
   - 반복적인 HTTP 요청 코드 제거
   - 타입 안정성 보장

2. **유지보수성**
   - API 변경 시 인터페이스만 수정
   - 구현체 자동 생성
   - 테스트 작성 용이

3. **확장성**
   - 새로운 API 엔드포인트 추가 용이
   - 인터셉터, 에러 처리 중앙 관리

4. **생산성**
   - 보일러플레이트 코드 감소
   - API 문서 기반 인터페이스 정의
   - 실수 가능성 감소

## 시작하기

1. Flutter 개발 환경 설정
2. 의존성 설치
   ```bash
   flutter pub get
   ```
3. 앱 실행
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

