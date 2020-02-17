-- 1. Проанализировать какие запросы могут выполняться наиболее часто в процессе работы приложения и добавить необходимые индексы.
-- --------------------------------------------------------------------------------------------------------------------------------
USE vk;
SHOW TABLES FROM vk;
DESC meetings_users;

-- Индексы, созданные на занятии
CREATE INDEX profiles_birthday_idx ON profiles(birthday);
CREATE UNIQUE INDEX users_email_uq ON users(email);
CREATE INDEX media_user_id_media_type_id_idx ON media(user_id, media_type_id);

-- Индексы, созданные в рамках дмашнего задания
CREATE INDEX friendship_user_id_friend_id_idx ON friendship(user_id, friend_id);
CREATE INDEX messages_from_user_id_to_user_id_idx ON messages(from_user_id, to_user_id);
CREATE INDEX likes_user_id_target_id_idx ON likes(user_id, target_id);

-- --------------------------------------------------------------------------------------------------------------------------------
-- 2. Задание на оконные функции
-- Построить запрос, который будет выводить следующие столбцы:
-- - имя группы
-- - среднее количество пользователей в группах
-- - самый молодой пользователь в группе
-- - самый пожилой пользователь в группе
-- - общее количество пользователей в группе
-- - всего пользователей в системе
-- - отношение в процентах (общее количество пользователей в группе / всего пользователей в системе) * 100
-- --------------------------------------------------------------------------------------------------------------------------------
SELECT * FROM communities_users LIMIT 10;
SELECT * FROM communities LIMIT 25;
SELECT * FROM profiles LIMIT 10;
SELECT * FROM users LIMIT 10;

INSERT INTO communities (name) VALUE ('empty_group');

SELECT DISTINCT c.name as Community_name,
    COUNT(cu.user_id) OVER() / (SELECT COUNT(*) FROM communities) AS 'Total average number of users',
    FIRST_VALUE(p.birthday) OVER birthday_desc AS 'The youngest',
    FIRST_VALUE(u.first_name) OVER birthday_desc AS "The youngest's name",
    FIRST_VALUE(u.last_name) OVER birthday_desc AS "The youngest's surname",
    FIRST_VALUE(p.birthday) OVER birthday_asc AS 'The oldest',
    FIRST_VALUE(u.first_name) OVER birthday_asc AS "The oldest's name",
    FIRST_VALUE(u.last_name) OVER birthday_asc AS "The oldest's surname",
    COUNT(p.user_id) OVER w_communities AS 'Number of users in the group',
    (SELECT COUNT(*) FROM profiles) AS 'Total number of users',
    COUNT(p.user_id) OVER w_communities / (SELECT COUNT(*) FROM profiles) * 100 AS '%%'
	FROM communities c 
		LEFT JOIN communities_users cu
			ON c.id = cu.community_id
		LEFT JOIN profiles p
			ON p.user_id = cu.user_id
		LEFT JOIN users u
			ON u.id = cu.user_id
		WINDOW w_communities AS (PARTITION BY c.id),
				birthday_desc AS (PARTITION BY c.id ORDER BY p.birthday DESC),
				birthday_asc AS (PARTITION BY c.id ORDER BY p.birthday)
	;
-- --------------------------------------------------------------------------------------------------------------------------------