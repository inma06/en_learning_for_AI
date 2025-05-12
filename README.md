# AI 기반 영어 학습 플랫폼

뉴스 헤드라인을 활용한 AI 기반 영어 학습 플랫폼입니다. CNN, BBC, Reuters의 최신 뉴스를 기반으로 영어 학습 자료를 자동으로 생성합니다.

## 프로젝트 구조

```
.
├── backend/           # Express.js 기반 API 서버
├── frontend/
│   ├── app/          # Flutter 기반 모바일 앱 (iOS, Android)
│   └── web-admin/    # Next.js 기반 관리자 콘솔
├── crawler/          # Python 기반 뉴스 헤드라인 스크래퍼
└── docker/           # Docker 설정 파일
```

## 기술 스택

### 백엔드
- **Express.js**: API 서버
- **MongoDB**: 데이터베이스
- **OpenAI API**: 영어 학습 자료 생성

### 프론트엔드
- **모바일 앱**: Flutter
  - 상태 관리: Riverpod
  - 데이터 모델링: Freezed
  - HTTP 통신: Dio + Retrofit
  - 로컬 스토리지: Hive, SharedPreferences
- **관리자 콘솔**: Next.js
  - UI 프레임워크: Chakra UI
  - 상태 관리: React Query
  - HTTP 클라이언트: Axios

### 크롤러
- **Python 3.10**: 메인 언어
- **BeautifulSoup4**: 웹 스크래핑
- **MongoDB**: 데이터 저장

## 주요 기능

### 모바일 앱
- 소셜 로그인 (Google, Apple)
- 자동 로그인
- 학습 화면
- 연습 화면
- 프로필 관리

### 관리자 콘솔
- 사용자 관리
- 학습 자료 관리
- 통계 및 분석
- 시스템 설정

### 크롤러
- CNN, BBC, Reuters 뉴스 스크래핑
- 헤드라인 데이터 정제
- MongoDB 저장

## 개발 환경 설정

### 필수 요구사항
- Node.js (LTS 버전)
- Python 3.10
- Flutter (stable 채널)
- Docker와 Docker Compose
- MongoDB

### 로컬 개발 환경 설정

1. 저장소 클론:
   ```bash
   git clone [repository-url]
   cd language_learning_app
   ```

2. 환경 변수 설정:
   ```bash
   # 환경 변수 파일 복사
   cp backend/.env.example backend/.env
   cp frontend/app/.env.example frontend/app/.env
   cp frontend/web-admin/.env.example frontend/web-admin/.env
   ```

3. 개발 환경 실행:
   ```bash
   docker-compose up -d
   ```

4. 각 서비스 실행:

   **백엔드**
   ```bash
   cd backend
   npm install
   npm run dev
   ```

   **모바일 앱**
   ```bash
   cd frontend/app
   flutter pub get
   flutter run
   ```

   **관리자 콘솔**
   ```bash
   cd frontend/web-admin
   npm install
   npm run dev
   ```

   **크롤러**
   ```bash
   cd crawler
   python -m venv venv
   source venv/bin/activate  # Windows: venv\Scripts\activate
   pip install -r requirements.txt
   python main.py
   ```

## Docker 개발 환경

프로젝트는 Docker를 통한 개발 환경을 제공합니다. 전체 스택을 실행하려면:

```bash
docker-compose up -d
```

## 아키텍처

### 모바일 앱 (Clean Architecture)
```
lib/
├── core/              # 핵심 기능
│   ├── config/       # 앱 설정
│   ├── error/        # 에러 처리
│   ├── network/      # 네트워크 설정
│   ├── storage/      # 로컬 저장소
│   └── utils/        # 유틸리티
│
├── features/         # 기능별 모듈
│   ├── auth/         # 인증
│   ├── learning/     # 학습
│   ├── profile/      # 프로필
│   └── settings/     # 설정
│
└── 각 기능은 Clean Architecture 패턴을 따름:
    ├── data/         # 데이터 계층
    ├── domain/       # 도메인 계층
    └── presentation/ # 프레젠테이션 계층
```

## 개발 가이드라인

### 코드 스타일
- Flutter: `flutter format` 사용
- Python: `black` 포맷터 사용
- JavaScript/TypeScript: ESLint + Prettier 사용

### Git 커밋 메시지
- feat: 새로운 기능
- fix: 버그 수정
- docs: 문서 수정
- style: 코드 포맷팅
- refactor: 코드 리팩토링
- test: 테스트 코드
- chore: 빌드 업무 수정

## 라이선스

[라이선스 정보 추가 예정]

## 기여 방법

1. 이슈 생성 또는 기존 이슈 확인
2. 새로운 브랜치 생성
3. 변경사항 커밋
4. Pull Request 생성

## 향후 개발 계획

### 음성 인식 기능
- 음성 인식 정확도 향상
- 음성 파형 시각화
- 발음 평가 시스템

### 학습 기능
- 개인화된 학습 경로
- 학습 통계 및 리포트
- 게이미피케이션 요소

### UI/UX 개선
- 다크 모드
- 다국어 지원
- 접근성 개선

