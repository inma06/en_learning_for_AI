# Language Learning App Backend

## OpenAI Question Generation API

### Endpoint
- POST `/api/openai/generate-question`

### Request Body
```json
{
  "headline": "NASA discovers new planet"
}
```

### Response
```json
{
  "question": "What did NASA recently discover?",
  "choices": [
    "A new planet",
    "A new galaxy",
    "A new spacecraft",
    "A new star system"
  ],
  "answer": "A new planet"
}
```

## CNN Headlines Crawler

### Setup
1. Install Python dependencies:
```bash
cd crawler
pip install -r requirements.txt
```

2. Set up environment variables in `.env`:
```
MONGO_URI=your_mongodb_connection_string
OPENAI_API_KEY=your_openai_api_key
```

### Running the Crawler
```bash
python crawler/cnn_crawler.py
```

The crawler will:
1. Fetch headlines from CNN's main page
2. Store unique headlines in MongoDB
3. Skip any duplicate headlines

### MongoDB Schema
```json
{
  "source": "CNN",
  "title": "NASA discovers new planet",
  "createdAt": "2024-05-13T20:00:00Z"
}
```

## Development
1. Install Node.js dependencies:
```bash
npm install
```

2. Start the development server:
```bash
npm run dev
```

The server will run on port 3000 by default. 