import os
import requests # requests 임포트 복원
# import requests # requests는 openai 라이브러리 내에서 사용될 수 있으므로 최상단에 유지하거나, openai만으로 충분하면 제거 검토
from bs4 import BeautifulSoup
from datetime import datetime, timezone
from pymongo import MongoClient
from dotenv import load_dotenv
import sys
from pathlib import Path
import openai # openai 임포트 확인
import json
import logging
from typing import Optional, Dict, List
import time

# transformers 관련 임포트 제거
# try:
#     from transformers import T5Tokenizer, T5ForConditionalGeneration
#     TRANSFORMERS_AVAILABLE = True
# except ImportError:
#     TRANSFORMERS_AVAILABLE = False
#     T5Tokenizer, T5ForConditionalGeneration = None, None

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('crawler.log'),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)

project_root = str(Path(__file__).parent.parent.parent)
sys.path.append(project_root)
load_dotenv(os.path.join(project_root, '.env'))

class CrawlerError(Exception):
    """크롤러 관련 커스텀 예외"""
    pass

class CNNCrawler:
    def __init__(self):
        self.mongo_uri = os.getenv('MONGO_URI', 'mongodb://localhost:27017/language_learning')
        self.openai_api_key = os.getenv('OPENAI_API_KEY')
        # self.huggingface_api_key = os.getenv('HUGGINGFACE_API_KEY') # HuggingFace API 키 로드 주석 처리

        if not self.openai_api_key:
            raise CrawlerError("OPENAI_API_KEY가 설정되지 않았습니다.")
        
        self.client = MongoClient(self.mongo_uri)
        self.db = self.client.language_learning
        self.headlines_collection = self.db.headlines
        self.questions_collection = self.db.questions
        self._create_indexes()

        # 로컬 T5 모델 로드 로직 제거
        # self.local_tokenizer = None
        # self.local_model = None
        # ... (관련 로딩 코드 전체 제거)
        
    def _create_indexes(self):
        """필요한 인덱스 생성"""
        try:
            self.headlines_collection.create_index([('title', 1)], unique=True)
            self.questions_collection.create_index([('headline', 1)], unique=True) # headline으로 문제 중복 체크
            logger.info("인덱스 생성 완료")
        except Exception as e:
            logger.error(f"인덱스 생성 중 오류 발생: {e}")
            raise

    # query_huggingface 함수 주석 처리 또는 삭제
    # def query_huggingface(self, model_url: str, input_text: str, task_params: Optional[Dict] = None) -> Optional[Dict]:
    #     pass

    # generate_text_locally_with_flan_t5_small 함수 삭제

    def generate_paragraph_from_headline(self, headline: str) -> Optional[str]:
        """헤드라인을 기반으로 OpenAI GPT-4o를 사용하여 뉴스 지문 생성"""
        logger.info(f"OpenAI API(gpt-4o)로 지문 생성 시도 (헤드라인: {headline})")
        try:
            client = openai.OpenAI(api_key=self.openai_api_key)
            response = client.chat.completions.create(
                model="gpt-4o", # 모델 업그레이드
                messages=[
                    {"role": "system", "content": "You are a professional news writer. Your task is to generate a concise and informative news paragraph (around 3-5 sentences) based on the provided headline. Focus on clarity, factual reporting, and a neutral tone similar to major news outlets."},
                    {"role": "user", "content": f"Headline: \"{headline}\""}
                ]
            )
            paragraph = response.choices[0].message.content
            if paragraph:
                paragraph = paragraph.strip()
                logger.info(f"OpenAI API(gpt-4o)로 지문 생성 성공 (헤드라인: {headline})")
                return paragraph
            logger.warning(f"OpenAI API(gpt-4o)로부터 빈 지문 응답 (헤드라인: {headline})")
            return None
        except Exception as e:
            logger.error(f"뉴스 지문 생성 중 OpenAI API(gpt-4o) 오류 (헤드라인: {headline}): {e}")
            return None

    def generate_question_from_paragraph(self, paragraph: str) -> Optional[Dict]:
        """뉴스 지문을 기반으로 OpenAI GPT-4o를 사용하여 두 가지 유형의 5지선다 문제 생성"""
        logger.info(f"OpenAI API(gpt-4o)로 두 가지 유형 문제 생성 시도 (지문 일부: {paragraph[:100]}...)")
        content = None
        try:
            client = openai.OpenAI(api_key=self.openai_api_key)
            system_prompt = (
                "You are an expert English exam writer. Your task is to create two types of multiple-choice questions based on the provided news paragraph. "
                "Both questions should have 5 choices (A, B, C, D, E), and the incorrect choices should be plausible distractors. "
                "For each question, assess its difficulty and include a 'difficulty' field with one of the following values: 'easy', 'medium', or 'hard'. "
                "Return the response strictly in JSON format with a main key 'generated_questions'. "
                "This key should contain an object with two sub-keys: 'main_idea_question' and 'fill_in_the_blank_question'.\\n\\n"
                "For 'main_idea_question': Create a question about the main idea or a key detail of the paragraph. "
                "It should have 'question' (string), 'choices' (array of 5 strings), 'answer' (string - one of the choices exactly as written), and 'difficulty' (string: 'easy', 'medium', or 'hard').\\n\\n"
                "For 'fill_in_the_blank_question': First, select a word or a short phrase from the paragraph and replace it with '[BLANK]'. "
                "Then, create a question asking to choose the best option for the blank. The original word/phrase must be the correct answer and one of the choices. "
                "The paragraph with the [BLANK] should be included in the 'question_text_with_blank' field. "
                "This question type should also have 'question_prompt' (e.g., 'Which of the following best fills in the blank?'), 'choices' (array of 5 strings including the correct one), 'answer' (string - the correct word/phrase), and 'difficulty' (string: 'easy', 'medium', or 'hard')."
            )
            user_prompt = f"News Paragraph:\\n{paragraph}"

            response = client.chat.completions.create(
                model="gpt-4o",
                # response_format={"type": "json_object"}, # 필요시 활성화
                messages=[
                    {"role": "system", "content": system_prompt},
                    {"role": "user", "content": user_prompt}
                ]
            )
            content = response.choices[0].message.content
            if content:
                try:
                    content_cleaned = content.strip()
                    if content_cleaned.startswith("```json"):
                        content_cleaned = content_cleaned[len("```json"):].strip()
                        if content_cleaned.endswith("```"):
                            content_cleaned = content_cleaned[:-len("```")].strip()
                    
                    # content_cleaned가 유효한 JSON 문자열 형태인지 추가 확인 (간단한 체크)
                    if not (content_cleaned.startswith("{") and content_cleaned.endswith("}")):
                        logger.error(f"응답이 유효한 JSON 객체 형식이 아님: {content_cleaned}")
                        return None
                        
                    data = json.loads(content_cleaned)

                    # 새로운 JSON 구조 검증 (Linter 오류 수정: \ 제거하고 논리 연산자로 연결)
                    if ('generated_questions' in data and
                        'main_idea_question' in data['generated_questions'] and
                        'fill_in_the_blank_question' in data['generated_questions']):
                        
                        main_q = data['generated_questions']['main_idea_question']
                        blank_q = data['generated_questions']['fill_in_the_blank_question']

                        if (all(k in main_q for k in ['question', 'choices', 'answer', 'difficulty']) and
                            isinstance(main_q.get('choices'), list) and len(main_q['choices']) == 5 and
                            isinstance(main_q.get('difficulty'), str) and main_q.get('difficulty') in ['easy', 'medium', 'hard'] and
                            all(k in blank_q for k in ['question_text_with_blank', 'question_prompt', 'choices', 'answer', 'difficulty']) and
                            isinstance(blank_q.get('choices'), list) and len(blank_q['choices']) == 5 and
                            isinstance(blank_q.get('difficulty'), str) and blank_q.get('difficulty') in ['easy', 'medium', 'hard']):
                            logger.info(f"OpenAI API(gpt-4o)로 두 유형 문제 생성 및 JSON 파싱 성공 (난이도 포함).")
                            return data['generated_questions']
                        else:
                            logger.error(f"OpenAI API(gpt-4o) 새 응답 JSON의 문제 세부 키(난이도 포함) 누락 또는 형식 오류. 데이터: {data}")
                            return None
                    else:
                        logger.error(f"OpenAI API(gpt-4o) 'generated_questions' 키 또는 하위 문제 유형 키 누락. 데이터: {data}")
                        return None
                except json.JSONDecodeError as je:
                    logger.error(f"OpenAI API(gpt-4o) 문제 생성 결과 JSON 파싱 오류: {je}")
                    logger.error(f"JSON 파싱 시도한 원본 내용: {content}")
                    return None
            logger.warning(f"OpenAI API(gpt-4o)로부터 빈 문제 응답 (지문: {paragraph[:100]}...)")
            return None
        except Exception as e:
            logger.error(f"문제 생성 중 OpenAI API(gpt-4o) 오류 (지문: {paragraph[:100]}...): {e}")
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
            selectors = ['.container__headline', '.card__headline', '.container__headline-text']
            for selector in selectors:
                elements = soup.select(selector)
                headlines.extend([el.get_text().strip() for el in elements if el.get_text().strip()])
            return list(set(headlines))
        except requests.RequestException as e:
            logger.error(f"CNN 웹사이트 접근 중 오류 발생: {e}")
            raise CrawlerError(f"CNN 웹사이트 접근 실패: {e}")
        except Exception as e:
            logger.error(f"헤드라인 파싱 중 오류 발생: {e}")
            raise CrawlerError(f"헤드라인 파싱 실패: {e}")

    def process_headline(self, headline: str) -> bool:
        """단일 헤드라인 처리 (OpenAI gpt-4o 사용)"""
        try:
            current_date = datetime.now(timezone.utc)
            
            if self.headlines_collection.find_one({'title': headline}):
                logger.info(f"중복된 헤드라인 건너뛰기: {headline}")
                return False
            
            headline_doc = {'source': 'CNN', 'title': headline, 'createdAt': current_date, 'date': current_date}
            self.headlines_collection.insert_one(headline_doc)
            logger.info(f"새로운 헤드라인 추가 및 저장: {headline}")

            # 1. 헤드라인으로 뉴스 지문 생성 (gpt-4o)
            paragraph = self.generate_paragraph_from_headline(headline) 
            if not paragraph:
                logger.warning(f"OpenAI(gpt-4o) 지문 생성 실패, 헤드라인 건너뛰기: {headline}")
                return False
            # logger.info(f"OpenAI(gpt-4o) 지문 생성 완료 (헤드라인: {headline})") # 함수 내부에서 로깅

            # 2. 뉴스 지문으로 문제 생성 (gpt-4o)
            question_data = self.generate_question_from_paragraph(paragraph)
            if not question_data:
                logger.warning(f"OpenAI(gpt-4o) 문제 생성 실패, 헤드라인 건너뛰기: {headline}")
                return False
            # logger.info(f"OpenAI(gpt-4o) 문제 생성 완료 (헤드라인: {headline})") # 함수 내부에서 로깅

            question_doc = {
                'headline': headline,
                'paragraph': paragraph,
                'source': 'CNN', # 출처(source) 필드 추가
                'main_idea_question': question_data.get('main_idea_question'),
                'fill_in_the_blank_question': question_data.get('fill_in_the_blank_question'),
                'createdAt': current_date,
                # 최상위 difficulty 및 category 필드는 각 문제 객체 내로 이동하거나 제거됨
                # 'difficulty': 'medium', 
                # 'category': 'general'  
            }
            
            if not self.questions_collection.find_one({'headline': headline}):
                self.questions_collection.insert_one(question_doc)
                logger.info(f"지문 및 문제 (gpt-4o) 저장 완료: {headline}")
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
            logger.info("CNN 헤드라인 크롤러 시작 (OpenAI gpt-4o 사용)...")
            headlines = self.crawl_headlines()
            success_count = 0
            for headline in headlines:
                if self.process_headline(headline):
                    success_count += 1
                time.sleep(1)  # API 호출 제한 및 로깅 확인을 위한 지연
            logger.info(f"크롤링 완료! 성공: {success_count}/{len(headlines)}")
        except Exception as e:
            logger.error(f"크롤러 실행 중 오류 발생: {e}")
            raise
        finally:
            self.client.close()

if __name__ == "__main__":
    # 로컬 모델 테스트 코드 제거, 실제 크롤러 실행 로직 복원
    try:
        crawler = CNNCrawler()
        crawler.run()
    except Exception as e:
        logger.error(f"크롤러 실행 실패: {e}")
        sys.exit(1) 