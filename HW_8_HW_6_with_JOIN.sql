-- 2. Пусть задан некоторый пользователь. 
-- Из всех друзей этого пользователя найдите человека, который больше всех общался 
-- с нашим пользователем.

-- Посмотрим, какая таблица отвечает за общение и что в ней находится
USE vk;

SHOW TABLES FROM vk;
SELECT * FROM messages LIMIT 10;
SELECT * FROM friendship LIMIT 10;
SELECT * FROM friendship_statuses LIMIT 10;

-- Выберем всю переписку заданного пользователя
 SELECT m.from_user_id, m.to_user_id
  FROM users
    JOIN messages AS m
      ON users.id = m.to_user_id
	      OR users.id = m.from_user_id
  WHERE users.id = 57
 ;
 
 -- Сосчитаем письма
SELECT COUNT(*) AS activity, m.from_user_id, m.to_user_id
  FROM users
    JOIN messages AS m
      ON users.id = m.to_user_id
	      OR users.id = m.from_user_id
  WHERE users.id = 57
  GROUP BY m.from_user_id, m.to_user_id
  ORDER BY activity DESC
 ;

-- Чтобы получить адекватный результат, добавим в друзья пользователя с перепиской
INSERT INTO friendship VALUES
	(29, 57, 2, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP());

-- Также создадим "конкуренцию" при подсчете отправленных и полученных сообщений
-- На используемой базе получим для from, to, number_of_messages наборы (57, 29, 3), (16, 57, 2), (57, 16, 2)
-- Это позволит в дальнейшем проконтролировать правильность сортировки. Результат должен быть пользователь 16, а не 29  
INSERT INTO messages VALUES
    (NULL, 57, 16, 'Additional message 1', FLOOR(RAND()+1), FLOOR(RAND()+1), CURRENT_TIMESTAMP()),
    (NULL, 57, 16, 'Additional message 2', FLOOR(RAND()+1), FLOOR(RAND()+1), CURRENT_TIMESTAMP());
    
INSERT INTO messages VALUES
	(NULL, 57, 29, 'Additional message 0', FLOOR(RAND()+1), FLOOR(RAND()+1), CURRENT_TIMESTAMP()),
    (NULL, 16, 57, 'Additional message 3', FLOOR(RAND()+1), FLOOR(RAND()+1), CURRENT_TIMESTAMP());    
    
-- Отфильтруем друзей
 SELECT COUNT(*) AS activity, m.from_user_id, m.to_user_id
  FROM users
    JOIN messages AS m
      ON users.id = m.to_user_id
	      OR users.id = m.from_user_id
	JOIN friendship AS f
	  ON (f.user_id = m.from_user_id AND f.friend_id = m.to_user_id)
		OR (f.user_id = m.to_user_id AND f.friend_id = m.from_user_id)
	JOIN friendship_statuses
	  ON friendship_statuses.id = f.status_id
  WHERE users.id = 57 AND friendship_statuses.name = 'Confirmed'
  GROUP BY m.from_user_id, m.to_user_id
  ORDER BY activity DESC
 ;
 
 -- Используя тот факт, что в одном из столбцов всегда находится номер нашего пользователя (57),
 -- найдем id во втором столбце математически
  SELECT (m.from_user_id + m.to_user_id - 57) AS the_best_friend_id, COUNT(*) AS activity
  FROM users
    JOIN messages AS m
      ON users.id = m.to_user_id
	      OR users.id = m.from_user_id
	JOIN friendship AS f
	  ON (f.user_id = m.from_user_id AND f.friend_id = m.to_user_id)
		OR (f.user_id = m.to_user_id AND f.friend_id = m.from_user_id)
	JOIN friendship_statuses
	  ON friendship_statuses.id = f.status_id
  WHERE users.id = 57 AND friendship_statuses.name = 'Confirmed'
  GROUP BY the_best_friend_id
  ORDER BY activity DESC
  LIMIT 1
 ;
    
-- 3. Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей.
SHOW TABLES FROM vk;
SELECT * FROM users LIMIT 10;
SELECT * FROM likes LIMIT 10;
SELECT * FROM target_types LIMIT 10;
SELECT * FROM profiles LIMIT 10; 

-- Для проверки корректности работы запроса, для начала выведем таблицу, по которой будет происходить суммирование    
SELECT CONCAT(u.first_name, ' ', u.last_name, ', id = ', u.id) AS 'User', COUNT(*) AS 'Number of likes', p.birthday
	FROM users u
		JOIN likes l
			ON u.id = l.target_id
		JOIN profiles p
			ON u.id = p.user_id
		JOIN target_types tt
			ON l.target_type_id = tt.id
	WHERE tt.name = 'users'
    GROUP BY u.id
    ORDER BY p.birthday DESC
    LIMIT 10;

-- Сумируем полученный результат
SELECT SUM(num_of_likes) AS 'Total number of likes' FROM 
  (SELECT COUNT(*) AS num_of_likes
	FROM users u
		JOIN likes l
			ON u.id = l.target_id
		JOIN profiles p
			ON u.id = p.user_id
		JOIN target_types tt
			ON l.target_type_id = tt.id
	WHERE tt.name = 'users'
    GROUP BY u.id
    ORDER BY p.birthday DESC
    LIMIT 10) AS nol;

-- 4. Определить кто больше поставил лайков (всего) - мужчины или женщины?
SHOW TABLES FROM vk;
SELECT * FROM likes LIMIT 10;
SELECT * FROM profiles LIMIT 10;

-- Определим количество лайков, поставленных представителями разных полов
SELECT p.sex, COUNT(*) AS number_of_likes
	FROM profiles p
    JOIN likes l
		ON p.user_id = l.user_id
	GROUP BY p.sex;
    
-- Выведем агрегированный ответ
SELECT IF(
	(SELECT COUNT(*) AS number_of_likes
		FROM profiles p
		JOIN likes l
			ON p.user_id = l.user_id
		WHERE p.sex = 'm')
    >
    (SELECT COUNT(*) AS number_of_likes
		FROM profiles p
		JOIN likes l
			ON p.user_id = l.user_id
		WHERE p.sex = 'f')
    ,'Male', 'Female') AS 'Who likes more';
 
-- 5. Найти 10 пользователей, которые проявляют наименьшую активность в использовании 
-- социальной сети.
SHOW TABLES FROM vk;
SELECT * FROM communities_users LIMIT 10;
SELECT * FROM friendship LIMIT 10;
SELECT * FROM likes LIMIT 10;
SELECT * FROM meetings_users LIMIT 10;
SELECT * FROM messages LIMIT 10;
SELECT * FROM posts LIMIT 10;

SELECT CONCAT(u.first_name, ' ', u.last_name, ', id = ', u.id) AS 'User',
			COUNT(DISTINCT communities_users.community_id) +
			COUNT(DISTINCT likes.id) +
            COUNT(DISTINCT friendship.friend_id) +
            COUNT(DISTINCT meetings_users.meeting_id) +
            COUNT(DISTINCT messages.id) +
            COUNT(DISTINCT posts.id)
            AS activity
	FROM users u
		LEFT JOIN communities_users
			ON communities_users.user_id = u.id
		LEFT JOIN likes
			ON likes.user_id = u.id
		LEFT JOIN friendship
			ON friendship.user_id = u.id
		LEFT JOIN meetings_users
			ON meetings_users.user_id = u.id
		LEFT JOIN messages
			ON messages.from_user_id = u.id
		LEFT JOIN posts
			ON posts.user_id = u.id	
    GROUP BY u.id
    ORDER BY activity
    LIMIT 10
    ;
