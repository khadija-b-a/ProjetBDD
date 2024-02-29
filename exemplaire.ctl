OPTIONS (SKIP = 1)
LOAD DATA
INFILE Exemplaire.csv
APPEND
INTO TABLE exemplaire
FIELDS TERMINATED BY "," OPTIONALLY ENCLOSED BY "\n"
(LotID,quantite,dateperemption "TO_DATE(:dateperemption,'DD-MM-YYYY')")