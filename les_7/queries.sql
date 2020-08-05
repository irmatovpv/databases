Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.
select * from users where id in (select distinct user_id from orders);


Выведите список товаров products и разделов catalogs, который соответствует товару.
select p.*, c.* from products as p JOIN catalogs as c ON p.catalog_id= c.id;


Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). Поля from, to и label содержат английские названия городов, поле name — русское. Выведите список рейсов flights с русскими названиями городов.
select f.id, c1.name as fro, c2.name from flights as f left join cities c1 ON (f.from = c1.label) LEFT JOIN cities c2 ON (f.to = c2.label);



