create schema if not exists test_views ;
SET search_path TO test_views;
	
drop table if exists agence cascade;
drop table if exists client cascade;
drop table if exists compte cascade;
drop table if exists pret cascade;
drop table if exists proprietaire cascade;
drop table if exists credit cascade;
drop table if exists Tous_les_clients;
drop table if exists Tous_les_clients_table;
drop view if exists Tous_les_clients;
drop view if exists Tous_les_clients_mat;
drop view if exists pret_sans_montant;
drop view if exists pret_sans_montant_mat;


create table agence (nom_agence varchar(20) primary key, ville_agence varchar(20) not null, capital int not null);
create table client (id_client serial primary key, nom_client varchar(30));
create table compte (num_compte serial primary key, nom_agence varchar(20) references agence on delete set null on update cascade, montant int default 0);
create table pret(numero_pret serial primary key,  nom_agence varchar(20) references agence on delete set null on update cascade, montant int);
create table proprietaire(id_client integer references client on delete cascade on update cascade, num_compte integer references compte on delete cascade on update cascade, primary key(id_client, num_compte));
create table credit(id_client integer references client, id_pret integer references pret on delete set null on update cascade);--, primary key(id_client,id_pret));
-- j'ai commenté la clef primaire pour pouvoir supprimer des données via la vue (mais ne faites pas ça dans la vraie vie ! toute table a besoin d'une clef primaire !)

insert into agence values
	('Paris 13', 'Paris', 3000000),('Paris 09', 'Paris', 9000000),('Paris 01', 'Paris', 1000000),('Puteaux 00', 'Puteaux', 666666666),('Levallois-Perret 666', 'Levallois-Perret', 666666666),('Le Touquet 00', 'Le Touquet', 8000000);

insert into client(nom_client) values
('Liliane Bettencourt'), ('Emmanuel Macron'), ('Jerome Cahuzac'), ('Francois Fillon'), ('Patrick Balkany'),('Joëlle Ceccaldi-Raynaud');	


insert into compte (nom_agence,montant)values
	('Puteaux 00', 2865000),('Levallois-Perret 666', 12),('Paris 01', 0);

insert into pret(nom_agence, montant) values
	('Puteaux 00', 400000),('Levallois-Perret 666', 1000000),('Paris 01', 700000), ('Le Touquet 00', 950000);

insert into proprietaire values (6,1),(5,2);

insert into credit values (6,1),(5,2),(3,3),(2,4);

\! echo "Création d'une nouvelle table avec tous les clients"

create table Tous_les_clients_table as 
(SELECT nom_agence, id_client
	FROM Proprietaire P, Compte C
	WHERE P.num_compte=C.num_compte)
UNION
(SELECT nom_agence, id_client
	FROM Credit C, Pret P
	WHERE C.id_pret=P.numero_pret);

-- Attention ! Notez que créée de cette façon la table n'a pas de clef étrangère... vous devez la rajouter ! (ainsi que toutes les contraintes)

\! echo "Contenu de cette table"
Select * from Tous_les_clients_table;

\! echo "détails concernant cette table"
\d Tous_les clients_table

create view Tous_les_clients as 
(SELECT nom_agence, id_client
	FROM Proprietaire P, Compte C
	WHERE P.num_compte=C.num_compte)
UNION
(SELECT nom_agence, id_client
	FROM Credit C, Pret P
	WHERE C.id_pret=P.numero_pret);

\! echo "contenu de la vue pour 'Paris 13' avant le pret de François Fillon"
select id_client from tous_les_clients where nom_agence='Paris 13';

create materialized view Tous_les_clients_mat as 
(SELECT nom_agence, id_client
	FROM Proprietaire P, Compte C
	WHERE P.num_compte=C.num_compte)
UNION
(SELECT nom_agence, id_client
	FROM Credit C, Pret P
	WHERE C.id_pret=P.numero_pret);

\! echo "contenu de la vue matérialisée pour 'Paris 13' avant le pret de François Fillon"
select id_client from tous_les_clients_mat where nom_agence='Paris 13';

\! echo "insertion du pret de François Fillon"
insert into pret(nom_agence, montant) values ('Paris 13', 375000);
insert into credit values (4,5);

\! echo "contenu de la vue virtuelle pour 'Paris 13' après le pret de François Fillon"
select id_client from Tous_les_clients where nom_agence='Paris 13';

\! echo "contenu de la vue matérialisée pour 'Paris 13'  après le pret de François Fillon"
select id_client from Tous_les_clients_mat where nom_agence='Paris 13';

\! echo "rafraichissement de la vue matérialisée"
refresh materialized view Tous_les_clients_mat;

\! echo "contenu de la vue matérialisée pour 'Paris 13'  après raffraichissement"
select id_client from Tous_les_clients_mat where nom_agence='Paris 13';

--\! echo "mise à jour de la vue non matérialisée (échec)"

--insert into Tous_les_clients values ('Paris 13', 3);

\! echo "création d'une vue plus simple (prêts sans montants)"

create view pret_sans_montant as
	select numero_pret, nom_agence from pret;

\! echo "création d'une vue matérialisée plus simple (prêts sans montants)"

create materialized view pret_sans_montant_mat as
	select numero_pret, nom_agence from pret;

\! echo "contenu de la table prêt"

select * from pret;	

\! echo "insertion via la vue plus simple non matérialisée (ok)"

insert into pret_sans_montant(nom_agence) values ('Le Touquet 00');

\! echo "insertion via la vue plus simple matérialisée (échec)"

insert into pret_sans_montant_mat(nom_agence) values ('Le Touquet 00');

\! echo "contenu de la table prêt"

select * from pret;	

\! echo "contenu de la vue prêt_sans_montant"

select * from pret_sans_montant;	

\! echo "contenu de la vue prêt_sans_montant_mat"

select * from pret_sans_montant_mat;



\! echo "suppression via la vue plus simple non matérialisée (ok)"

delete from pret_sans_montant where nom_agence='Le Touquet 00';


\! echo "contenu de la vue prêt_sans_montant"

select * from pret_sans_montant;	

--\! echo "contenu du schéma test_views"
--\d+


\! echo "utilisation d'une table temporaire dans un WITH"
-- à préférer s'il ne s'agit que de simplifier l'écriture d'une requête !

WITH Tous_les_clients_temporaire as 
((SELECT nom_agence, id_client
	FROM Proprietaire P, Compte C
	WHERE P.num_compte=C.num_compte)
UNION
(SELECT nom_agence, id_client
	FROM Credit C, Pret P
	WHERE C.id_pret=P.numero_pret))
Select * from Tous_les_clients_temporaire;


\! echo "ce qui est contenu dans le schéma et ce qui ne l'est pas"

\d+ Tous_les_clients_table
\d+ Tous_les_clients
\d+ Tous_les_clients_mat
\d+ pret_sans_montant
\d+ pret_sans_montant_mat
\d+ Tous_les_clients_temporaire

--\! echo "contenu du schéma test_views après utilisation d'une table temporaire dans un WITH"
--\d+
