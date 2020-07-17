#!/bin/bash
echo """
[mysql]
user=root
password=my8sql
""" > ~/.my.cnf
chmod 0600 .my.cnf
mysql -e"CREATE DATABASE example CHARACTER SET utf8 COLLATE utf8_general_ci;"
mysql example -e"CREATE TABLE users (id INT UNSIGNED, name VARCHAR(255));"
mysqldump -uroot -p example > dump.sql
mysql -e"CREATE DATABASE sample CHARACTER SET utf8 COLLATE utf8_general_ci;"
mysql sample < dump.sql


mysqldump -uroot -p mysql help_keyword --where="1 order by help_keyword_id limit 100" >dump-keyword.sql