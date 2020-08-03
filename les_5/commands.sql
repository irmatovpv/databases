Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем
UPDATE users set created_at = NOW(), updated_at = NOW();

Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались значения в формате 20.10.2017 8:10. Необходимо преобразовать поля к типу DATETIME, сохранив введённые ранее значения.

ALTER TABLE users 
    CHANGE COLUMN `created_at` `created_at` VARCHAR(256) NULL,
    CHANGE COLUMN `updated_at` `updated_at` VARCHAR(256) NULL;
update users SET updated_at= DATE_FORMAT(STR_TO_DATE(updated_at, '%Y-%m-%d %H:%i:%s'), "%d.%m.%Y %H:%i"),  created_at= DATE_FORMAT(STR_TO_DATE(created_at, '%Y-%m-%d %H:%i:%s'), "%d.%m.%Y %H:%i");

update users SET updated_at= DATE_FORMAT(STR_TO_DATE(updated_at, "%d.%m.%Y %H:%i"), '%Y-%m-%d %H:%i:%s'),  created_at= DATE_FORMAT(STR_TO_DATE(created_at, "%d.%m.%Y %H:%i"), '%Y-%m-%d %H:%i:%s');

ALTER TABLE users 
    CHANGE COLUMN `created_at` `created_at` VARCHAR(256) NULL,
    CHANGE COLUMN `updated_at` `updated_at` VARCHAR(256) NULL;
    

В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 0, если товар закончился и выше нуля, если на складе имеются запасы. Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value. Однако нулевые запасы должны выводиться в конце, после всех записей.

INSERT INTO
    ->     storehouses_products (storehouse_id, product_id, value)
    -> VALUES
    ->     (1, 1, 15),
    ->     (1, 3, 0),
    ->     (1, 5, 10),
    ->     (1, 7, 5),
    ->     (1, 8, 0);

SELECT value FROM storehouses_products ORDER BY CASE WHEN value = 0 then 1 else 0 end, value;


Подсчитайте средний возраст пользователей в таблице users.
SELECT ROUND(AVG(TIMESTAMPDIFF(YEAR, birthday_at, NOW())), 0) AS age FROM users;


Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. Следует учесть, что необходимы дни недели текущего года, а не года рождения.
SELECT
    DAYNAME(CONCAT(YEAR(NOW()), '-', SUBSTRING(birthday_at, 6, 10))) AS day,
    COUNT(*) c
FROM
    users
GROUP BY day;
