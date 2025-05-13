FROM python:3.9.6-slim

WORKDIR /app

# 시스템 패키지 설치
RUN apt-get update && apt-get install -y \
    cron \
    && rm -rf /var/lib/apt/lists/*

# Python 패키지 설치
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 크롤러 스크립트 복사
COPY cnn_crawler.py .

# cron 작업 설정
RUN echo "0 9 * * * cd /app && python cnn_crawler.py >> /var/log/cron.log 2>&1" > /etc/cron.d/crawler-cron
RUN chmod 0644 /etc/cron.d/crawler-cron

# cron 로그 파일 생성
RUN touch /var/log/cron.log

# cron 서비스 시작 스크립트
COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"] 