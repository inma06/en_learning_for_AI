# CNN 헤드라인 크롤러 사용 가이드

## 개요
CNN 헤드라인 크롤러는 CNN 뉴스 웹사이트에서 최신 헤드라인을 수집하고, OpenAI API를 사용하여 영어 학습용 문제를 자동으로 생성하는 도구입니다.

## 기능
- CNN 웹사이트에서 최신 헤드라인 수집
- OpenAI API를 사용한 영어 학습 문제 자동 생성
- MongoDB에 헤드라인과 문제 저장
- 중복 데이터 방지
- 자동화된 크롤링 (매일 오전 9시)

## 시스템 요구사항
- Python 3.9.6 이상
- Docker
- MongoDB
- OpenAI API 키

## 설치 방법

### 1. 환경 설정
1. 프로젝트 루트 디렉토리에 `.env` 파일 생성:
```env
MONGO_URI=mongodb://admin:password@mongodb:27017
OPENAI_API_KEY=your_openai_api_key
```

### 2. Docker를 사용한 설치
```bash
# 프로젝트 루트 디렉토리에서
docker-compose up -d
```

### 3. 수동 설치
```bash
cd backend/crawler
pip install -r requirements.txt
```

## 사용 방법

### Docker를 사용한 실행
크롤러는 Docker Compose로 실행 시 자동으로 매일 오전 9시에 실행됩니다.

### 수동 실행
```bash
cd backend/crawler
python cnn_crawler.py
```

## 로그 확인
크롤러 로그는 다음 위치에서 확인할 수 있습니다:
- Docker 사용 시: `docker logs language_learning_crawler`
- 수동 실행 시: `backend/crawler/crawler.log`

## 문제 해결

### 1. 크롤링 실패
- CNN 웹사이트 접근이 차단된 경우
  - User-Agent 헤더 확인
  - IP 차단 여부 확인
- 네트워크 연결 확인
  - MongoDB 연결 상태 확인
  - 인터넷 연결 상태 확인

### 2. OpenAI API 오류
- API 키 유효성 확인
- API 호출 제한 확인
- 네트워크 연결 상태 확인

### 3. MongoDB 연결 오류
- MongoDB 서버 실행 상태 확인
- 연결 문자열 확인
- 인증 정보 확인

## 모니터링
크롤러의 실행 상태는 다음 방법으로 모니터링할 수 있습니다:

1. 로그 확인
```bash
docker logs -f language_learning_crawler
```

2. MongoDB 데이터 확인
```bash
# MongoDB 쉘 접속
docker exec -it language_learning_mongodb mongosh

# 데이터 확인
use language_learning
db.headlines.find().sort({date: -1}).limit(5)
db.questions.find().sort({date: -1}).limit(5)
```

## 유지보수

### 로그 로테이션
크롤러 로그는 자동으로 로테이션되며, 최대 7일간 보관됩니다.

### 데이터 백업
MongoDB 데이터는 Docker 볼륨에 저장되며, 정기적인 백업을 권장합니다.

### 크롤러 업데이트
크롤러 코드 업데이트 시:
```bash
docker-compose build crawler
docker-compose up -d crawler
``` 