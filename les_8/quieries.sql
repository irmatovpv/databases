select count(l.id) c, gender from likes l JOIN profiles p ON(p.user_id=l.user_id) group by gender ORDER BY c DESC limit 1;

select count(*) from likes join  (select user_id FROM (select user_id from profiles order by birthday DESC limit 10) as t) t ON (t.user_id = likes.target_id ) where likes.target_type_id=2;

Поставил наименьшее колличество лайков.
select u.id, count(l.id) c from users u LEFT JOIN likes l ON(u.id=l.user_id) group by u.id order by c limit 10;
