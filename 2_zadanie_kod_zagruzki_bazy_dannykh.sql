CREATE TABLE buyer (name varchar2(100), profession varchar2(50), 
passport_data int PRIMARY KEY, d_o_b DATE);
INSERT INTO buyer VALUES ('Kate', 'businessman', 651190, TO_DATE('15-03-1989','dd-mm-yyyy'));
INSERT INTO buyer VALUES ('Aleksandr', 'developer',121666, TO_DATE('04-11-1995','dd-mm-yyyy'));
INSERT INTO buyer VALUES ('Julia', 'freelancer',369888, TO_DATE('14-07-1990','dd-mm-yyyy'));
INSERT INTO buyer VALUES ('Peter', 'doctor',851236, TO_DATE('01-03-1986','dd-mm-yyyy'));
INSERT INTO buyer VALUES ('Michael', 'contractor',260862, TO_DATE('18-03-1981','dd-mm-yyyy'));
INSERT INTO buyer VALUES ('Daniel', 'lawyer',158168, TO_DATE('20-02-1970','dd-mm-yyyy'));
INSERT INTO buyer VALUES ('Nikita', 'householder',159685, TO_DATE('27-09-1991','dd-mm-yyyy'));
INSERT INTO buyer VALUES ('Maria', 'air controller',208623, TO_DATE('20-10-1994','dd-mm-yyyy'));
INSERT INTO buyer VALUES ('Vlad', 'travel agent',260308, TO_DATE('20-04-1986','dd-mm-yyyy'));
INSERT INTO buyer VALUES ('Artem', 'auto mechanic',960345, TO_DATE('14-02-1988','dd-mm-yyyy'));

CREATE TABLE firm (capital int, director varchar2(100), name varchar2(100) , 
adress varchar2(100), account_number int PRIMARY KEY);
INSERT INTO firm VALUES (10000000, 'Gennady Gorin','ARMO-Systems', 'Moscow, st. Dvintsev, 12', 1412001);
INSERT INTO firm VALUES (70000000, 'Rugulin Dmitry ','Layta', 'Moscow, Zemlyanoy Val Street 64', 1412011);
INSERT INTO firm VALUES (13000000, 'Vasiliy Petin', 'PolyTech', 'Yekaterinburg, Yasnaya Str., 32', 1412045);
INSERT INTO firm VALUES (12000000, 'Igor Nevsky','TD "Leader-SB"', 'Moscow, Izmaylovskoye sh., 28', 1412068);
INSERT INTO firm VALUES (7800000, ' Vitaiy Shestakov','AVC', 'Moscow, Profsoyuznaya, 93', 1412091);
INSERT INTO firm VALUES (40000000, 'Dmitry Losin','Comtrol System', 'St. Petersburg, obruiskaya St., 5', 1412044);
INSERT INTO firm VALUES (18000000, 'Nikolay Beresnev','Alliance-Inter', 'Moscow, Yaroslavskaya ul., 15', 1412087);
INSERT INTO firm VALUES (21000000, 'Ivan Petrov','WISOL', 'Sankt-Peterburg, Serebristyy b-r, 21', 1412029);
INSERT INTO firm VALUES (16000000, 'Semon Tirsky','iQ Comfort', 'Sankt-Peterburg ,Leninskiy pr., 140', 1412031);
INSERT INTO firm VALUES (78000000, 'Ivan Selikov',' Abright', 'Moscow, Lenin Prospect Lenina, 6', 1412099);

CREATE TABLE cabinet (space int, number_cab int PRIMARY KEY, 
number_of_computers int);
INSERT INTO cabinet VALUES (20, 1, 2);
INSERT INTO cabinet VALUES (54, 2, 8);
INSERT INTO cabinet VALUES (254, 3, 35);
INSERT INTO cabinet VALUES (145, 4, 15);
INSERT INTO cabinet VALUES (73, 5, 9);
INSERT INTO cabinet VALUES (67, 6, 9);
INSERT INTO cabinet VALUES (135, 7, 14);
INSERT INTO cabinet VALUES (64, 8, 9);
INSERT INTO cabinet VALUES (87, 9, 10);
INSERT INTO cabinet VALUES (13, 10, 1);

CREATE TABLE security_sensors (Sensor_name varchar2(50), principle_of_operation varchar2(50) PRIMARY KEY, 
cost int, action_range int); 
INSERT INTO security_sensors VALUES ('Contact','Opening sensor', 4000, 1);
INSERT INTO security_sensors VALUES ('Movements','Infrared', 17000, 15);
INSERT INTO security_sensors VALUES ('Movements','Ultrasonic', 8000, 15);
INSERT INTO security_sensors VALUES ('Movements','Radio wave', 15000, 15);
INSERT INTO security_sensors VALUES ('Acoustic','Microphone', 1000, 10);
INSERT INTO security_sensors VALUES ('Vibrating','Tilt sensor', 1000, 1);
INSERT INTO security_sensors VALUES ('Vibrating','Glass break sensor', 3000, 3);
INSERT INTO security_sensors VALUES ('Vibrating','Capacitive sensor', 9000, 1);
INSERT INTO security_sensors VALUES ('Other','Beam sensor', 14000, 10);
INSERT INTO security_sensors VALUES ('Other','Smoke detector', 4000, 10);

CREATE TABLE employee (name varchar2(100) PRIMARY KEY, adress varchar2(100),  
salary int,  d_o_b DATE, specialty varchar2(100), 
account_number int REFERENCES firm(account_number));
INSERT INTO employee VALUES ('Solovyov Julius', 'Moscow, Sovetskaya Street, 84', 65000, TO_DATE('12-10-1989','dd-mm-yyyy'), 'Call-center operator', 1412001);
INSERT INTO employee VALUES ('Kulakov Kondrat', 'Moscow, Central Street, 80', 50000, TO_DATE('10-02-1970','dd-mm-yyyy'), 'Secretary-Referen', 1412001);
INSERT INTO employee VALUES ('Merkushev Leonard', 'Moscow, Sadovaya Street, 60', 60000, TO_DATE('01-04-1985','dd-mm-yyyy'), 'Tester', 1412045);
INSERT INTO employee VALUES ('Shcherbakov Cornelius', 'Moscow, Lesnaya st., 58', 45000, TO_DATE('05-12-1980','dd-mm-yyyy'), 'Accountant', 1412045);
INSERT INTO employee VALUES ('Kuzmin Donat', 'Moscow, Lenina st., 56', 39000, TO_DATE('14-02-1986','dd-mm-yyyy'), 'Copywriter', 1412045);
INSERT INTO employee VALUES ('Zhukov Zinoviy', 'Moscow, Oktyabrskaya st., 49', 48200, TO_DATE('10-08-1990','dd-mm-yyyy'), 'PR Manager', 1412031);
INSERT INTO employee VALUES ('Bobrov Klim', 'Moscow, Oktyabrskaya st., 50', 75600, TO_DATE('20-10-1960','dd-mm-yyyy'), 'Chief Engineer', 1412031);
INSERT INTO employee VALUES ('Moiseyev Trofim', 'Moscow, Zarechnaya St., 40', 62000, TO_DATE('10-03-1987','dd-mm-yyyy'), 'Sales Representative', 1412099);
INSERT INTO employee VALUES ('Vishnyakov Eric', 'Moscow, Gagarin St., 35', 50000, TO_DATE('10-03-1969','dd-mm-yyyy'), 'Web-programmer', 1412099);
INSERT INTO employee VALUES ('Lebedev Bronislav', 'Moscow, Meadow Street, 32', 32000, TO_DATE('06-03-1995','dd-mm-yyyy'), 'Cleaner', 1412087);

CREATE TABLE computer (cost int, serial_number int PRIMARY KEY, characteristics varchar2(50), 
number_cab int REFERENCES cabinet(number_cab), name varchar2(100) REFERENCES employee(name));
INSERT INTO computer VALUES (35000, 1915001, 'Intel core i5, Nvidia GeForse 970', 1, 'Solovyov Julius');
INSERT INTO computer VALUES (20000, 1915002, 'AMD A4, AMD Radeon R7', 1, 'Kulakov Kondrat');
INSERT INTO computer VALUES (37000, 1915003, 'Intel core i7, Nvidia GeForse 1050', 2, 'Merkushev Leonard');
INSERT INTO computer VALUES (22000, 1915004,'AMD A6, AMD Radeon R9', 2, 'Shcherbakov Cornelius');
INSERT INTO computer VALUES (27000, 1915005, 'AMD FX8300, AMD Radeon RX 550', 5, 'Kuzmin Donat');
INSERT INTO computer VALUES (31000, 1915006,'Intel core i3, AMD Radeon RX 560', 5, 'Zhukov Zinoviy');
INSERT INTO computer VALUES (30000, 1915007, 'AMD Ryzen 7, nvidia 930', 5, 'Bobrov Klim');
INSERT INTO computer VALUES (29000, 1915008, 'AMD Ryzen 5, Nvidia GeForse 480', 7, 'Moiseyev Trofim');
INSERT INTO computer VALUES (40000, 1915009, 'Intel core i7, Nvidia GeForse 2080', 7, 'Vishnyakov Eric');
INSERT INTO computer VALUES (39000, 1915010, 'Intel core i5, Nvidia GeForse 1080', 10, 'Lebedev Bronislav');

create table Buys (passport_data int REFERENCES buyer(passport_data), account_number int REFERENCES firm(account_number));
INSERT INTO Buys VALUES (651190, 1412001);
INSERT INTO Buys VALUES (651190, 1412011);
INSERT INTO Buys VALUES (651190, 1412045);
INSERT INTO Buys VALUES (121666, 1412068);
INSERT INTO Buys VALUES (369888, 1412068);
INSERT INTO Buys VALUES (851236, 1412068);
INSERT INTO Buys VALUES (260862, 1412087);
INSERT INTO Buys VALUES (158168, 1412087);
INSERT INTO Buys VALUES (260308, 1412031);
INSERT INTO Buys VALUES (260308, 1412099);

create table Sells (principle_of_operation varchar2(50) REFERENCES security_sensors(principle_of_operation), 
account_number int REFERENCES firm(account_number));
INSERT INTO Sells VALUES ('Opening sensor', 1412001);
INSERT INTO Sells VALUES ('Opening sensor', 1412011);
INSERT INTO Sells VALUES ('Tilt sensor', 1412045);
INSERT INTO Sells VALUES ('Tilt sensor', 1412068);
INSERT INTO Sells VALUES ('Glass break sensor', 1412044);
INSERT INTO Sells VALUES ('Capacitive sensor', 1412044);
INSERT INTO Sells VALUES ('Beam sensor', 1412044);
INSERT INTO Sells VALUES ('Radio wave', 1412099);
INSERT INTO Sells VALUES ('Smoke detector', 1412099);
INSERT INTO Sells VALUES ('Microphone', 1412099);
