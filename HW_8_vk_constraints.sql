USE vk;
SHOW TABLES;

-- Добавляем внешние ключи в БД vk
-- Для таблицы профилей

-- Смотрим структуру таблицы
DESC profiles;

-- Изменяем тип столбца при необходимости
ALTER TABLE profiles MODIFY COLUMN photo_id INT(10) UNSIGNED;

-- Добавляем внешние ключи
ALTER TABLE profiles
  ADD CONSTRAINT profiles_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT profiles_photo_id_fk
    FOREIGN KEY (photo_id) REFERENCES media(id)
      ON DELETE SET NULL;
    
-- Для таблицы сообщений

-- Смотрим структуру таблицы
DESC messages;

-- Добавляем внешние ключи
ALTER TABLE messages
  ADD CONSTRAINT messages_from_user_id_fk 
    FOREIGN KEY (from_user_id) REFERENCES users(id),
  ADD CONSTRAINT messages_to_user_id_fk 
    FOREIGN KEY (to_user_id) REFERENCES users(id);
    
-- Для таблицы медиа

-- Смотрим структуру таблицы
DESC media;

-- Так как в рассмотренном на занятии примере при удалении пользователя применялся CASCAD, сделаем здесь то же самое.
-- Но мне кажется, здесь этого лучше не делать. Информация дорога. Удалять юзеров и информацию по ним это расточительство
ALTER TABLE media MODIFY COLUMN user_id INT(10) UNSIGNED;

-- Добавляем внешние ключи
ALTER TABLE media
  ADD CONSTRAINT media_media_types_id_fk 
    FOREIGN KEY (media_type_id) REFERENCES media_types(id),
  ADD CONSTRAINT media_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE CASCADE;

-- Для таблицы связи комьюнити и пользователей

-- Смотрим структуру таблицы
DESC communities_users;

-- Добавляем внешние ключи
ALTER TABLE communities_users
  ADD CONSTRAINT communities_users_community_id_fk 
    FOREIGN KEY (community_id) REFERENCES communities(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT communities_users_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE CASCADE;     

-- Для таблицы дружбы

-- Смотрим структуру таблицы
DESC friendship;

-- Добавляем внешние ключи
ALTER TABLE friendship
  ADD CONSTRAINT friendship_status_id_fk 
    FOREIGN KEY (status_id) REFERENCES friendship_statuses(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT friendship_friend_id_fk
    FOREIGN KEY (friend_id) REFERENCES users(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT friendship_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE CASCADE;
     
-- Для таблицы постов

-- Смотрим структуру таблицы
DESC posts;

-- Добавляем внешние ключи
ALTER TABLE posts
  ADD CONSTRAINT posts_media_id_fk
    FOREIGN KEY (media_id) REFERENCES media(id)
      ON DELETE SET NULL,
  ADD CONSTRAINT posts_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE CASCADE;
     
-- Для таблицы связи встреч и пользователей

-- Смотрим структуру таблицы
DESC meetings_users;

-- Добавляем внешние ключи
ALTER TABLE meetings_users
  ADD CONSTRAINT meetings_users_community_id_fk 
    FOREIGN KEY (meeting_id) REFERENCES meetings(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT meetings_users_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE CASCADE;

-- Для таблицы лайков

-- Смотрим структуру таблицы
DESC likes;

-- Добавляем внешние ключи
ALTER TABLE likes
  ADD CONSTRAINT likes_target_type_id_fk 
    FOREIGN KEY (target_type_id) REFERENCES target_types(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT likes_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE CASCADE;
