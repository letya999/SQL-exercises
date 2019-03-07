CREATE TABLE Cloud (name varchar2(100) PRIMARY KEY, tech varchar2(50), type_с varchar2(100),
company varchar2(200));	
INSERT INTO Cloud VALUES ('Dropbox', 'PaaS', 'different', 'Dropbox Inc.');
INSERT INTO Cloud VALUES ('Mega', 'SaaS', 'private', 'Megaupload');
INSERT INTO Cloud VALUES ('Google Drive', 'SaaS', 'different', 'Google Inc.');
INSERT INTO Cloud VALUES ('Yandex.Drive', 'Saas', 'private', 'Yandex Inc.');
INSERT INTO Cloud VALUES ('NextCloud', 'laaS', 'operative', 'Nextcloud Gmbh.');
INSERT INTO Cloud VALUES ('OneDrive', 'SaaS', 'corporate', 'Microsoft');
INSERT INTO Cloud VALUES ('Cloud Mail.Ru', 'SaaS', 'private', 'Mail.Ru Group');
INSERT INTO Cloud VALUES ('Box', 'PaaS', 'private', 'Box.net Inc');
INSERT INTO Cloud VALUES ('ICloud', 'PaaS', 'different', 'Apple');
INSERT INTO Cloud VALUES ('Azure', 'laaS', 'operative', 'Microsoft');

CREATE TABLE Resource_center (director varchar2(100), city varchar2(30) PRIMARY KEY,
numb_nodes int, name varchar2(100) REFERENCES Cloud (name));
INSERT INTO Resource_center VALUES ('Rahuul Amrit','Delhi', 7, 'Dropbox');
INSERT INTO Resource_center VALUES ('Jan Becher','Praga', 11, 'Mega');
INSERT INTO Resource_center VALUES ('Nathan Malak','Amsterdam',  28, 'Google Drive');
INSERT INTO Resource_center VALUES ('Vlad Prykov','Mosсow',15, 'Yandex.Drive');
INSERT INTO Resource_center VALUES ('Sergey Khrustin','Saint-Petersburg',  13, 'NextCloud');
INSERT INTO Resource_center VALUES ('Hanz Lyahter','Berlin', 9, 'OneDrive');
INSERT INTO Resource_center VALUES ('Daniil Lovki', 'Kazan', 13, 'Cloud Mail.Ru');
INSERT INTO Resource_center VALUES ('David Richards','London',  6, 'Box');
INSERT INTO Resource_center VALUES ('John Leon','San Francisco',  22, 'ICloud');
INSERT INTO Resource_center VALUES ('Rick Sunches','New-York',  14, 'Azure');

CREATE TABLE Cluster_c (ID varchar2(20) PRIMARY KEY, city varchar2(30) REFERENCES Resource_center (city),
address varchar2(100), numb_servers int, life_time int);
INSERT INTO Cluster_c VALUES ('234.34.452', 'Praga','Ve Smeckach, 29',64 ,7);
INSERT INTO Cluster_c VALUES ('54.454.78', 'Praga','Ujezd, 22',79 ,2);
INSERT INTO Cluster_c VALUES ('784.41.346','Praga','Yanski vreshek., 8',164 ,7 );
INSERT INTO Cluster_c VALUES ('145.78.451', 'Saint-Petersburg','Ligovckiy pr-t, 64',127 , 5);
INSERT INTO Cluster_c VALUES ('132.456.21', 'Saint-Petersburg', 'Sadovaya, 123',63 , 4);
INSERT INTO Cluster_c VALUES ('678.245.73','Berlin', 'Unter-den-Linden, 22a',117 , 4);
INSERT INTO Cluster_c VALUES ('145.76.469', 'Berlin','Hose str, 123', 75 ,5 );
INSERT INTO Cluster_c VALUES ('64.314.15', 'London','Baker str, 22b', 58,6 );
INSERT INTO Cluster_c VALUES ('874.37.324', 'San Francisco','Staner str, 35',142 ,7 );
INSERT INTO Cluster_c VALUES ('13.947.642', 'New-York','Ager-roud, 184',81 ,5 );

CREATE TABLE Server (serial_numb int PRIMARY KEY, mem_size float, power_c int,
 ID_C varchar2(20) REFERENCES Cluster_c(ID));
INSERT INTO Server VALUES (84949498, 5.5, 15, '234.34.452');
INSERT INTO Server VALUES ( 94498498, 12.2, 22, '234.34.452');
INSERT INTO Server VALUES ( 49884998, 5.5, 15, '234.34.452');
INSERT INTO Server VALUES ( 68449844, 12.2, 22,'234.34.452' );
INSERT INTO Server VALUES ( 49466494, 16, 46, '678.245.73');
INSERT INTO Server VALUES ( 19814488, 16, 46,'678.245.73' );
INSERT INTO Server VALUES ( 28146498, 16, 46, '678.245.73');
INSERT INTO Server VALUES ( 94165549, 10, 34.6, '874.37.324');
INSERT INTO Server VALUES ( 28449488, 5.5, 15, '874.37.324');
INSERT INTO Server VALUES ( 21954544, 10, 34.6, '874.37.324');

CREATE TABLE Data_storage (cost int, space_c int PRIMARY KEY, available float,
city varchar2(30) REFERENCES Resource_center (city));
INSERT INTO Data_storage VALUES (0,8,4.5, 'Praga' );
INSERT INTO Data_storage VALUES (0.5,16,11.9, 'Praga');
INSERT INTO Data_storage VALUES (1.5,64,63.5, 'Praga');
INSERT INTO Data_storage VALUES (3,128,87.4, 'Berlin');
INSERT INTO Data_storage VALUES (10,1020,871.4, 'Berlin');
INSERT INTO Data_storage VALUES (0,20,12, 'Berlin');
INSERT INTO Data_storage VALUES (1.2,39,9.7, 'Saint-Petersburg');
INSERT INTO Data_storage VALUES (12,12000,6541.1, 'Saint-Petersburg' );
INSERT INTO Data_storage VALUES (6,500,16, 'New-York');
INSERT INTO Data_storage VALUES (4,400,328.65, 'New-York');

CREATE TABLE Calculation (client varchar2(50) PRIMARY KEY,
city varchar2(30) REFERENCES Resource_center (city), price float,
speed float, cosumption int);
INSERT INTO Calculation VALUES ('Parallels','Praga', 267.9,1.725,1055);
INSERT INTO Calculation VALUES ('Wrike','Praga',100,5.5,86765);
INSERT INTO Calculation VALUES ('Luxsoft','Praga',170.8,0.975,1462);
INSERT INTO Calculation VALUES ('Vcontacte','Berlin',790.4,0.147,585);
INSERT INTO Calculation VALUES ('Wargaming','Berlin',91.4,0.5,327);
INSERT INTO Calculation VALUES ('Avito','Berlin',1457.1,0.005,78);
INSERT INTO Calculation VALUES ('SberTech','Saint-Petersburg',782.14,3.1,64646);
INSERT INTO Calculation VALUES ('JetBrains','Saint-Petersburg',130.6,9.61,10757);
INSERT INTO Calculation VALUES ('SEMrush','New-York',125.66,4.8,44456);
INSERT INTO Calculation VALUES ('Epam','New-York',89.3,2.3,3534);

CREATE TABLE Account (login varchar2(50), password varchar2(20), subs varchar2(16),
d_o_b DATE, client varchar2(50) REFERENCES  Calculation (client),
space_c int REFERENCES Data_storage (space_c),PRIMARY KEY(login, password) );
INSERT INTO Account VALUES ('Bravo_22','d9wezg','Free', TO_DATE('15-06-1999','dd-mm-yyyy'), 'Wrike', 8);
INSERT INTO Account VALUES ('SPbSTU','EtD4yS','Corporate',TO_DATE('02-07-1982', 'dd-mm-yyyy'), 'Wrike', 16);
INSERT INTO Account VALUES ('bremya','wcbHtJ','Standard',TO_DATE('24-11-1976','dd-mm-yyyy'), 'Wrike', 64);
INSERT INTO Account VALUES ('rukiaa','SJM8uy','Default',TO_DATE('17-03-1993', 'dd-mm-yyyy'), 'Epam', 128);
INSERT INTO Account VALUES ('Nine_lit','sz3Sna','Private',TO_DATE('26-04-1991', 'dd-mm-yyyy'), 'JetBrains', 1020);
INSERT INTO Account VALUES ('berserk','EKsLo2','Free',TO_DATE('03-06-1995', 'dd-mm-yyyy'), 'Vcontacte', 20);
INSERT INTO Account VALUES ('Julia','eHIg2a','Protected',TO_DATE('05-09-1999','dd-mm-yyyy'), 'Vcontacte', 39);
INSERT INTO Account VALUES ('azimuth_vr','MQ4IR2','Corporate',TO_DATE('09-08-1998', 'dd-mm-yyyy'), 'SEMrush', 12000);
INSERT INTO Account VALUES ('Gloria-Melman','S2jvPH','Free',TO_DATE('07-02-2001', 'dd-mm-yyyy'), 'SEMrush', 12000);
INSERT INTO Account VALUES ('Martin-King','d9wezg','Default',TO_DATE('08-01-2004', 'dd-mm-yyyy'), 'SEMrush', 12000);
