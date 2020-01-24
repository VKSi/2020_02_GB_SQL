-- 1. Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.
USE shop;
SHOW TABLES;
SELECT * FROM orders;
SELECT * FROM users;
SELECT * FROM products;

-- Заполним таблицу
INSERT INTO orders
	SELECT
		id, 
		FLOOR(1 + (RAND() * 6)), 
		CURRENT_TIMESTAMP,
		CURRENT_TIMESTAMP 
  FROM products;
  
  SELECT * FROM orders;
  
  -- Решение
  SELECT name
	FROM users
    WHERE id IN (
		SELECT user_id
			FROM orders)
	;
    
	-- Решение с использованием JOIN
  SELECT DISTINCT(name)
	FROM users
    JOIN orders
		ON users.id = orders.user_id
	;
  
-- 2. Выведите список товаров products и разделов catalogs, который соответствует товару.
SELECT * FROM products;
SELECT * FROM catalogs;

SELECT p.name AS 'Product name', c.name AS 'Catalog'
	FROM
		products AS p
    JOIN
		catalogs AS c
	ON p.catalog_id = c.id;

-- 3. (по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name).
-- Поля from, to и label содержат английские названия городов, поле name — русское.
-- Выведите список рейсов flights с русскими названиями городов.

-- Создаем базу и таблицы
CREATE DATABASE destinations;
USE destinations;

DROP TABLE IF EXISTS flights;
CREATE TABLE flights (
  id SERIAL PRIMARY KEY,
  departure VARCHAR(255) COMMENT 'Departure City',
  destination VARCHAR(255) COMMENT 'Destination City'
) COMMENT = 'Available flights';

DROP TABLE IF EXISTS cities;
CREATE TABLE cities (
  label VARCHAR(255) COMMENT 'English name',
  name VARCHAR(255) COMMENT 'Russian name'
) COMMENT = 'Cities names translator';

-- Заполняем таблицы
INSERT INTO flights VALUES
	(NULL, 'moscow', 'omsk'),
    (NULL, 'novgorod', 'kazan'),
    (NULL, 'irkutsk', 'moscow'),
    (NULL, 'omsk', 'irkutsk'),
    (Null, 'moscow', 'kazan');
    
INSERT INTO cities VALUES
	('moscow', 'Москва'),
    ('novgorod', 'Новгород'),
    ('irkutsk', 'Иркутск'),
    ('omsk', 'Омск'),
    ('kazan', 'Казань');

-- Проверяем таблицы    
SELECT * FROM flights;
SELECT * FROM cities;

-- Переведем таблицу отправлений
SELECT c.name AS Отправление
	FROM
		cities as c
	JOIN
		flights as f
	ON  c.label = f.departure;
    
-- Переведем таблицу прибытий    
SELECT c.name AS Прибытие
	FROM
		cities as c
	JOIN
		flights as f
	ON c.label = f.destination;
    
-- Объединим полученные таблицы
SELECT (SELECT c.name
			FROM cities AS c
			WHERE c.label = f.departure) AS Отправление,
		(SELECT c.name
			FROM cities AS c
			WHERE c.label = f.destination) AS Прибытие
FROM flights AS f;

-- Решение с использованием JOIN
SELECT city_dep.name AS 'Отправление', city_dest.name AS 'Прибытие'
	FROM flights
    JOIN cities AS city_dep
		ON flights.departure = city_dep.label
	JOIN cities AS city_dest
		ON flights.destination = city_dest.label;
    