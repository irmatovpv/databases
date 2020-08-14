-- В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.

START TRANSACTION;
INSERT INTO sample.users SELECT * FROM shop.users WHERE id=1;
COMMIT;

--Создайте представление, которое выводит название name товарной позиции из таблицы products и соответствующее название каталога name из таблицы catalogs.

CREATE VIEW products_descriptive (id,product_name,catalog_name) AS 
select p.id, p.name product_name, c.name catalog_name 
FROM products as p 
JOIN catalogs as c ON (p.catalog_id=c.id);

-- Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток. 
-- 06:00 до 12:00 функция должна возвращать фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".

DROP PROCEDURE IF EXISTS hello;
delimiter //
CREATE PROCEDURE hello()
BEGIN
 CASE
  WHEN CURTIME() BETWEEN '06:00:00' AND '12:00:00' THEN
   SELECT 'Доброе утро';
  WHEN CURTIME() BETWEEN '12:00:00' AND '18:00:00' THEN
   SELECT 'Добрый день';
  WHEN CURTIME() BETWEEN '18:00:00' AND '00:00:00' THEN
   SELECT 'Добрый вечер';
  ELSE
   SELECT 'Доброй ночи';
  END CASE;
END //
delimiter ;

CALL hello();

-- В таблице products есть два текстовых поля: name с названием товара и description с его описанием. Допустимо присутствие обоих полей или одно из них. 
-- Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема. Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. 
-- При попытке присвоить полям NULL-значение необходимо отменить операцию.

DROP TRIGGER IF EXISTS nt;
delimiter //
CREATE TRIGGER nt BEFORE INSERT ON products
FOR EACH ROW
BEGIN
  IF(ISNULL(NEW.name) AND ISNULL(NEW.description)) THEN
   SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'name and description is null';
  END IF;
END //
delimiter ;
