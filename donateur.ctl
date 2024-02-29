OPTIONS (SKIP = 1)
LOAD DATA
INFILE Donateur.csv
APPEND
INTO TABLE Donateur
FIELDS TERMINATED BY "," OPTIONALLY ENCLOSED BY "\n"
(IdNational,DoID "Doincr.nextval",Nom,Ville,Telephone,Email,Type)