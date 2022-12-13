create schema if not exists test_with_rec ;
SET search_path TO test_with_rec;
drop table if exists vols;

create table vols(ville_depart char(3), ville_arrivee char(3), primary key (ville_depart, ville_arrivee));

insert into vols values
	('SCL','CDG'),('AMS','CDG'),('CDG','EDI'),('CDG','AMS'),('AMS','EDI');


\! echo "contenu de la table vols"

select * from vols;

\! echo "vols en au plus une escale"

SELECT V1.ville_depart, V2.ville_arrivee
FROM Vols V1, Vols V2
WHERE V1.ville_arrivee = V2.ville_depart
UNION
SELECT * FROM Vols ;

\! echo "vols en au plus une escale, avec UNION ALL"

SELECT V1.ville_depart, V2.ville_arrivee
FROM Vols V1, Vols V2
WHERE V1.ville_arrivee = V2.ville_depart
UNION ALL
SELECT * FROM Vols ;

\! echo "vols en au plus deux escales"

SELECT V1.ville_depart, V3.ville_arrivee
FROM Vols V1, Vols V2, Vols V3
WHERE V1.ville_arrivee = V2.ville_depart
AND V2.ville_arrivee=V3.ville_depart
UNION
SELECT V1.ville_depart, V2.ville_arrivee
FROM Vols V1, Vols V2
WHERE V1.ville_arrivee = V2.ville_depart
UNION
SELECT * FROM Vols ;

\! echo "vols en au plus deux escales, avec UNION ALL"

SELECT V1.ville_depart, V3.ville_arrivee
FROM Vols V1, Vols V2, Vols V3
WHERE V1.ville_arrivee = V2.ville_depart
AND V2.ville_arrivee=V3.ville_depart
UNION ALL
SELECT V1.ville_depart, V2.ville_arrivee
FROM Vols V1, Vols V2
WHERE V1.ville_arrivee = V2.ville_depart
UNION ALL
SELECT * FROM Vols ;

\! echo "requête récursive (nombre d'escales non borné)"

WITH RECURSIVE Access(ville_depart, ville_arrivee) AS
(
SELECT * FROM Vols
UNION
SELECT V.ville_depart, A.ville_arrivee
FROM Vols V, Access A
WHERE V.ville_arrivee = A.ville_depart
)
SELECT * FROM Access ;

\! echo "requête récursive (nombre d'escales non borné) avec UNION ALL"

WITH RECURSIVE Access(ville_depart, ville_arrivee) AS
(
SELECT * FROM Vols
UNION ALL
SELECT V.ville_depart, A.ville_arrivee
FROM Vols V, Access A
WHERE V.ville_arrivee = A.ville_depart
)
SELECT * FROM Access
LIMIT 25;

--test sans LIMIT 25 à vos risques et périls...

\! echo "calcul de la somme des 100 premiers entiers"

WITH RECURSIVE t(n) AS
(
VALUES (1)
UNION
SELECT n+1 FROM t WHERE n < 100
)
SELECT sum(n) FROM t;
