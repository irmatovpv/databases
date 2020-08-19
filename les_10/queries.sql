/*1. Проанализировать какие запросы могут выполняться наиболее
часто в процессе работы приложения и добавить необходимые индексы.*/

CREATE INDEX media_user_id_media_type_id_idx ON media (user_id, media_type_id);  

-- Для друзей
CREATE INDEX friendship_user_idx ON friendship (user_id);
CREATE INDEX friendship_friend__idx ON friendship (friend_id);

-- Лайки
CREATE INDEX likes_idx ON likes (user_id, target_id, like_type_id);

-- Сообщения, дата создания нужна для сортировки
CREATE INDEX messages_from_idx ON messages (from_user_id, to_user_id, created_at);
CREATE INDEX messages_to_idx ON messages (to_user_id, from_user_id, created_at);

-- Больше индексов я бы лично создавать не стал. Дальше нужно следить за развитием БД. И добавлять инексы от размера данных и частоты конкретных запросов.
-- По идее на сообщения нужен полнотекстовый индекс на боди, но я бы лично вынес эту функции в отдельную БД, типа SOLR или ElasticSearch

/*2. Задание на оконные функции
Построить запрос, который будет выводить следующие столбцы:
имя группы
среднее количество пользователей в группах
самый молодой пользователь в группе
самый старший пользователь в группе
общее количество пользователей в группе
всего пользователей в системе
отношение в процентах (общее количество пользователей в группе / всего пользователей в системе) * 100*/
SELECT name,
	count, young, old,
	AVG(count) OVER() AS avg,
	SUM(count) OVER() AS total,
	SUM(count) OVER(PARTITION BY t.name) / SUM(count) OVER() * 100 AS "%"
FROM(
SELECT DISTINCT c.name as name,
    COUNT(cu.user_id) OVER(PARTITION BY cu.community_id) AS count,
    FIRST_VALUE(birthday) OVER(PARTITION BY cu.community_id ORDER BY birthday DESC) AS young,
    FIRST_VALUE(birthday) OVER(PARTITION BY cu.community_id ORDER BY birthday) AS old
   	FROM communities_users cu
 LEFT JOIN communities c
	    ON c.id = cu.community_id
	  JOIN profiles p
	    ON p.user_id = cu.user_id) t;
