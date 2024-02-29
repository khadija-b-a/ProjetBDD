--insert into Beneficiaire Values ('122925473860611',NULL,'DEMANGE','Noe','VERSAILLES','ILE-DE-FRANCE','0645653296','noe.demange@ens.uvsq.fr','UVSQ'); --Ajout sqlloader

sqlldr userid=projet/projet control = beneficiaire.ctl log = beneficiaire.log
sqlldr userid=projet/projet control = benevole.ctl log = benevole.log
sqlldr userid=projet/projet control = donateur.ctl log = donateur.log
sqlldr userid=projet/projet control = exemplaire.ctl log = exemplaire.log
sqlldr userid=projet/projet control = panier.ctl log = panier.log
sqlldr userid=projet/projet control = produit.ctl log = produit.log
sqlldr userid=projet/projet control = represente.ctl log = represente.log
sqlldr userid=projet/projet control = stocke.ctl log = stocke.log
sqlldr userid=projet/projet control = donne.ctl log = donne.log
sqlldr userid=projet/projet control = compose.ctl log = compose.log
sqlldr userid=projet/projet control = distribue.ctl log = distribue.log
sqlldr userid=projet/projet control = ligne_panier.ctl log = ligne_panier.log

-- Insertion entrepot
INSERT INTO entrepot VALUES (NULL, 'Versailles', 5650, 'ambiant');
INSERT INTO entrepot VALUES (NULL, 'Paris', 250, 'ambiant');
INSERT INTO entrepot VALUES (NULL, 'Saint Denis', 200, 'ambiant');
INSERT INTO entrepot VALUES (NULL, 'Saint Denis', 100, 'frigorifique');