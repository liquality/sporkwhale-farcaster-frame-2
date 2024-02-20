-- Create sql db
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    wallet_address VARCHAR(255),
    fid INTEGER
);

CREATE TABLE questions (
    id SERIAL PRIMARY KEY,
    question VARCHAR(255),
    expired BOOLEAN DEFAULT false
);

CREATE TABLE channels (
    id SERIAL PRIMARY KEY,
    followers INTEGER,
    name VARCHAR(255) UNIQUE NOT NULL,
    c_address VARCHAR(255),
    c_wallet VARCHAR(255),
    c_pool VARCHAR(255),
    salt VARCHAR(255),
    question_id INT,
    FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE user_question_responses (
    id SERIAL PRIMARY KEY,
    question_id INTEGER REFERENCES questions(id) ON DELETE CASCADE,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    correct_response BOOLEAN,
    is_onchain BOOLEAN DEFAULT false,
    response VARCHAR(255),
    channel_id INTEGER REFERENCES channels(id) ON DELETE CASCADE
);

CREATE TABLE trait_displayed (
    id SERIAL PRIMARY KEY,
    trait VARCHAR(255),
    channel_id INTEGER REFERENCES channels(id) ON DELETE CASCADE
);

CREATE TABLE clashes (
    id INT PRIMARY KEY,
    question_id INT,
    channel1_id INT,
    channel2_id INT,
    channel_winner_id INT NULL,
    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (channel1_id) REFERENCES channels(id),
    FOREIGN KEY (channel2_id) REFERENCES channels(id),
    FOREIGN KEY (channel_winner_id) REFERENCES channels(id)
);
create index idx_clashes_question_channels ON clashes (question_id, channel1_id, channel2_id);
-- -- Inserting clashes
-- INSERT INTO
--     clashes (
--         id,
--         question_id,
--         channel1_id,
--         channel2_id,
--         channel_winner_id
--     )
-- VALUES
--     (1, 0, 6, 7, NULL),
--     -- Clash of the stack: backend vs. frontend
--     (2, 0, 8, 9, NULL),
--     -- Gender clash: farcastHER vs. farcastHIM
--     -- Add more clashes here
--     --TODO cron job for setting winners and insert new clashes
--     --TODO frontend group by question_id and display in tree strucutre
--     -- TODO in frame: In frame show correct response rate for the channel 
--     --IF YOU WANT TO DROP:
--     DROP TABLE IF EXISTS user_question_responses CASCADE;

-- DROP TABLE IF EXISTS trait_displayed CASCADE;

-- DROP TABLE IF EXISTS questions CASCADE;

-- DROP TABLE IF EXISTS users CASCADE;

-- DROP TABLE IF EXISTS channels CASCADE;

-- --Tester data
-- INSERT INTO
--     questions (question)
-- VALUES
--     ('What is Johanna''s last name?');

-- INSERT INTO
--     channel (name, followers)
-- VALUES
--     ('cryptostocks', 230);

-- INSERT INTO
--     trait_displayed (trait, channel_id)
-- VALUES
--     (
--         'glasses_bracelet_chain_bathingSuit_whale.png',
--         2
--     );

/*
 INDEXES
 */
CREATE INDEX idx_users_wallet_address ON users (wallet_address);

CREATE INDEX idx_user_question_responses_question_user_channel ON user_question_responses (user_id, question_id, channel_id);

CREATE INDEX idx_channels_name ON channels (name);

CREATE INDEX idx_trait_displayed_traits_channels ON trait_displayed (trait, channel_id);

/*
 QUESTIONS 
 */
alter table
    questions drop column expired;

alter table
    questions
add
    column expires_at timestamp null;

alter table
    questions
add
    column correct_response VARCHAR(255);

alter table
    questions
add
    column options json NOT null default '[]' :: json;

create index idx_questions_id_expires ON questions (id, expires_at);
