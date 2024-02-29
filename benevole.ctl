OPTIONS (SKIP = 1)
LOAD DATA
INFILE Benevole.csv
APPEND
INTO TABLE Benevole
FIELDS TERMINATED BY "," OPTIONALLY ENCLOSED BY "\n"
(IdNational,BvID "Bvincr.nextval", Nom,Prenom,Ville,Region,Telephone,Email)