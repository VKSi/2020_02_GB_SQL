-- Task #1

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Покупатели';

INSERT INTO users (name, birthday_at) VALUES
  ('Геннадий', '1990-10-05'),
  ('Наталья', '1984-11-12'),
  ('Александр', '1985-05-20'),
  ('Сергей', '1988-02-14'),
  ('Иван', '1998-01-12'),
  ('Мария', '1992-08-29');

SELECT * FROM users;
 
UPDATE users SET created_at = Null;
UPDATE users SET updated_at = Null;
SELECT * FROM users;

UPDATE users SET created_at = NOW(), updated_at = NOW();
SELECT * FROM users;

-- Task #2
DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at VARCHAR(255),
  updated_at VARCHAR(255)
) COMMENT = 'Покупатели';

INSERT INTO users (name, birthday_at, created_at, updated_at) VALUES
  ('Геннадий', '1990-10-05', '20.10.2017 8:10', '20.10.2017 8:10'),
  ('Наталья', '1984-11-12', '20.10.2017 8:10', '20.10.2017 8:10'),
  ('Александр', '1985-05-20', '20.10.2017 8:10', '20.10.2017 8:10'),
  ('Сергей', '1988-02-14', '20.10.2017 8:10', '20.10.2017 8:10'),
  ('Иван', '1998-01-12', '20.10.2017 8:10', '20.10.2017 8:10'),
  ('Мария', '1992-08-29', '20.10.2017 8:10', '20.10.2017 8:10'),
  ('Виктор', '1998-01-19', '20.10.2017 8:10', '20.10.2017 8:10');

DESC users;
SELECT * FROM users;

UPDATE users SET created_at = STR_TO_DATE(created_at, '%d.%m.%Y %H:%i'), updated_at = STR_TO_DATE(updated_at, '%d.%m.%Y %H:%i');
ALTER TABLE users MODIFY created_at DATETIME, MODIFY updated_at DATETIME;

SELECT * FROM users;
DESC users;

-- Task #3

DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
  id SERIAL PRIMARY KEY,
  value INT UNSIGNED COMMENT 'Запас товарной позиции на складе',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Запасы на складе';

INSERT INTO storehouses_products(value) VALUES
	(1), (0), (20), (34), (0), (10), (5);
	
SELECT * 
	FROM
		storehouses_products
	ORDER BY
		value = 0, value;

-- AGREGATION
	
-- Task #1
SELECT AVG(YEAR(NOW()) - YEAR(birthday_at))  FROM users;

-- Task #2
SELECT DAYNAME(CONCAT(YEAR(NOW()), SUBSTRING(birthday_at, 5, 6))) AS DaysOfWeek, COUNT(*) AS Num 
	FROM users
	GROUP BY DaysOfWeek
	WITH ROLLUP;
