CREATE TABLE academies (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,                    -- 학원명
    business_number VARCHAR(20) UNIQUE NOT NULL,   -- 사업자등록번호
    address TEXT NOT NULL,                         -- 주소
    phone VARCHAR(20) NOT NULL,                    -- 연락처
    email VARCHAR(255) UNIQUE NOT NULL,            -- 이메일
    status VARCHAR(20) DEFAULT 'active',           -- 상태 (active, inactive, suspended)
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 트리거: updated_at 자동 업데이트
CREATE TRIGGER update_academies_updated_at
    BEFORE UPDATE ON academies
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column(); 