OPTIONS (SKIP = 1)
LOAD DATA
INFILE Represente.csv
APPEND
INTO TABLE represente
FIELDS TERMINATED BY "," OPTIONALLY ENCLOSED BY "\n"
(LotID,ProdID)