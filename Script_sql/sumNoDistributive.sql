create schema if not exists test_null ;
SET search_path TO test_null;	
drop table if exists activite;
create table activite (code_activ char(9) primary key, intitule varchar(20), titulaire char(3), h_cours int, h_tp int);
insert into activite values
	('INFO 1232', 'Java', 'PHE', 30, 15), ('INFO 1241', 'Labo prog.', 'PHE', NULL, 45),
	('INFO 2101', 'BD', 'JLH', 30, NULL),('INFO 2111', 'Projet qualité', 'NHA', NULL, 30),
	('INFO 2120', 'Modélisation', 'JLH', 20, 10), ('INFO 2213', 'Conception', 'VEN', 45, NULL),
	('INFO 2214', 'Mise en oeuvre', 'VEN', 60, NULL),
	('INFO 2231', 'Labo Gestion', 'NHA', NULL, 45);

select TITULAIRE, sum(H_COURS) + sum(H_TP) as CHARGE
from ACTIVITE
group by TITULAIRE;

select TITULAIRE, sum(H_COURS + H_TP) as CHARGE
from ACTIVITE
group by TITULAIRE
