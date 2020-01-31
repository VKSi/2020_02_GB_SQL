
-- Part I
-- -------------------------------------------------------------------------------------------------
-- 1. В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных.
--    Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.

SHOW DATABASES;
CREATE DATABASE sample;
USE sample;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Покупатели';

START TRANSACTION;
INSERT INTO sample.users
	(SELECT * FROM shop.users WHERE id = 1);
DELETE FROM shop.users WHERE id =1;
COMMIT;

SELECT * FROM sample.users;
SELECT * FROM shop.users;

-- -------------------------------------------------------------------------------------------------
-- 2. Создайте представление, которое выводит название name товарной позиции из таблицы
--    products и соответствующее название каталога name из таблицы catalogs.

USE shop;

SELECT * FROM products LIMIT 5;
SELECT * FROM catalogs LIMIT 5;

	SELECT p.name, c.name
		FROM products p
        JOIN catalogs c
			ON p.catalog_id = c.id
    ;

CREATE VIEW task_2 (product , catalog) AS
	SELECT p.name, c.name
		FROM products p
        JOIN catalogs c
			ON p.catalog_id = c.id
    ;
SELECT * FROM task_2;

-- -------------------------------------------------------------------------------------------------
-- Part II
-- -------------------------------------------------------------------------------------------------
-- 1. Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от
--    текущего времени суток. С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с
--    12:00 до 18:00 функция должна возвращать фразу "Добрый день", с 18:00 до 00:00 — "Добрый
--    вечер", с 00:00 до 6:00 — "Доброй ночи".

DROP FUNCTION IF EXISTS hello;

DELIMITER //
CREATE FUNCTION hello ()
RETURNS TEXT NO SQL
BEGIN
	DECLARE hour_ INT;
    DECLARE greeting VARCHAR(255);
    SET hour_= (SELECT DATE_FORMAT(NOW(), "%H"));
    IF (hour_>= 18) THEN SET greeting = 'Добрый вечер';
		ELSEIF (hour_>= 12) THEN SET greeting = 'Добрый день';
		ELSEIF (hour_>= 6) THEN SET greeting = 'Доброе утро';    
		ELSE SET greeting = 'Доброй ночи';
    END IF;
    RETURN greeting;
END//
DELIMITER ;

SELECT hello();

-- -------------------------------------------------------------------------------------------------
-- 2. В таблице products есть два текстовых поля: name с названием товара и description с его
--    описанием. Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля
--    принимают неопределенное значение NULL неприемлема. Используя триггеры, добейтесь
--    того, чтобы одно из этих полей или оба поля были заполнены. При попытке присвоить полям
--    NULL-значение необходимо отменить операцию.

SELECT * FROM products LIMIT 5;

DROP TRIGGER IF EXISTS check_not_null_name_or_description_insert;  
DELIMITER //
CREATE TRIGGER check_not_null_name_or_description_insert BEFORE INSERT ON products
FOR EACH ROW
BEGIN
	IF ((NEW.name IS NULL) AND (NEW.description IS NULL))  THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Either product name or product description should be NOT NULL' ;
	END IF ;
END //
DELIMITER ;

DROP TRIGGER IF EXISTS check_not_null_name_or_description_update;  
DELIMITER //
CREATE TRIGGER check_not_null_name_or_description_update BEFORE UPDATE ON products
FOR EACH ROW
BEGIN
	IF ((NEW.name IS NULL) AND (NEW.description IS NULL))  THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Either product name or product description should be NOT NULL' ;
	END IF ;
END //
DELIMITER ;

INSERT INTO products
  (name, description)
VALUES
  ('New acceptable name', 'New acceptable description'),
  (NULL, 'New acceptable description');
  
SELECT * FROM products;

INSERT INTO products
  (name, description)
VALUES
  ('New acceptable name', NULL),
  (NULL, NULL);

SELECT * FROM products;

