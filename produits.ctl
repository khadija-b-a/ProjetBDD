OPTIONS (SKIP = 1)
LOAD DATA
INFILE Produits.csv
APPEND
INTO TABLE produit
FIELDS TERMINATED BY "," OPTIONALLY ENCLOSED BY "\n"
(ProdID,Nom,Type,Marque,Poids,Valeur,tempsconservation)
