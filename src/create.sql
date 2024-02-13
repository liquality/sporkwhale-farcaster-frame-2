-- Create sql db
CREATE TABLE channel (
    id SERIAL PRIMARY KEY,
    channel VARCHAR(255),
    followers INTEGER
);

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    wallet_address VARCHAR(255),
    channel_id INTEGER REFERENCES channel(id),
    fid VARCHAR(255)
);

CREATE TABLE questions (
    id SERIAL PRIMARY KEY,
    question VARCHAR(255)
);

CREATE TABLE user_question_responses (
    id SERIAL PRIMARY KEY,
    question_id INTEGER REFERENCES questions(id),
    user_id INTEGER REFERENCES users(id),
    correct_response BOOLEAN,
    response VARCHAR(255),
    channel_id INTEGER REFERENCES channel(id),
);

CREATE TABLE trait_displayed (
    id SERIAL PRIMARY KEY,
    trait VARCHAR(255),
    channel_id INTEGER REFERENCES channel(id),
);

--IF YOU WANT TO DROP:
DROP TABLE IF EXISTS user_question_responses CASCADE;

DROP TABLE IF EXISTS trait_displayed CASCADE;

DROP TABLE IF EXISTS questions CASCADE;

DROP TABLE IF EXISTS users CASCADE;

--Tester data
INSERT INTO
    questions (question)
VALUES
    ('What is Johanna''s last name?');

INSERT INTO
    trait_displayed (trait, channel)
VALUES
    (
        'glasses_bracelet_chain_bathingSuit_whale.png',
        'skininthegame'
    );