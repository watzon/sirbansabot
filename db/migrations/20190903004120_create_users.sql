-- +micrate Up
-- SQL in section 'Up' is executed when this migration is applied
CREATE TABLE users(
    id INT PRIMARY KEY,
    is_bot BOOLEAN,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    username VARCHAR(255),
    language_code VARCHAR(5)
);

-- +micrate Down
-- SQL section 'Down' is executed when this migration is rolled back
DROP TABLE users;