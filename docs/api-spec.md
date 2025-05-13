# Language Learning App API 명세서

## 기본 정보
- Base URL: `http://localhost:3000/api`
- 모든 요청은 JSON 형식으로 처리됩니다.
- 인증이 필요한 API는 `Authorization: Bearer {token}` 헤더가 필요합니다.

## 인증 API

### 회원가입
- **POST** `/auth/register`
- **설명**: 새로운 사용자를 등록합니다.
- **요청 본문**:
  ```json
  {
    "email": "user@example.com",
    "password": "password123",
    "name": "홍길동"
  }
  ```
- **응답**:
  ```json
  {
    "token": "jwt_token",
    "user": {
      "id": "user_id",
      "email": "user@example.com",
      "name": "홍길동",
      "role": "user"
    }
  }
  ```

### 로그인
- **POST** `/auth/login`
- **설명**: 사용자 로그인을 처리합니다.
- **요청 본문**:
  ```json
  {
    "email": "user@example.com",
    "password": "password123"
  }
  ```
- **응답**: 회원가입과 동일한 형식

## 문제 API

### 문제 목록 조회
- **GET** `/questions`
- **설명**: 문제 목록을 조회합니다.
- **쿼리 파라미터**:
  - `difficulty`: 난이도 필터 (easy, medium, hard)
  - `category`: 카테고리 필터 (business, technology, science, health, entertainment, sports, general)
  - `page`: 페이지 번호 (기본값: 1)
  - `limit`: 페이지당 항목 수 (기본값: 10)
- **응답**:
  ```json
  {
    "totalQuestions": 100,
    "currentPage": 1,
    "totalPages": 10,
    "questions": [
      {
        "headline": "CNN 헤드라인",
        "question": "문제 내용",
        "choices": ["선택지1", "선택지2", "선택지3", "선택지4"],
        "answer": "정답",
        "difficulty": "medium",
        "category": "general",
        "date": "2024-03-20T00:00:00.000Z"
      }
    ]
  }
  ```

### 특정 날짜의 문제 조회
- **GET** `/questions/date/:date`
- **설명**: 특정 날짜의 문제를 조회합니다.
- **URL 파라미터**:
  - `date`: YYYY-MM-DD 형식의 날짜
- **응답**:
  ```json
  {
    "date": "2024-03-20",
    "totalQuestions": 10,
    "questions": [
      {
        "headline": "CNN 헤드라인",
        "question": "문제 내용",
        "choices": ["선택지1", "선택지2", "선택지3", "선택지4"],
        "answer": "정답",
        "difficulty": "medium",
        "category": "general",
        "date": "2024-03-20T00:00:00.000Z"
      }
    ]
  }
  ```

### 헤드라인 목록 조회
- **GET** `/headlines`
- **설명**: 수집된 헤드라인 목록을 조회합니다.
- **응답**:
  ```json
  {
    "headlines": [
      "CNN 헤드라인 1",
      "CNN 헤드라인 2"
    ]
  }
  ```

## 학습 자료 API

### 학습 자료 등록
- **POST** `/materials`
- **설명**: 새로운 학습 자료를 등록합니다.
- **요청 본문**:
  ```json
  {
    "title": "제목",
    "content": "내용",
    "source": "CNN",
    "originalUrl": "https://example.com",
    "publishedAt": "2024-03-20T00:00:00.000Z",
    "difficulty": "intermediate",
    "category": "technology",
    "vocabulary": [
      {
        "word": "단어",
        "definition": "정의",
        "example": "예문"
      }
    ]
  }
  ```

### 학습 자료 목록 조회
- **GET** `/materials`
- **설명**: 학습 자료 목록을 조회합니다.
- **응답**:
  ```json
  [
    {
      "id": "material_id",
      "title": "제목",
      "content": "내용",
      "source": "CNN",
      "difficulty": "intermediate",
      "category": "technology",
      "createdAt": "2024-03-20T00:00:00.000Z"
    }
  ]
  ```

## 에러 응답
모든 API는 에러 발생 시 다음과 같은 형식으로 응답합니다:
```json
{
  "error": "에러 메시지"
}
```

## 상태 코드
- 200: 성공
- 201: 생성 성공
- 400: 잘못된 요청
- 401: 인증 실패
- 403: 권한 없음
- 404: 리소스 없음
- 500: 서버 오류 