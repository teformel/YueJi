-- Database Initialization Script for YueJi Novel Software
-- Compliant with Requirement Analysis Report
-- Table Prefix: t_*

-- 1. Drop existing tables (Reverse order of dependencies)
DROP TABLE IF EXISTS t_announcement; -- [NEW]
DROP TABLE IF EXISTS t_chapter_purchase; -- [NEW]
DROP TABLE IF EXISTS t_coin_log;
DROP TABLE IF EXISTS t_comment;
DROP TABLE IF EXISTS t_collection;
DROP TABLE IF EXISTS t_follow;
DROP TABLE IF EXISTS t_chapter;
DROP TABLE IF EXISTS t_novel;
DROP TABLE IF EXISTS t_author;
DROP TABLE IF EXISTS t_category;
DROP TABLE IF EXISTS t_user;

-- Drop legacy tables if they exist
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

-- 2. Create Tables

-- Table 1: t_user (User Information)
CREATE TABLE t_user (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    realname VARCHAR(50),
    phone VARCHAR(20),
    coin_balance DECIMAL(10,2) DEFAULT 0.00,
    role SMALLINT DEFAULT 0,
    status SMALLINT DEFAULT 1,
    last_login_time TIMESTAMP,
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table 5: t_category
CREATE TABLE t_category (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    created_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table 6: t_author
CREATE TABLE t_author (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES t_user(id) ON DELETE SET NULL,
    penname VARCHAR(100) NOT NULL UNIQUE,
    introduction TEXT,
    status SMALLINT DEFAULT 1 -- 0: Pending, 1: Approved, 2: Rejected
);

-- Table 2: t_novel
CREATE TABLE t_novel (
    id SERIAL PRIMARY KEY,
    author_id INT REFERENCES t_author(id),
    category_id INT REFERENCES t_category(id),
    name VARCHAR(100) NOT NULL,
    cover VARCHAR(200),
    description TEXT,
    total_chapters INT DEFAULT 0,
    view_count INT DEFAULT 0, -- [NEW] Hotness/Heat
    status INT DEFAULT 1
);

-- Table 3: t_chapter
CREATE TABLE t_chapter (
    id SERIAL PRIMARY KEY,
    novel_id INT REFERENCES t_novel(id) ON DELETE CASCADE,
    title VARCHAR(200) NOT NULL,
    content TEXT,
    price DECIMAL(10,2) DEFAULT 0.00,
    is_paid SMALLINT DEFAULT 0,
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table 4: t_coin_log (Transaction Logs)
CREATE TABLE t_coin_log (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES t_user(id),
    type INT NOT NULL, -- 0: Recharge, 1: Consumption
    amount DECIMAL(10,2) NOT NULL,
    remark VARCHAR(500),
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- [NEW] Table 9: t_chapter_purchase (Unlock Records)
CREATE TABLE t_chapter_purchase (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES t_user(id) ON DELETE CASCADE,
    chapter_id INT REFERENCES t_chapter(id) ON DELETE CASCADE,
    price DECIMAL(10,2),
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, chapter_id)
);

-- Table 7: t_comment
CREATE TABLE t_comment (
    id SERIAL PRIMARY KEY,
    novel_id INT REFERENCES t_novel(id) ON DELETE CASCADE,
    user_id INT REFERENCES t_user(id),
    content VARCHAR(500),
    reply_to_id INT,
    status SMALLINT DEFAULT 1,
    score INT DEFAULT 5, -- [NEW]
    created_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table 8: t_collection
CREATE TABLE t_collection (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES t_user(id) ON DELETE CASCADE,
    novel_id INT REFERENCES t_novel(id) ON DELETE CASCADE,
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, novel_id)
);

-- Table Reading Progress
CREATE TABLE t_reading_progress (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES t_user(id) ON DELETE CASCADE,
    novel_id INT REFERENCES t_novel(id) ON DELETE CASCADE,
    chapter_id INT,
    scroll_y INT DEFAULT 0,
    total_reading_time INT DEFAULT 0, -- [NEW] in seconds
    update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, novel_id)
);

-- Table 10: t_announcement (System Announcements)
CREATE TABLE t_announcement (
    id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    content TEXT,
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active SMALLINT DEFAULT 1 -- 1: Display, 0: Hidden
);

-- Table 11: t_follow (FR-C-003)
CREATE TABLE t_follow (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES t_user(id),
    author_id INT NOT NULL REFERENCES t_author(id),
    created_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, author_id)
);

-- 3. Initialize Data
INSERT INTO t_user (username, password, realname, phone, coin_balance, role, status) VALUES 
('admin', '0192023a7bbd73250516f069df18b500', 'Administrator', '13800000000', 999999.00, 1, 1),
('user1', 'e10adc3949ba59abbe56e057f20f883e', 'Reader One', '13900000001', 100.00, 0, 1);

INSERT INTO t_category (name) VALUES ('玄幻'), ('都市'), ('仙侠'), ('历史'), ('科幻');

INSERT INTO t_author (user_id, penname, introduction, status) VALUES 
(NULL, '鲁迅', '著名文学家', 1), 
(NULL, '金庸', '武侠泰斗', 1),
(1, '官方运营', '阅己官方账号', 1); -- Admin as Author

INSERT INTO t_novel (author_id, category_id, name, cover, description, total_chapters, status, view_count) VALUES 
(1, 4, '狂人日记', '/static/covers/default.jpg', '借狂人之口，暴露家族制度与礼教的弊害。', 1, 2, 1000),
(2, 3, '笑傲江湖', '/static/covers/default.jpg', '生性放荡不羁的令狐冲...', 2, 2, 5000);

INSERT INTO t_chapter (novel_id, title, content, price, is_paid) VALUES 
(1, '第一章', '今天晚上，很好的月光。即使没有月光，我也要写作业。', 0.00, 0),
(2, '第一回 灭门', '和风熏柳，花香醉人，正是南国春光漫烂季节...', 0.00, 0),
(2, '第二回 聆秘', '林平之大叫一声，晕了过去...', 10.00, 1);

-- Sample Comments with Scores
INSERT INTO t_comment (novel_id, user_id, content, score) VALUES 
(1, 1, '发人深省的作品，五星好评！', 5),
(1, 2, '文学价值极高，但是读起来有点压抑。', 4),
(2, 2, '金庸武侠经典之作，百看不厌。', 5);

INSERT INTO t_reading_progress (user_id, novel_id, chapter_id, scroll_y, total_reading_time) VALUES
(2, 1, 1, 100, 3600); -- user1 read 1 hour of 狂人日记

INSERT INTO t_announcement (title, content, is_active) VALUES
('系统上线公告', '欢迎来到阅己小说阅读系统！在这里，您可以读懂故事，更是读懂自己。', 1),
('充值优惠活动', '即日起，首充即送 10% 书币，快来领取吧！', 1);
