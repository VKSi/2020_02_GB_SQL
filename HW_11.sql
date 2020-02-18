-- Практическое задание тема "Оптимизация запросов"
-- 1. Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users,
-- catalogs и products в таблицу logs помещается время и дата создания записи, название
-- таблицы, идентификатор первичного ключа и содержимое поля name.

USE shop;

DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    created_at datetime DEFAULT CURRENT_TIMESTAMP,
    table_name varchar(50) NOT NULL,
    row_id INT UNSIGNED NOT NULL,
    row_name varchar(255)
) ENGINE = Archive;


DROP TRIGGER IF EXISTS products_insert;  
DELIMITER //
CREATE TRIGGER products_insert AFTER INSERT ON products
FOR EACH ROW
BEGIN
    INSERT INTO logs VALUES (NULL, DEFAULT, "products", NEW.id, NEW.name);
END//
DELIMITER ;

DROP TRIGGER IF EXISTS users_insert;  
DELIMITER //
CREATE TRIGGER users_insert AFTER INSERT ON users
FOR EACH ROW
BEGIN
    INSERT INTO logs VALUES (NULL, DEFAULT, "users", NEW.id, NEW.name);
END//
DELIMITER ;

DROP TRIGGER IF EXISTS catalogs_insert;  
DELIMITER //
CREATE TRIGGER catalogs_insert AFTER INSERT ON catalogs
FOR EACH ROW
BEGIN
    INSERT INTO logs VALUES (NULL, DEFAULT, "catalogs", NEW.id, NEW.name);
END//
DELIMITER ;

-- Практическое задание тема "NoSQL"
-- 1. В базе данных Redis подберите коллекцию для подсчета посещений с определенных IP-адресов.
HINCRBY addresses '127.0.0.1' 1
HGETALL addresses

HINCRBY addresses '127.0.0.2' 1
HGETALL addresses

HGET addresses '127.0.0.1'

-- 2. При помощи базы данных Redis решите задачу поиска имени пользователя по электронному
-- адресу и наоборот, поиск электронного адреса пользователя по его имени.
HSET emails 'ivanov' 'ivanov@gmail.com'
HSET emails 'petrov' 'petrov@me.com'
HSET emails 'sidorov' 'sidorov@icloud.com'

HGET emails 'sidorov'

HSET users 'ivanov@gmail.com' 'ivanov'
HSET users 'petrov@me.com' 'petrov'
HSET users 'sidorov@icloud.com' 'sidorov'

HGET users 'petrov@me.com'




