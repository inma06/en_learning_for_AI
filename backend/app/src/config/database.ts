import { Pool } from 'pg';
import dotenv from 'dotenv';

dotenv.config();

const pool = new Pool({
  user: process.env.POSTGRES_USER || 'admin',
  host: process.env.POSTGRES_HOST || 'localhost',
  database: process.env.POSTGRES_DB || 'language_learning',
  password: process.env.POSTGRES_PASSWORD || 'admin123',
  port: parseInt(process.env.POSTGRES_PORT || '5432'),
});

export default pool; 