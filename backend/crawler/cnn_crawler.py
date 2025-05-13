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
import logging
from typing import Optional, Dict, List
import time

# 로깅 설정
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('crawler.log'),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)

# 프로젝트 루트 경로를 Python 경로에 추가
project_root = str(Path(__file__).parent.parent.parent)
sys.path.append(project_root)

# 루트 디렉토리의 .env 파일에서 환경 변수 로드
load_dotenv(os.path.join(project_root, '.env'))

class CrawlerError(Exception):
    """크롤러 관련 커스텀 예외"""
    pass

class CNNCrawler:
    def __init__(self):
        self.mongo_uri = os.getenv('MONGO_URI', 'mongodb://localhost:27017/language_learning')
        self.openai_api_key = os.getenv('OPENAI_API_KEY')
        if not self.openai_api_key:
            raise CrawlerError("OPENAI_API_KEY가 설정되지 않았습니다.")
        
        self.client = MongoClient(self.mongo_uri)
        self.db = self.client.language_learning
        self.headlines_collection = self.db.headlines
        self.questions_collection = self.db.questions
        
        # 인덱스 생성
        self._create_indexes()
        
    def _create_indexes(self):
        """필요한 인덱스 생성"""
        try:
            self.headlines_collection.create_index([('title', 1)], unique=True)
            self.questions_collection.create_index([('headline', 1)], unique=True)
            logger.info("인덱스 생성 완료")
        except Exception as e:
            logger.error(f"인덱스 생성 중 오류 발생: {e}")
            raise

    def generate_question(self, headline: str) -> Optional[Dict]:
        """헤드라인을 기반으로 문제 생성"""
        try:
            client = openai.OpenAI(api_key=self.openai_api_key)
            response = client.chat.completions.create(
                model="gpt-3.5-turbo",
                messages=[
                    {"role": "system", "content": "You are a helpful assistant that creates English exam questions based on news headlines."},
                    {"role": "user", "content": f"Create a multiple choice question based on this headline: {headline}. Return the response in JSON format with 'question', 'choices' (array of 4 options), and 'answer' (the correct choice)."}
                ]
            )
            return json.loads(response.choices[0].message.content)
        except Exception as e:
            logger.error(f"문제 생성 중 오류 발생 (헤드라인: {headline}): {e}")
            return None

    def crawl_headlines(self) -> List[str]:
        """CNN에서 헤드라인 수집"""
        try:
            headers = {
                'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
            }
            response = requests.get('https://edition.cnn.com/', headers=headers, timeout=10)
            response.raise_for_status()
            
            soup = BeautifulSoup(response.text, 'html.parser')
            headlines = []
            
            # 여러 가능한 셀렉터 시도
            selectors = [
                '.container__headline',
                '.card__headline',
                '.container__headline-text'
            ]
            
            for selector in selectors:
                elements = soup.select(selector)
                headlines.extend([el.get_text().strip() for el in elements if el.get_text().strip()])
            
            return list(set(headlines))  # 중복 제거
            
        except requests.RequestException as e:
            logger.error(f"CNN 웹사이트 접근 중 오류 발생: {e}")
            raise CrawlerError(f"CNN 웹사이트 접근 실패: {e}")
        except Exception as e:
            logger.error(f"헤드라인 파싱 중 오류 발생: {e}")
            raise CrawlerError(f"헤드라인 파싱 실패: {e}")

    def process_headline(self, headline: str) -> bool:
        """단일 헤드라인 처리"""
        try:
            current_date = datetime.now(timezone.utc)
            
            # 중복 체크
            if self.headlines_collection.find_one({'title': headline}):
                logger.info(f"중복된 헤드라인 건너뛰기: {headline}")
                return False
            
            # 헤드라인 저장
            headline_doc = {
                'source': 'CNN',
                'title': headline,
                'createdAt': current_date,
                'date': current_date
            }
            
            self.headlines_collection.insert_one(headline_doc)
            logger.info(f"새로운 헤드라인 추가: {headline}")
            
            # 문제 생성 및 저장
            question_data = self.generate_question(headline)
            if question_data:
                question_doc = {
                    'headline': headline,
                    'source': 'CNN',
                    'question': question_data['question'],
                    'choices': question_data['choices'],
                    'answer': question_data['answer'],
                    'createdAt': current_date,
                    'date': current_date,
                    'difficulty': 'medium',  # 기본값
                    'category': 'general'    # 기본값
                }
                
                # 중복 체크 후 저장
                if not self.questions_collection.find_one({'headline': headline}):
                    self.questions_collection.insert_one(question_doc)
                    logger.info(f"문제 생성 및 저장 완료: {headline}")
                    return True
            
            return False
            
        except Exception as e:
            logger.error(f"헤드라인 처리 중 오류 발생: {e}")
            return False

    def run(self):
        """크롤러 실행"""
        try:
            logger.info("CNN 헤드라인 크롤러 시작...")
            headlines = self.crawl_headlines()
            
            success_count = 0
            for headline in headlines:
                if self.process_headline(headline):
                    success_count += 1
                time.sleep(1)  # API 호출 제한 방지
            
            logger.info(f"크롤링 완료! 성공: {success_count}/{len(headlines)}")
            
        except Exception as e:
            logger.error(f"크롤러 실행 중 오류 발생: {e}")
            raise
        finally:
            self.client.close()

if __name__ == "__main__":
    try:
        crawler = CNNCrawler()
        crawler.run()
    except Exception as e:
        logger.error(f"크롤러 실행 실패: {e}")
        sys.exit(1) 