-- compte pour projet : projet projet
/*create user projet identified by projet default tablespace users QUOTA 100M on users;
grant unlimited tablespace to projet;
grant create session, alter session, grant any privilege to projet;
grant create table to projet; 
grant create tablespace, alter tablespace, drop tablespace to projet;
grant create trigger to projet;
grant create sequence to projet;
grant create view to projet;
grant create role to projet;
grant create user to projet;
connect projet/projet; */

--CREATE USER admin IDENTIFIED BY admin;
--GRANT ALL PRIVILEGES TO admin;



--TABLES

CREATE TABLE Beneficiaire(
	IdNational varchar(15) constraint IdNatBfPK PRIMARY KEY,
	BfID number(6) constraint BfIDNN Not Null,
	Nom varchar(15) constraint NomNN Not Null,
	Prenom varchar(15),
	Ville varchar(25),
	Region varchar(15),
	Telephone varchar(10),
	Email varchar(35) constraint EmailNN Not Null,
	Etablissement varchar(30) constraint EtabNN Not Null,
	constraint BfIDU unique (BfID)
);

CREATE TABLE Benevole(
	IdNational varchar(15) constraint IdNatBvPk PRIMARY KEY,
	BvID number(6) constraint BvIDNN Not Null,
	Nom varchar(15) constraint NombenevNN Not Null,
	Prenom varchar(15),
	Ville varchar(20) constraint Villebenev Not Null,
	Region varchar(15),
	Telephone varchar(10),
	Email varchar(35),
	constraint BvIDU unique (BvID)
);

-- select constraint_name, constraint_type from user_constraints;

CREATE TABLE donateur(
	IdNational varchar(15) constraint IdNatDoPk PRIMARY KEY,
	DoID number(6) constraint DoIDNN Not Null,
	Nom varchar(40) constraint NomDNN Not Null,
	Ville varchar(40),
	Telephone varchar(10),
	Email varchar(50),
	type varchar(20) constraint DTypeNN Not null,
	constraint DoIDU unique (DoID)
);

CREATE TABLE entrepot(
	EtpID number(6) constraint EtpIDPk PRIMARY KEY,
	Ville varchar(15) constraint VilleNN Not Null,
	PoidsMax number(10) constraint PoidsMaxNN Not Null,
	type varchar(20)
);

CREATE TABLE panier(
	PanierID number(6) constraint PanierIDPk PRIMARY KEY,
	ValeurTotP number(6,2) constraint VTPNN Not Null,
	PoidsTotP number(10,2) constraint PTPNN Not Null
);

CREATE TABLE exemplaire(
	lotID number(6) constraint LotIDPk PRIMARY KEY,
	quantite number(4) constraint QNN Not Null,
	dateperemption date constraint DPNN Not Null
);

CREATE TABLE Produit(
	ProdID number(6) constraint ProdIDPk PRIMARY KEY,
	Nom varchar(35) constraint NomProdNN Not Null,
	Type varchar(16) constraint TypeProdNN Not Null,
	Marque varchar(15),
	Poids number(10,2) constraint PoidsProdNN Not Null,
	Valeur number(6,2) constraint ValeurProdNN Not Null,
	tempsconservation number(4)
); 

CREATE TABLE distribue(
	BfID number(6),
	BvID number(6),
	PanierID number(6),
	DateDis date constraint DatedisNN Not Null,
	Ville varchar(15) constraint VilleDisNN Not Null,
	constraint DisPK PRIMARY KEY (BfID, BvID, PanierID),
	constraint BfDisFK FOREIGN KEY (BfID) REFERENCES Beneficiaire (BfID),
	constraint BvDisFK FOREIGN KEY (BvID) REFERENCES Benevole (BvID),
	constraint PanierDisFK FOREIGN KEY (PanierID) REFERENCES Panier (PanierID)
);

CREATE TABLE LignePanier(
	LotID number(6),
	PanierID number(6),
	Quantite number(4) constraint QLPNN Not Null,
	ItemTotalValeur number(6,2) constraint ITVNN Not Null,
	ItemTotalPoids number(10,2) constraint ITPNN Not Null,
	constraint LPPK PRIMARY KEY (LotID,PanierID),
	constraint LotLPFK FOREIGN KEY (LotID) REFERENCES exemplaire (LotID),
	constraint PanLPFK FOREIGN KEY (PanierID) REFERENCES Panier (PanierID)
);

CREATE TABLE DONNE(
	DoID number(6),
	LotID number(6),
	Quantite number(6) constraint QDNN Not Null,
	Montant number(9,2) constraint MDNN Not Null,
	constraint DPK PRIMARY KEY (DoID, LotID),
	constraint DDFK FOREIGN KEY (DoID) REFERENCES Donateur (DoID),
	constraint LDFK FOREIGN KEY (LotID) REFERENCES exemplaire (LotID)
);

CREATE TABLE represente(
	LotID number(6),
	ProdID number(6),
	constraint RPK PRIMARY KEY (LotID,ProdID),
	constraint LRFK FOREIGN KEY (LotID) REFERENCES exemplaire (LotID),
	constraint PRFK FOREIGN KEY (ProdID) REFERENCES Produit (ProdID)
);

CREATE TABLE BcomposeP( 
	BvID number(6),
	PanierID number(6),
	constraint CPK PRIMARY KEY (BvID,PanierID),
	Constraint BCFK FOREIGN KEY (BvID) REFERENCES benevole (BvID),
	constraint PCFK FOREIGN KEY (PanierID) REFERENCES Panier (PanierID)
);

CREATE TABLE Stocke(
	LotID number(6),
	EtpID number(6),
	quantite number(6) constraint QSNN Not Null,
	constraint SPK PRIMARY KEY (LotID,EtpID),
	constraint LSFK FOREIGN KEY (LotID) REFERENCES exemplaire (LotID),
	constraint ESFK FOREIGN KEY (EtpID) REFERENCES entrepot (EtpID)
);
