-- Drop tables if they exist
DROP TABLE IF EXISTS sys_chapter_purchase;
DROP TABLE IF EXISTS sys_order;
DROP TABLE IF EXISTS sys_reading_record;
DROP TABLE IF EXISTS sys_follow;
DROP TABLE IF EXISTS sys_collection;
DROP TABLE IF EXISTS sys_comment;
DROP TABLE IF EXISTS sys_chapter;
DROP TABLE IF EXISTS sys_novel;
DROP TABLE IF EXISTS sys_author;
DROP TABLE IF EXISTS sys_user;

-- 1. Users
CREATE TABLE sys_user (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL,
    nickname VARCHAR(50),
    role VARCHAR(20) DEFAULT 'user', -- 'user', 'admin'
    gold_balance INT DEFAULT 0,
    avatar VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Authors
CREATE TABLE sys_author (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    bio TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Novels
CREATE TABLE sys_novel (
    id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    author_id INT REFERENCES sys_author(id),
    category VARCHAR(50),
    intro TEXT,
    cover_url VARCHAR(255),
    is_free BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. Chapters
CREATE TABLE sys_chapter (
    id SERIAL PRIMARY KEY,
    novel_id INT REFERENCES sys_novel(id) ON DELETE CASCADE,
    title VARCHAR(200) NOT NULL,
    content TEXT, -- Storing small text directly. For production, consider external storage.
    word_count INT,
    price INT DEFAULT 0, -- Gold cost
    sort_order INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 5. Comments
CREATE TABLE sys_comment (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES sys_user(id),
    novel_id INT REFERENCES sys_novel(id) ON DELETE CASCADE,
    content TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 6. Collections (Favorites)
CREATE TABLE sys_collection (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES sys_user(id),
    novel_id INT REFERENCES sys_novel(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, novel_id)
);

-- 7. Follows
CREATE TABLE sys_follow (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES sys_user(id),
    author_id INT REFERENCES sys_author(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, author_id)
);

-- 8. Reading Records
CREATE TABLE sys_reading_record (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES sys_user(id),
    novel_id INT REFERENCES sys_novel(id) ON DELETE CASCADE,
    last_read_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 9. Orders (Gold Recharging)
CREATE TABLE sys_order (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES sys_user(id),
    amount INT,
    payment_amount DECIMAL(10, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 10. Chapter Purchases
CREATE TABLE sys_chapter_purchase (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES sys_user(id),
    chapter_id INT REFERENCES sys_chapter(id) ON DELETE CASCADE,
    price INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Initial Data
INSERT INTO sys_user (username, password, nickname, role, gold_balance) VALUES 
('admin', 'admin123', 'System Administrator', 'admin', 999999), -- Replace with hashed pwd in app
('testuser', '123456', 'Test User', 'user', 100);

INSERT INTO sys_author (name, bio) VALUES 
('Lu Xun', 'Famous Chinese writer.'), 
('Jin Yong', 'Wuxia master.');

INSERT INTO sys_novel (title, author_id, category, intro, is_free) VALUES 
('Valid Novels', 1, 'Literature', 'A collection of stories.', TRUE),
('Laughing in the Wind', 2, 'Wuxia', 'A classic martial arts novel.', FALSE);
