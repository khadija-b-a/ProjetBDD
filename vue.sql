----------Création des roles et utilisateurs-----------

--utilisateur avec tous les droits, maitre incontesté de la bd
--CREATE USER sys_admin IDENTIFIED BY sys_admin;
--GRANT ALL PRIVILEGES TO sys_admin;

CREATE ROLE beneficiaire IDENTIFIED BY beneficiaire; 
GRANT SELECT ON date_distribution TO beneficiaire;

CREATE ROLE gestion_produits IDENTIFIED BY produits; 
GRANT SELECT, INSERT, UPDATE, DELETE ON produit  TO gestion_produits;
GRANT SELECT, INSERT, UPDATE, DELETE ON exemplaire  TO gestion_produits;
GRANT SELECT, INSERT, UPDATE, DELETE ON lignepanier  TO gestion_produits;
GRANT SELECT, INSERT, UPDATE, DELETE ON bcomposep  TO gestion_produits;
GRANT SELECT ON don_produit TO gestion_produits;

CREATE ROLE organisation IDENTIFIED BY organisation;
GRANT SELECT, INSERT, UPDATE, DELETE ON distribue  TO organisation;
GRANT SELECT, INSERT, UPDATE, DELETE ON lignepanier  TO organisation;
GRANT SELECT ON historique_benevole TO organisation;
GRANT SELECT ON poids_entrepot TO organisation;
GRANT SELECT ON somme_beneficiaire TO organisation;
GRANT SELECT ON moy_beneficiaire TO organisation;

CREATE ROLE master_benevole IDENTIFIED BY benevole; 
GRANT gestion_produits TO master_benevole;
GRANT organisation TO master_benevole;
GRANT SELECT, INSERT, UPDATE, DELETE ON beneficiaire  TO master_benevole;
GRANT SELECT, INSERT, UPDATE, DELETE ON benevole  TO master_benevole;

CREATE ROLE donateur IDENTIFIED BY donateur;
GRANT SELECT ON don_produit TO donateur;

CREATE USER exemple_benevole1 IDENTIFIED BY benevole1;
grant create session, alter session, grant any privilege to exemple_benevole1;


connect exemple_benevole1/benevole1;
GRANT SET ROLE to exemple_benevole1
SET ROLE gestion_produits IDENTIFIED by produits;
SET ROLE organisation IDENTIFIED by organisation;
-- pour vérifier les roles attribués à une session (ici session = exemple_benevole)
SELECT * FROM session_roles;
-- pour afficher tous les privileges associés à une session
SELECT * FROM session_privs
ORDER BY privilege;

connect sys_admin/sys_admin;

CREATE USER exemple_benevole2 IDENTIFIED BY benevole2;
connect exemple_benevole2/benevole2;
SET ROLE master_benevole IDENTIFIED by benevole;
SELECT * FROM session_roles;
SELECT * FROM session_privs
ORDER BY privilege;

connect sys_admin/sys_admin;

CREATE USER exemple_beneficiaire IDENTIFIED BY beneficiaire;
connect exemple_beneficiaire/beneficiaire;
SET ROLE beneficiaire IDENTIFIED by beneficiaire;
SELECT * FROM session_roles;
SELECT * FROM session_privs
ORDER BY privilege;

connect sys_admin/sys_admin;

CREATE USER exemple_donateur IDENTIFIED BY donateur;
connect exemple_donateur/donateur;
SET ROLE beneficiaire IDENTIFIED by beneficiaire;
SELECT * FROM session_roles;
SELECT * FROM session_privs
ORDER BY privilege;


-------------------Vues--------------------
-- Vue du bénévole sur les bénévoles qui ont distribué entre les dates '01-01-2022' et '01-02-2022'
create view historique_benevole as (
select b.BvID, b.Nom, b.Prenom, d.Datedis 
from benevole b, distribue d
where b.BvID=d.BvID and d.Datedis between TO_DATE('01-01-2022','DD-MM-YYYY')and TO_DATE('01-02-2022','DD-MM-YYYY')
); 

-- Vue de la capacité utilisée de l'entrepot
Create view poids_entrepot as(
select e.ETPID, e.type, temp.somme_quantite
from entrepot e, (select s.ETPID, sum(quantite) as somme_quantite
	from stocke s
	group by s.EtpID) temp
where e.ETPID = temp.ETPID
); 

-- Vue du nombre de bénéficiaires étant venus aux distributions en fonction de la date
Create view somme_beneficiaire(somme) as( 
select count(BfID)
from distribue
group by Datedis
);
--Vue du Nombre moyen de bénéficiaires par distribution
create view moy_beneficiaire as (
  select avg(somme) as moyenne
  from somme_beneficiaire
);

-- Vue de la date de distribution
Create view date_distribution as (
  select distinct(Datedis)
  from distribue
);

--Vue des produits donnés par le donateur n°5
Create view don_produit as (
  select p.nom, p.type, p.marque
  from Produit p, represente r, exemplaire e, donne d, donateur do
  where p.ProdID=r.ProdId 
	and r.LotID=e.LotID 
	and r.LotID=d.LotID 
	and d.doID=do.doID 
	and do.doID=5
);
