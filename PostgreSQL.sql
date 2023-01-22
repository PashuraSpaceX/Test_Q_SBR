--Топ-3 самых молодых сотрудников:
--Изначальный запрос может выглядеть так:

SELECT name 
FROM test
ORDER BY age
LIMIT 3;

--Добавлю проверку на NULL и ASC для поднятия по возрастанию (ORDER BY и так изначально по возрастанию):

SELECT name 
FROM test
WHERE name IS NOT NULL AND
age IS NOT NULL
ORDER BY age ASC
LIMIT 3;


-- Задание: нужно для каждого дня определить последнее местоположение абонента

create table abonents (
abonent BIGSERIAL, 
region INT,
dttm TIMESTAMP
);

insert into abonents(abonent,region,dttm) VALUES 
(7072110988, 32722, '2021-08-18 13:15'),
(7072110988, 32722, '2021-08-18 14:00'),
(7072110988, 21534, '2021-08-18 14:15'),
(7072110988, 32722, '2021-08-19 09:00'),
(7071107101, 12533, '2021-08-19 09:15'),
(7071107101, 32722, '2021-08-19 09:27');

SELECT abonents.abonent ,region,dttm FROM abonents
JOIN (
  SELECT abonent, MAX(CAST(dttm as date)) as date,MAX(cast(dttm as time)) as time
  FROM abonents
  GROUP BY abonent, CAST(dttm as date)
  ) AS a2 
  on abonents.abonent = a2.abonent
  and CAST(abonents.dttm as date)  = a2.date 
  AND CAST(abonents.dttm as time) = a2.time
ORDER BY abonent DESC;

--Задание: необходимо сформировать таблицу следующего вида dict_item_prices.

(SELECT 
item_prices.item_id, 
item_name,
item_price, 
temp2.dttm AS startDate, 
NULL As endDate 
FROM item_prices
 JOIN (SELECT 
item_id,
MAX(created_dttm) as dttm
FROM item_prices
GROUP BY item_id) As temp2 on item_prices.item_id =  temp2.item_id AND temp2.dttm = item_prices.created_dttm)


UNION 

(SELECT 
item_prices.item_id,
item_prices.item_name,
item_prices.item_price, 
item_prices.created_dttm As startDate,

t2.created_dttm As endDate
FROM item_prices
FULL Join (
  SELECT item_id,item_name, item_price, created_dttm FROM item_prices 
) as t2 ON item_prices.item_id = t2.item_id
WHERE item_prices.created_dttm < t2.created_dttm) ORDER BY item_id, startDate

--Дальше используем метод рекурсивного (иерархического) запроса.
