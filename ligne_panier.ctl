OPTIONS (SKIP = 1)
LOAD DATA
INFILE ligne_panier.csv
APPEND
INTO TABLE lignepanier
FIELDS TERMINATED BY "," OPTIONALLY ENCLOSED BY "\n"
(LotID,PanierID,Quantite,ItemTotalValeur,ItemTotalPoids)