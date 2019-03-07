--1. Простой запрос SELECT-FROM-WHERE к одной таблице – 1 запрос.    
--Вывести все характеристики компьютеров, стоящих больше 35000.
select characteristics from computer where cost > 35000;

--2. Простой запрос SELECT-FROM-WHERE к двум таблицам – 1 запрос.    
--Вывести все фирмы, которым принадлежит детектор дыма
select name from firm, Sells where firm.account_number=Sells.account_number and principle_of_operation='Smoke detector'

--3. Простой запрос SELECT-FROM-WHERE к трем таблицам – 1 запрос  
--Вывести имя сотрудника и его рабочий компьютер, для компании 'PolyTech'			
select employee.name, serial_number from computer, employee, firm where computer.name=employee.name and employee.account_number=firm.account_number and firm.name='PolyTech'
	
--4. Запрос к одной таблице, умноженной на себя – 1 запрос 
--Вывести сенсоры и диапазон действия для тех устройств, у которых он одинаков.
Select DISTINCT A1.Sensor_name, A2.Sensor_name, A1.action_range FROM security_sensors A1, security_sensors A2 WHERE A1.action_range = A2.action_range and A1.Sensor_name!= A2.Sensor_name;

--5. Запросы с подзапросами.
--Использующие 2 таблицы - 2 запроса  
Вывести специальности и их зарплаты в компании PolyTech.
Select specialty, salary from employee where employee.account_number=(select firm.account_number from firm where firm.name='PolyTech')

--Вывести имя и адрес сотрудника, работающего под руководством Nikolay Beresnev.
Select employee.name, employee.adress from employee where employee.account_number=(Select firm.account_number from firm where director='Nikolay Beresnev')

--Использующие 3 таблицы - 2 запроса.
--Вывести имя покупателя и его дату рождения для фирмы 'Abright'
select buyer.name, d_o_b from buyer where passport_data=(select Buys.passport_data from Buys where Buys.account_number=(select firm.account_number from firm where firm.name=' Abright'))			

--Вывести имена и профессии покупателей 'Radio wave
Select buyer.name, profession from buyer where buyer.passport_data=(select Buys.passport_data from Buys where Buys.account_number=(select Sells.account_number from Sells where principle_of_operation ='Radio wave'))

--Каждый из запросов выполняется дважды используя слово из (EXISTS, IN) и/или из (ALL,
--ANY). Все слова должны быть в запросах использованы – 4 запроса. Каждый запрос сделайте
--дважды, используя (EXISTS, IN), используя (ALL, ANY).
--Запросы с использование пары (EXISTS, IN)
--Вывести регистрационные номера фирм, у которых покупатели бизнесмены.
Select account_number from Buys where Buys.passport_data IN (Select passport_data from buyer where profession='businessman')

Select account_number from Buys where exists (Select * from buyer where profession='businessman' and Buys.passport_data=buyer. passport_data)
	
--Запросы с использование пары (ALL, ANY)
--Найти названия, стоимость и принцип работы сенсоров, которые пока то не принадлежат ни одной фирме.
Select Sensor_name, cost, security_sensors.principle_of_operation from security_sensors where security_sensors.principle_of_operation <>ALL(select Sells.principle_of_operation from Sells)
Select Sensor_name, cost, security_sensors.principle_of_operation from security_sensors where not security_sensors.principle_of_operation =ANY(select Sells.principle_of_operation from Sells)

--6. Запросы теории множеств UNION, INTERSECT, EXCEPT(MINUS) – 3 запроса
--Запрос с использованием INTERSECT
--Вывести номера аккаунтов, у которых есть и покупатели и сотрудники.
select account_number from Buys INTERSECT select account_number from Sells

--Запрос с использованием EXCEPT(MINUS)
--Вывести названия сенсоров, которые не реализуются фирмами.
select principle_of_operation from security_sensors minus select principle_of_operation from Sells

--Запрос с использованием UNION
--Вывести все профессии, задействованные в базе данных
select profession from buyer union select specialty profession from employee

--7. Пользовательское представление из 3 таблиц. 1 запрос к представлению – 1 запрос.
--Создать пользовательское представление, где связаны данные логина пользователя,
--принадлежащее ему место в хранилище и компания, сотрудником которой он является
CREATE VIEW Buyer_Sensor AS (Select buyer.name Buyer, security_sensors.principle_of_operation Sensor, cost 
FROM security_sensors, buyer, Buys, Sells
WHERE Sells.account_number=Buys.account_number and security_sensors.principle_of_operation=Sells.principle_of_operation and buyer.passport_data=Buys.passport_data)
--Вывести всю информацию о клиентах, сенсоры которых стоят больше 1000
Select * from Buyer_Sensor where cost >1000

--8. Внешние и внутренние соединения (JOIN ON, CROSS JOIN, NATURAL OUTER
--JOIN,OUTER , NATURAL LEFT OUTER, NATURAL RIGHT OUTER ) – 6 запросов
--Запрос с использованием JOIN ON.
--Вывести названия фирм, которым принадлежит Tilt sensor
select name from firm JOIN Sells ON firm.account_number=Sells.account_number where principle_of_operation= 'Tilt sensor'

--Запрос с использованием CROSS JOIN.
--Вывести имена и профессии сотрудников, зарплаты которых не хватит на покупку их рабочего компьютера.
select employee.name,specialty, salary His_sal, cost Cost_of_comp from employee CROSS JOIN computer where employee.name=computer.name and salary<cost

--Запрос с использованием NATURAL JOIN.
--Вывести имена и номера покупателей, являющихся клиентами и фирм и работающих турагентами.
Select name, account_number from Buys NATURAL JOIN buyer where profession='travel agent'

--Запрос с использованием FULL OUTER JOIN.
--Вывести паспорта покупателей и приобретенные ими сенсоры.
Select passport_data, principle_of_operation from Buys FULL JOIN Sells ON Sells.account_number=Buys.account_number
	
--Запрос с использованием RIGHT OUTER JOIN.
--Вывести номера аккаунтов фирм и названия распространяемых ими сенсоров.
Select DISTINCT Sells.account_number,Sensor_name from Sells RIGHT JOIN security_sensors ON security_sensors.principle_of_operation=Sells.principle_of_operation

--Запрос с использованием LEFT OUTER JOIN.
--Вывести номера кабинетов, их площадь и серийные номера стоящих там компьютеров, для кабинетов больших 70 кв.м.
Select cabinet.number_cab, space, serial_number from cabinet LEFT JOIN computer ON computer.number_cab=cabinet.number_cab where space>70

--9. Агрегация (SUM,COUNT,AVG,MIN,MAX) – 1 запрос.
--Запрос с использованием AVG.
--Вывести имя и зарплату наиболее высокооплачиваемого сотрудника.
SELECT name, salary FROM employee WHERE salary=(SELECT MAX(salary) FROM employee)

--10. Агрегация и GROUP BY - 1 запрос.
--Вывести все открытые компании и число их сотрудников.
Select firm.name, COUNT(employee.name) FROM firm,employee where employee.account_number=firm.account_number GROUP BY firm.name;

--11. Агрегация, GROUP BY, HAVING - 1 запрос.
--Подсчитать число специалистов, возраст которых больше сорока.
SELECT specialty, Count(specialty) FROM employee GROUP BY specialty HAVING MIN(d_o_b)<'01-01-1979'

--12. Коррелированный запрос – 2 запроса разного типа.
--Найти сотрудников, работающих в фирме Армо-Системс.
SELECT employee.name FROM employee WHERE EXISTS( SELECT * FROM firm WHERE firm.account_number=employee.account_number AND firm.name='ARMO-Systems')

--Найти серийные номера компьютеров, находящихся в одном кабинете.
Select DISTINCT A1.serial_number, A1.number_cab FROM computer A1 WHERE number_cab IN (Select A2.number_cab FROM computer A2 WHERE A1.serial_number<>A2.serial_number)

