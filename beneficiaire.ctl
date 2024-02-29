OPTIONS (SKIP = 1)
LOAD DATA
INFILE Beneficiaire.csv
APPEND
INTO TABLE Beneficiaire
FIELDS TERMINATED BY "," OPTIONALLY ENCLOSED BY "\n"
(IdNational,BfID "Bfincr.nextval", Nom,Prenom,Ville,Region,Telephone,Email,Etablissement)