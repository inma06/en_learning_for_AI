import os
import requests
from bs4 import BeautifulSoup
from datetime import datetime, timezone
from pymongo import MongoClient
from dotenv import load_dotenv
import sys
from pathlib import Path
import openai
import json

# 프로젝트 루트 경로를 Python 경로에 추가
project_root = str(Path(__file__).parent.parent.parent)
sys.path.append(project_root)

# 루트 디렉토리의 .env 파일에서 환경 변수 로드
load_dotenv(os.path.join(project_root, '.env'))

# MongoDB 연결 설정
MONGO_URI = os.getenv('MONGO_URI', 'mongodb://localhost:27017/language_learning')
client = MongoClient(MONGO_URI)
db = client.language_learning
headlines_collection = db.headlines
questions_collection = db.questions

# OpenAI 설정
openai.api_key = os.getenv('OPENAI_API_KEY')

def generate_question(headline):
    try:
        client = openai.OpenAI()
        response = client.chat.completions.create(
            model="gpt-3.5-turbo",
            messages=[
                {"role": "system", "content": "You are a helpful assistant that creates English exam questions based on news headlines."},
                {"role": "user", "content": f"Create a multiple choice question based on this headline: {headline}. Return the response in JSON format with 'question', 'choices' (array of 4 options), and 'answer' (the correct choice)."}
            ]
        )
        return json.loads(response.choices[0].message.content)
    except Exception as e:
        print(f"Error generating question for headline '{headline}':\n{e}")
        return None

def crawl_cnn_headlines():
    try:
        # CNN 홈페이지 가져오기
        headers = {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
        }
        response = requests.get('https://edition.cnn.com/', headers=headers)
        response.raise_for_status()
        
        # HTML 파싱
        soup = BeautifulSoup(response.text, 'html.parser')
        
        # 디버깅: HTML 구조 확인
        print("HTML 구조 확인 중...")
        
        # 여러 가능한 셀렉터 시도
        headlines = []
        
        # 메인 헤드라인
        main_headlines = soup.select('.container__headline')
        if main_headlines:
            headlines.extend(main_headlines)
            print(f"메인 헤드라인 {len(main_headlines)}개 발견")
            
        # 카드 헤드라인
        card_headlines = soup.select('.card__headline')
        if card_headlines:
            headlines.extend(card_headlines)
            print(f"카드 헤드라인 {len(card_headlines)}개 발견")
            
        # 컨테이너 헤드라인
        container_headlines = soup.select('.container__headline-text')
        if container_headlines:
            headlines.extend(container_headlines)
            print(f"컨테이너 헤드라인 {len(container_headlines)}개 발견")
        
        # 헤드라인 처리 및 저장
        current_date = datetime.now(timezone.utc)
        for headline in headlines:
            title = headline.get_text().strip()
            
            # 빈 제목 건너뛰기
            if not title:
                continue
                
            # 중복 체크
            if headlines_collection.find_one({'title': title}):
                print(f"중복된 헤드라인 건너뛰기: {title}")
                continue
                
            # 헤드라인 문서 생성
            headline_doc = {
                'source': 'CNN',
                'title': title,
                'createdAt': current_date,
                'date': current_date
            }
            
            # MongoDB에 헤드라인 저장
            headlines_collection.insert_one(headline_doc)
            print(f"새로운 헤드라인 추가: {title}")
            
            # 문제 생성 및 저장
            question_data = generate_question(title)
            if question_data:
                question_doc = {
                    'headline': title,
                    'source': 'CNN',
                    'question': question_data['question'],
                    'choices': question_data['choices'],
                    'answer': question_data['answer'],
                    'createdAt': current_date,
                    'date': current_date
                }
                questions_collection.insert_one(question_doc)
                print(f"문제 생성 및 저장 완료: {title}")
            
    except requests.RequestException as e:
        print(f"CNN 웹사이트 가져오기 오류: {e}")
    except Exception as e:
        print(f"헤드라인 처리 중 오류 발생: {e}")
    finally:
        client.close()

if __name__ == "__main__":
    print("CNN 헤드라인 크롤러 시작...")
    crawl_cnn_headlines()
    print("크롤링 완료!") 