OPTIONS (SKIP = 1)
LOAD DATA
INFILE Distribue.csv
APPEND
INTO TABLE distribue
FIELDS TERMINATED BY "," OPTIONALLY ENCLOSED BY "\n"
(BfID,BvID,PanierID,DateDis "TO_DATE(:DateDis,'DD-MM-YY')",Ville)