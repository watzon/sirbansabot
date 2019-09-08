-- +micrate Up
-- SQL in section 'Up' is executed when this migration is applied
CREATE TABLE chats(
    id INT PRIMARY KEY,
    description VARCHAR(2048),
    title VARCHAR(255),
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    username VARCHAR(255),
    invite_link VARCHAR(255)
);

-- +micrate Down
-- SQL section 'Down' is executed when this migration is rolled back
DROP TABLE chats;