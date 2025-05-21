CREATE TABLE reports (
    id SERIAL PRIMARY KEY,
    academy_id INTEGER REFERENCES academies(id),
    student_id INTEGER REFERENCES students(id),
    report_type VARCHAR(50) NOT NULL,
    report_data JSONB,
    generated_by INTEGER REFERENCES directors(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
); 