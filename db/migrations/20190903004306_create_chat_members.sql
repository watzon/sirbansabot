-- +micrate Up
-- SQL in section 'Up' is executed when this migration is applied
CREATE TABLE chat_members(
    id INTEGER PRIMARY KEY,
    user_id INT NOT NULL,
    chat_id INT NOT NULL,
    is_admin BOOLEAN NOT NULL DEFAULT 0,
    FOREIGN KEY(user_id) REFERENCES users(id),
    FOREIGN KEY(chat_id) REFERENCES chats(id)
);

-- +micrate Down
-- SQL section 'Down' is executed when this migration is rolled back
DROP TABLE chat_members;