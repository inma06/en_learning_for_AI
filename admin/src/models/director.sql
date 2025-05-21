CREATE TABLE directors (
    id SERIAL PRIMARY KEY,
    academy_id INTEGER UNIQUE REFERENCES academies(id),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    status VARCHAR(20) DEFAULT 'active',
    last_login_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TRIGGER update_directors_updated_at
    BEFORE UPDATE ON directors
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column(); 