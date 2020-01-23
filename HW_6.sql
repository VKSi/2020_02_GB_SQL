-- Практическое задание по теме “Операторы, фильтрация, сортировка и ограничение. 
-- Агрегация данных”

-- Работаем с БД vk и тестовыми данными, которые вы сгенерировали ранее:

-- 1. Проанализировать запросы, которые выполнялись на занятии, определить возможные 
-- корректировки и/или улучшения (JOIN пока не применять).

-- 2. Пусть задан некоторый пользователь. 
-- Из всех друзей этого пользователя найдите человека, который больше всех общался 
-- с нашим пользователем.

-- Посмотрим, какая таблица отвечает за общение и что в ней находится
USE vk;

SHOW TABLES FROM vk;
DESCRIBE messages;
SELECT * FROM friendship LIMIT 10;
SELECT * FROM friendship_statuses LIMIT 10;

-- Составим предварительные запросы количества сообщений "от" и "к" выделенному (90) пользователю
SELECT COUNT(*),
		to_user_id
    FROM messages
    WHERE from_user_id = 57
    GROUP BY to_user_id;
    
SELECT COUNT(*),
		from_user_id
    FROM messages
    WHERE to_user_id = 57
    GROUP BY from_user_id;



-- Выделим только друзей пользователя
 SELECT COUNT(*),
		to_user_id
    FROM messages AS m
    WHERE from_user_id = 57 AND EXISTS
		(SELECT 1
			FROM friendship AS f
            WHERE (
					(f.user_id = m.from_user_id) AND
					(f.friend_id =  m.to_user_id) AND
                    (f.status_id = (SELECT id
									FROM friendship_statuses
                                    WHERE name = 'Confirmed'))
					OR
                    (f.friend_id = m.from_user_id) AND
					(f.user_id =  m.to_user_id) AND
                    (f.status_id = (SELECT id
									FROM friendship_statuses
                                    WHERE name = 'Confirmed'))
					)
        )
    GROUP BY to_user_id;

SELECT COUNT(*),
		from_user_id
    FROM messages AS m
    WHERE to_user_id = 57 AND EXISTS
		(SELECT 1
			FROM friendship AS f
            WHERE (
					(f.user_id = m.from_user_id) AND
					(f.friend_id =  m.to_user_id) AND
                    (f.status_id = (SELECT id
									FROM friendship_statuses
                                    WHERE name = 'Confirmed'))
					OR
                    (f.friend_id = m.from_user_id) AND
					(f.user_id =  m.to_user_id) AND
                    (f.status_id = (SELECT id
									FROM friendship_statuses
                                    WHERE name = 'Confirmed'))
					)
        )
    GROUP BY from_user_id;    

    
-- Объединяем запросы
 SELECT COUNT(*),
		to_user_id
    FROM messages AS m
    WHERE from_user_id = 57 AND EXISTS
		(SELECT 1
			FROM friendship AS f
            WHERE (
					(f.user_id = m.from_user_id) AND
					(f.friend_id =  m.to_user_id) AND
                    (f.status_id = (SELECT id
									FROM friendship_statuses
                                    WHERE name = 'Confirmed'))
					OR
                    (f.friend_id = m.from_user_id) AND
					(f.user_id =  m.to_user_id) AND
                    (f.status_id = (SELECT id
									FROM friendship_statuses
                                    WHERE name = 'Confirmed'))
					)
        )
    GROUP BY to_user_id
UNION   
SELECT COUNT(*),
		from_user_id
    FROM messages AS m
    WHERE to_user_id = 57 AND EXISTS
		(SELECT 1
			FROM friendship AS f
            WHERE (
					(f.user_id = m.from_user_id) AND
					(f.friend_id =  m.to_user_id) AND
                    (f.status_id = (SELECT id
									FROM friendship_statuses
                                    WHERE name = 'Confirmed'))
					OR
                    (f.friend_id = m.from_user_id) AND
					(f.user_id =  m.to_user_id) AND
                    (f.status_id = (SELECT id
									FROM friendship_statuses
                                    WHERE name = 'Confirmed'))
					)
        )
    GROUP BY from_user_id;
    
-- Группируем, сортируем, выбираем единственного (в случае, если есть пользователи с равным количеством сообщений, выберется произвольный)
 ((SELECT COUNT(*) AS activity,
		to_user_id AS partner
    FROM messages AS m
    WHERE from_user_id = 57 AND EXISTS
		(SELECT 1
			FROM friendship AS f
            WHERE (
					(f.user_id = m.from_user_id) AND
					(f.friend_id =  m.to_user_id) AND
                    (f.status_id = (SELECT id
									FROM friendship_statuses
                                    WHERE name = 'Confirmed'))
					OR
                    (f.friend_id = m.from_user_id) AND
					(f.user_id =  m.to_user_id) AND
                    (f.status_id = (SELECT id
									FROM friendship_statuses
                                    WHERE name = 'Confirmed'))
					)
        )
    GROUP BY partner)
UNION   
(SELECT COUNT(*) AS activity,
		from_user_id AS partner
    FROM messages AS m
    WHERE to_user_id = 57 AND EXISTS
		(SELECT 1
			FROM friendship AS f
            WHERE (
					(f.user_id = m.from_user_id) AND
					(f.friend_id =  m.to_user_id) AND
                    (f.status_id = (SELECT id
									FROM friendship_statuses
                                    WHERE name = 'Confirmed'))
					OR
                    (f.friend_id = m.from_user_id) AND
					(f.user_id =  m.to_user_id) AND
                    (f.status_id = (SELECT id
									FROM friendship_statuses
                                    WHERE name = 'Confirmed'))
					)
        )
    GROUP BY partner)
)
ORDER BY activity DESC
LIMIT 1;

SELECT * FROM users LIMIT 10;

-- Определяем его имя, фамилию и id
SELECT CONCAT(first_name, ' ', last_name, ', id = ', id) AS 'The best friend'
	FROM users
    WHERE id IN (SELECT partner FROM (
			 ((SELECT COUNT(*) AS activity,
					to_user_id AS partner
					FROM messages AS m
					WHERE from_user_id = 57 AND EXISTS
						(SELECT 1
							FROM friendship AS f
							WHERE (
									(f.user_id = m.from_user_id) AND
									(f.friend_id =  m.to_user_id) AND
									(f.status_id = (SELECT id
													FROM friendship_statuses
													WHERE name = 'Confirmed'))
									OR
									(f.friend_id = m.from_user_id) AND
									(f.user_id =  m.to_user_id) AND
									(f.status_id = (SELECT id
													FROM friendship_statuses
													WHERE name = 'Confirmed'))
									)
							)
					GROUP BY partner)
				UNION   
				(SELECT COUNT(*) AS activity,
						from_user_id AS partner
						FROM messages AS m
						WHERE to_user_id = 57 AND EXISTS
							(SELECT 1
								FROM friendship AS f
								WHERE (
										(f.user_id = m.from_user_id) AND
										(f.friend_id =  m.to_user_id) AND
										(f.status_id = (SELECT id
														FROM friendship_statuses
														WHERE name = 'Confirmed'))
										OR
										(f.friend_id = m.from_user_id) AND
										(f.user_id =  m.to_user_id) AND
										(f.status_id = (SELECT id
														FROM friendship_statuses
														WHERE name = 'Confirmed'))
										)
							)
						GROUP BY partner)
					)
			ORDER BY activity DESC
			LIMIT 1 ) AS selection
	);
    
-- 3. Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей.
SHOW TABLES FROM vk;
SELECT * FROM likes LIMIT 10;
SELECT * FROM target_types LIMIT 10;
SELECT * FROM profiles LIMIT 10; 

-- 1) Нужно выбрать из таблицы likes только записи, target_type_id которых равен users.
-- Тогда target_id будет соответствовать id получателя лайка (из таблицы profiles). 
-- 2) Группируем по target_id и считаем количество лайков
-- 3) По таблице profiles считаем возраст пользователей, сортируем по возрастанию, выбираем первых 10
-- На шаге 3 выбирать года не обязательно, так как нам сам возраст не нужен
-- 4) Вкладываем таблицу, полученноую на шаге 3) в виде условия отбора id для запроса 1)2)

-- Выполняем шаги 1) и 2)
SELECT COUNT(*), target_id
	FROM likes
    WHERE target_type_id = (SELECT id FROM target_types WHERE name = 'users')
    GROUP BY target_id
    LIMIT 10;

-- Выполняем шаг 3)
SELECT user_id
	FROM profiles
    ORDER BY (NOW() - birthday)
    LIMIT 10;

-- Выполняем шаг 4)    
SELECT target_id AS 'Like\'s reciever', COUNT(*) AS 'Number of likes' 
	FROM likes
    WHERE target_type_id = (SELECT id FROM target_types WHERE name = 'users')
		AND target_id IN (SELECT * FROM
			(SELECT user_id
				FROM profiles
				ORDER BY (NOW() - birthday)
				LIMIT 10) AS youngest)
    GROUP BY target_id;

-- 4. Определить кто больше поставил лайков (всего) - мужчины или женщины?
SHOW TABLES FROM vk;
SELECT * FROM likes LIMIT 10;
SELECT * FROM profiles LIMIT 10;

-- 1) Определяем количество лайков, группируем по пользователям
SELECT user_id, COUNT(*)
	FROM likes
    GROUP BY user_id
    LIMIT 10;
    
-- 2) Добавляем условие на пол (пол в таблице profiles hfdty 'm') и обеспечиваем суммирование

SELECT SUM(likes_num) AS m_likes
	FROM (
		SELECT user_id, COUNT(*) AS likes_num
			FROM likes
			WHERE user_id IN (
				SELECT * FROM (
					SELECT user_id
						FROM profiles
						WHERE sex = 'm'
					) AS men)
			GROUP BY user_id
		) AS men_likes;

-- 3) Сравниваем запросы для sex = 'm' и sex='f' и выводим соответствующий ответ
SELECT IF(
	(SELECT SUM(likes_num) AS m_likes
		FROM (
			SELECT user_id, COUNT(*) AS likes_num
				FROM likes
				WHERE user_id IN (
					SELECT * FROM (
						SELECT user_id
							FROM profiles
							WHERE sex = 'm'
						) AS men)
				GROUP BY user_id
			) AS men_likes)
	> 
    	(SELECT SUM(likes_num) AS f_likes
		FROM (
			SELECT user_id, COUNT(*) AS likes_num
				FROM likes
				WHERE user_id IN (
					SELECT * FROM (
						SELECT user_id
							FROM profiles
							WHERE sex = 'f'
						) AS women)
				GROUP BY user_id
			) AS women_likes)
    ,'Male', 'Female') AS 'Who has more likes';
 
-- 5. Найти 10 пользователей, которые проявляют наименьшую активность в использовании 
-- социальной сети.
SHOW TABLES FROM vk;
SELECT * FROM communities_users LIMIT 10;
SELECT * FROM friendship LIMIT 10;
SELECT * FROM likes LIMIT 10;
SELECT * FROM meetings_users LIMIT 10;
SELECT * FROM messages LIMIT 10;
SELECT * FROM posts LIMIT 10;

-- Определяем активность пользователя по каждой таблице, объединяем, сортируем, лимитируем
SELECT active_user, SUM(activity) AS total_activity FROM (
	(SELECT user_id AS active_user,
			COUNT(*) AS activity
			FROM communities_users
			GROUP BY active_user)
	UNION ALL
		(SELECT user_id AS active_user,
			COUNT(*) AS activity
			FROM friendship
			GROUP BY active_user)
	UNION ALL
    	(SELECT user_id AS active_user,
			COUNT(*) AS activity
			FROM likes
			GROUP BY active_user)
	UNION ALL
	(SELECT user_id AS active_user,
			COUNT(*) AS activity
			FROM meetings_users
			GROUP BY active_user)
	UNION ALL
    (SELECT from_user_id AS active_user,
			COUNT(*) AS activity
			FROM messages
			GROUP BY active_user)
	UNION ALL
	(SELECT to_user_id AS active_user,
			COUNT(*) AS activity
			FROM messages
			GROUP BY active_user)
	UNION ALL
    (SELECT user_id AS active_user,
			COUNT(*) AS activity
			FROM posts
			GROUP BY active_user)
	) AS union_select
GROUP BY active_user
ORDER BY total_activity
LIMIT 10;
