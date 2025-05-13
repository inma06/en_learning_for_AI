#!/bin/bash

# cron 서비스 시작
service cron start

# 로그 파일 모니터링
tail -f /var/log/cron.log 
