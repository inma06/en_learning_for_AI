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

    def generate_paragraph_from_headline(self, headline: str) -> Optional[str]:
        """헤드라인을 기반으로 뉴스 지문 생성"""
        try:
            client = openai.OpenAI(api_key=self.openai_api_key)
            response = client.chat.completions.create(
                model="gpt-3.5-turbo",
                messages=[
                    {"role": "system", "content": "You are a professional news writer."},
                    {"role": "user", "content": f"Given the following headline, write a short news paragraph (3-5 sentences) in a neutral, CNN-style tone.\nHeadline: \"{headline}\""}
                ]
            )
            paragraph = response.choices[0].message.content
            if paragraph:
                return paragraph.strip()
            logger.warning(f"OpenAI API로부터 빈 지문 응답 (헤드라인: {headline})")
            return None
        except Exception as e:
            logger.error(f"뉴스 지문 생성 중 OpenAI API 오류 (헤드라인: {headline}): {e}")
            return None

    def generate_question_from_paragraph(self, paragraph: str) -> Optional[Dict]:
        """뉴스 지문을 기반으로 문제 생성"""
        content = None # content 변수 초기화
        try:
            client = openai.OpenAI(api_key=self.openai_api_key)
            response = client.chat.completions.create(
                model="gpt-3.5-turbo",
                messages=[
                    {"role": "system", "content": "You are an English exam writer."},
                    {"role": "user", "content": f"Given the following news paragraph, create one English multiple-choice question (4 choices) based on the main idea. Return the response in JSON format with 'question', 'choices' (array of 4 options), and 'answer' (the correct choice).\n\nParagraph:\n{paragraph}"}
                ]
            )
            content = response.choices[0].message.content
            if content:
                return json.loads(content)
            logger.warning(f"OpenAI API로부터 빈 문제 응답 (지문: {paragraph[:100]}...)")
            return None
        except json.JSONDecodeError as e:
            logger.error(f"문제 생성 결과 JSON 파싱 오류 (지문: {paragraph[:100]}...): {e}")
            if content: # content가 None이 아닐 경우에만 로깅
                logger.error(f"OpenAI API 원본 응답 내용: {content}")
            return None
        except Exception as e:
            logger.error(f"문제 생성 중 OpenAI API 오류 (지문: {paragraph[:100]}...): {e}")
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
            
            # 중복 헤드라인 체크
            if self.headlines_collection.find_one({'title': headline}):
                logger.info(f"중복된 헤드라인 건너뛰기: {headline}")
                return False
            
            # 헤드라인 저장 (선택 사항: 헤드라인 자체를 별도로 저장할 필요가 없다면 이 부분은 제거 가능)
            headline_doc = {
                'source': 'CNN',
                'title': headline,
                'createdAt': current_date,
                'date': current_date # 기존 필드 유지
            }
            self.headlines_collection.insert_one(headline_doc) # questions 컬렉션과 headline 필드로 join 가능
            logger.info(f"새로운 헤드라인 추가 및 저장: {headline}")

            # 1. 헤드라인으로 뉴스 지문 생성
            paragraph = self.generate_paragraph_from_headline(headline)
            if not paragraph:
                # logger.warning(f"뉴스 지문 생성 실패, 헤드라인 건너뛰기: {headline}") # generate_paragraph_from_headline 내부에서 이미 로깅
                return False
            
            logger.info(f"뉴스 지문 생성 완료 (헤드라인: {headline})")

            # 2. 뉴스 지문으로 문제 생성
            question_data = self.generate_question_from_paragraph(paragraph)
            if not question_data:
                # logger.warning(f"문제 생성 실패, 헤드라인 건너뛰기: {headline}") # generate_question_from_paragraph 내부에서 이미 로깅
                return False

            logger.info(f"문제 생성 완료 (헤드라인: {headline})")

            # 3. MongoDB에 새로운 구조로 문제 저장
            question_doc = {
                'headline': headline,
                'paragraph': paragraph,
                'question': question_data['question'],
                'choices': question_data['choices'],
                'answer': question_data['answer'],
                'createdAt': current_date,
                'difficulty': 'medium', 
                'category': 'general'  
            }
            
            # 중복 문제 체크 (헤드라인 기준)
            if not self.questions_collection.find_one({'headline': headline}):
                self.questions_collection.insert_one(question_doc)
                logger.info(f"뉴스 지문 및 문제 저장 완료: {headline}")
                return True
            else:
                logger.info(f"이미 처리된 헤드라인(문제 존재), 건너뛰기: {headline}")
                return False
            
        except Exception as e:
            logger.error(f"헤드라인 처리 중 예기치 않은 오류 발생 (헤드라인: {headline}): {e}")
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