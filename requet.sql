1- --Combien de paniers ont été distribués sur la période du 30-01-2022 au 28-02-2022 ?
select count(*)
from distribue
where(DateDis>= TO_DATE('30-01-2022','DD-MM-YYYY') and DateDis<=TO_DATE('28-02-2022','DD-MM-YYYY')); 

2- --Quels sont les étudiants qui habitent dans la ville Versailles et qui fréquentent l’établissement UVSQ ?
select IdNational, Nom, Prenom
from beneficiaire
where Etablissement='UVSQ' and Ville='Versailles'; 

3- --Quel est l’établissement le plus représenté dans la base de données ?
SELECT Etablissement
FROM (	
	SELECT Etablissement, COUNT(Etablissement) AS value_occurrence
	FROM beneficiaire
	GROUP BY Etablissement
	ORDER BY value_occurrence DESC)
WHERE rownum = 1; -- le premier de la liste 


4- --Quels sont les étudiants de l’établissement UVSQ qui sont venus à la distribution à la date 06-01-2022 ?
select IdNational, Nom, Prenom
from  beneficiaire
where Etablissement='UVSQ' 
and BfID in (select BfID
    	from distribue 
    	where DateDis=TO_DATE('06-01-2022','DD-MM-YYYY'));


5- --Quel donateur donne le plus fréquemment ?
SELECT NOM, telephone, email, type, temp.value_occurrence
FROM Donateur d,( SELECT DoID,COUNT(*) AS value_occurrence
	FROM donne
	GROUP BY DoID
	ORDER BY value_occurrence DESC ) temp
WHERE d.DoID = temp.DoID
and rownum = 1;


6- --Quel donateur fait les dons les plus généreux ?
SELECT NOM, telephone, email, type, temp.value_occurrence
FROM donateur d,(SELECT DoID,sum(Montant) AS value_occurrence
	FROM donne
	GROUP BY DoID
	ORDER BY value_occurrence DESC ) temp
WHERE d.DoID = temp.DoID
and rownum = 1;


7- --Quel est le poids moyen des paniers ?
select avg(PoidsTotP)
from Panier; 



8- --Quels sont les produits les plus donnés par les donateurs ?
select *
from (select p.nom, p.type, p.marque, temp.value_occurrence
from produit p, exemplaire e, represente r, (SELECT LOTID,sum(quantite) AS value_occurrence
	FROM donne
	GROUP BY LotID) temp
where temp.lotid = e.lotid
and e.lotid = r.lotid
and r.prodid = p.prodid
ORDER BY temp.value_occurrence DESC )
where rownum<=3;

9- --Quel sont les types de produits les plus donnés par les donateurs dans l'ordre decroissant?
select p.type, sum(temp.value_occurrence) as nb_fois_type
from produit p, exemplaire e, represente r, (SELECT LOTID,sum(quantite) AS value_occurrence
	FROM donne
	GROUP BY LotID) temp
where temp.lotid = e.lotid
and e.lotid = r.lotid
and r.prodid = p.prodid
group by p.type
ORDER BY nb_fois_type DESC ;

10- --Quels sont les produits composant le panier 20 distribué à la date 06-JAN-22 ?
select P.nom, p.type
from produit p
where p.prodid in (select prodid
		from represente
		where lotid in (select lotid
				from lignepanier
				where panierid = 20));


11- --Quels sont les produits différents stockés dans l’entrepôt qui se trouve à Saint Denis ?
select distinct(p.prodid),p.nom
from represente r, produit p
where LotId in ( 
  select LotId
  from stocke
  where EtpId in (
    select EtpId 
    from entrepot 
    where Ville='Saint Denis' ))
and r.prodid = p.prodid;

12- --Quel est la capacité disponible dans un entrepôt E ?
prompt 'Donner identifiant entrepot (1, 2, 3,4)'
accept id

Declare 
cursor c1 is 
  select LotID, quantite
  from exemplaire
  where LotID in (
    select LotID
    from stocke
    where EtpId= &id);
poid_prod produit.poids%type:=0; 
somme_poids entrepot.PoidsMax%type:=0; 
poidsmax entrepot.PoidsMax%type;
begin 
FOR tuple IN c1 LOOP
	select poids into poid_prod
	from produit
	where ProdID in (
  		select ProdID
  		from represente r
  		where tuple.LotID=r.LotID ); 
somme_poids:=somme_poids+tuple.quantite*poid_prod;
End loop; 
select PoidsMax into poidsmax 
from entrepot 
where EtpId=&id; 
somme_poids:=poidsmax-somme_poids;
if(somme_poids>0) then 
dbms_output.put_line('stockage restant dans l''entrepot ' ||&id||' est'|| somme_poids);
elsif (somme_poids=0) then dbms_output.put_line('L''entrepot '  ||&id||  ' est rempli, Veuillez ne rien y ajouter');
Else dbms_output.put_line('Entrepot  ' ||&id||' est sature, Veuillez transferer vers un autre entreppot');
end if; 
end; 
/

13- --Quels sont les entrepôts de type frigorifique ?
select EtpId
from Entrepot
where upper(type)='FRIGORIFIQUE'; 

14- --Quels sont les entrepôts ayant une capacité supérieure à c dans la ville V ?
prompt 'donner une ville'
accept ville 
prompt 'donner une capacite en kg'
accept capacite 

select EtpId
from Entrepot 
where Ville=&ville and PoidsMax>=&capacite; 


15- --Quels sont les bénévoles qui habitent dans la même ville V que l’entrepôt E 
prompt 'Donner une ville'
accept ville_etp

select *
from benevole
where Ville in (
  select Ville 
  from entrepot 
  where Ville=&ville_etp);

16- --Quels sont les entrepôts dont la capacité est supérieure à c et de type ambiant ?
select *
from Entrepot
where PoidsMax > 500 and upper(Type) = 'AMBIANT';

17- --Quelles sont les marques les plus données par les donateurs particuliers par ordre décroissant ?
select p.marque, sum(temp.value_occurrence) as nb_fois_type
from produit p, exemplaire e, represente r, (SELECT d.LOTID,sum(d.quantite) AS value_occurrence
	FROM donne d,donateur dona
	where d.doId=dona.doID
	and lower(dona.type)='particulier'
	GROUP BY d.LotID) temp
where temp.lotid = e.lotid
and e.lotid = r.lotid
and r.prodid = p.prodid
group by p.marque
ORDER BY nb_fois_type DESC ;

18- --Lors de quel mois, l’association distribue-t-elle le moins de paniers ?
select *
from (select TO_CHAR(datedis,'MM-YYYY'), count(*) as value_occurrence
	from distribue
	group by TO_CHAR(datedis,'MM-YYYY')
	order by value_occurrence asc)
where rownum =1;

19- --DIVISION Quels produits sont présent dans tous les paniers ?
-- Quels sont les produits, tel que quelque soit le panier ils sont dedans
-- Quels sont les produits, tel que quelque soit le panier, il existe une lignepanier pour ce produit et qui concerne ce panier
-- Quels sont les produits, tel que il n'existe pas de panier, tel qu'il n'existe pas une lignepanier pour ce produit et qui concerne ce panier
SELECT Prodid, nom
FROM produit p 
WHERE not exists(select *
		FROM  panier pa
		WHERE not exists (select *
				 FROM lignepanier lp,  represente r
				 WHERE pa.panierID = lp.panierid
				 AND lp.lotid = r.lotid
				 AND r.prodid = p.prodid));


20- --Quelle est la date limite de consommation de l’exemplaire 24 ?
select dateperemption + temp.d
from exemplaire e, (select p.tempsconservation as d
		from produit p, represente r
		where r.lotid = 24
		and r.prodid = p.prodid) temp
where LotId = 24;



21- --quelles sont les villes comptant le plus d’étudiants précaires par ordre décroissant?
select Ville, count(Ville) AS value_occurrence
from beneficiaire
group by Ville
order by value_occurrence DESC; 

22- --Un bénévole a détecté un problème pour un produit, l’association doit donc retrouver tous les bénéficiaires l’ayant reçu dans leur panier ainsi que le donateur, quelles sont les adresses mail des bénéficiaires ayant reçu l'exemplaire de lotID 4 et de son donateur ?

select distinct(bf.email)
from beneficiaire bf, donateur do
where bf.BfID in (select d.BfID
		from distribue d
		where d.panierid in (select lp.panierid
			from lignepanier lp
			where lp.lotid = 4))
union
select distinct(do.email)
from donateur do
where do.doId in (select d.DoID
		from donne d
		where d.lotid =4);

23- --Quels sont donc les bénévoles qui distribuent dans une ville différente de celle dans laquelle ils habitent ?
select B.BvID,B.Nom, B.Prenom
from Benevole B, distribue D
where B.Ville != D.Ville and D.BvID = B.BvID;



24- --Sachant le type de produits donnés par les donateurs, quels sont les donateurs à solliciter lorsqu’il n’y a plus le produit 15 ?

 select *
 from Donateur
 where DoID in (
   select DoID
   from donne d, exemplaire e
   where d.LotID=e.LotID and d.LotId in (
     select LotID
      from represente  
      where ProdID=15));

--Verifié jusqu'à là

25- --Quels sont les bénévoles qui ont assisté à toutes les distributions? 
--Quels sont les bénévoles tel que quelque soit la distribution, ils y étaient? 
--Quels sont les bénévoles tel que quelque soit la distribution ils ont distribué un panier? 
--Quels sont les bénévoles tel qu'il n'existe pas de distribution, tel qu'ils n'y ont pas distribué de panier?


select b.BvID 
from benevole b, distribue d
where d.BvID = b.BvID
group by b.BvID
having count(distinct d.DateDis) = (select count(distinct datedis) from distribue); 
