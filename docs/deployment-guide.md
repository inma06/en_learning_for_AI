# Language Learning App 배포 및 운영 가이드

## 시스템 아키텍처
```
[Client] <-> [Nginx] <-> [Backend API] <-> [MongoDB]
                    <-> [Crawler]     <-> [OpenAI API]
```

## 시스템 요구사항
- Docker & Docker Compose
- 2GB 이상 RAM
- 20GB 이상 디스크 공간
- Linux/Unix 기반 운영체제

## 배포 준비

### 1. 환경 변수 설정
프로젝트 루트 디렉토리에 `.env` 파일 생성:
```env
# MongoDB
MONGO_INITDB_ROOT_USERNAME=admin
MONGO_INITDB_ROOT_PASSWORD=your_secure_password

# Backend
NODE_ENV=production
PORT=3000
JWT_SECRET=your_jwt_secret
JWT_EXPIRES_IN=7d

# OpenAI
OPENAI_API_KEY=your_openai_api_key
```

### 2. SSL 인증서 준비
Nginx SSL 설정을 위한 인증서 파일 준비:
- `ssl/cert.pem`
- `ssl/key.pem`

## 배포 방법

### 1. Docker Compose를 사용한 배포
```bash
# 프로젝트 클론
git clone <repository_url>
cd language_learning_app

# 환경 변수 설정
cp .env.example .env
# .env 파일 편집

# 서비스 시작
docker-compose up -d
```

### 2. 수동 배포
```bash
# 백엔드 배포
cd backend
npm install
npm run build
npm start

# 크롤러 배포
cd crawler
pip install -r requirements.txt
python cnn_crawler.py
```

## 모니터링

### 1. 로그 모니터링
```bash
# 전체 로그 확인
docker-compose logs -f

# 개별 서비스 로그 확인
docker-compose logs -f backend
docker-compose logs -f crawler
docker-compose logs -f mongodb
```

### 2. 시스템 모니터링
```bash
# 컨테이너 상태 확인
docker-compose ps

# 리소스 사용량 확인
docker stats
```

## 백업 및 복구

### 1. MongoDB 데이터 백업
```bash
# 백업
docker exec language_learning_mongodb mongodump --out /backup

# 복구
docker exec language_learning_mongodb mongorestore /backup
```

### 2. 설정 파일 백업
```bash
# 중요 설정 파일 백업
tar -czf config_backup.tar.gz .env docker-compose.yml
```

## 유지보수

### 1. 서비스 업데이트
```bash
# 코드 업데이트
git pull

# 서비스 재시작
docker-compose down
docker-compose up -d
```

### 2. 데이터베이스 유지보수
```bash
# MongoDB 쉘 접속
docker exec -it language_learning_mongodb mongosh

# 데이터베이스 최적화
db.repairDatabase()
```

## 문제 해결

### 1. 서비스 시작 실패
- 로그 확인: `docker-compose logs`
- 환경 변수 확인
- 포트 충돌 확인
- 디스크 공간 확인

### 2. 성능 이슈
- MongoDB 인덱스 확인
- API 응답 시간 모니터링
- 리소스 사용량 확인
- 캐시 설정 확인

### 3. 보안 이슈
- SSL 인증서 유효성 확인
- 방화벽 설정 확인
- API 키 보안 확인
- 로그 파일 접근 권한 확인

## 확장

### 1. 수평적 확장
- MongoDB 복제셋 구성
- 로드 밸런서 추가
- 캐시 서버 추가

### 2. 수직적 확장
- 컨테이너 리소스 증가
- MongoDB 리소스 증가
- 캐시 메모리 증가

## 종료

### 1. 서비스 종료
```bash
# 모든 서비스 종료
docker-compose down

# 볼륨 포함 종료
docker-compose down -v
```

### 2. 데이터 백업
```bash
# MongoDB 데이터 백업
docker exec language_learning_mongodb mongodump --out /backup

# 설정 파일 백업
tar -czf final_backup.tar.gz .env docker-compose.yml
``` 