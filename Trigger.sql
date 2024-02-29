
--check date distribue

CREATE OR REPLACE TRIGGER trg_check_date_Dis
 	Before INSERT or UPDATE On distribue
 	For each row
Begin
	IF (:new.DateDis <= sysdate)
	then Raise_application_error( -20001, 'Date invalide: la date doit être supérieure à la date actuelle - valeur = ');
	End IF;
End;
/

--Verifie qu'un beneficaire met son email ou son numéro de téléphone
alter table Beneficiaire add constraint cont_benef_contact check (Email is not null or Telephone is not null ); 

--génére automatiquement des Id des entrepôts 
CREATE or REPLACE TRIGGER incrementation_entrepot
	Before INSERT on entrepot
	For each row
Begin
	select Enincr.nextval into :new.EtpID 
	from dual;
End;
/

-- verifie qu'un donateur est soit une entreprise ou un particulier
alter table Donateur add constraint cont_type_dona check (lower(type) in ('entreprise','particulier')); 

--Vérfie qu'un produit est de type hygiene', 'entretien', 'frais', 'non frais', 'affaire scolaire' ou 'mode'
alter table Produit add constraint cont_type_prod check (lower(type) in ('hygiene', 'entretien', 'frais', 'non frais', 'affaire scolaire', 'mode')); 

--avant chaque insertion dans LignePanier, le trigger calcule le prix total des items grace au prix à l'unité et à la quantité et l'insere dans ItemTotalValeur, ce trigger évite les erreurs de calculs et de saisie vu que l'insertion est réalisée automatiquement
CREATE OR REPLACE TRIGGER ajout_prix_item
	before insert on LignePanier 
	for each row
Declare
	prix LignePanier.ItemTotalValeur%type:=0;
begin 
	select Valeur into prix
	from produit p
	where p.ProdID in (select r.ProdID
										 from represente r
										 where r.LotID = :new.LotID); 

	prix:=prix*:new.Quantite;
	:new.ItemTotalValeur := prix;
end; 
/

--avant chaque insertion dans LignePanier, le trigger calcule le poids total des items grâce au poids à l'unité et à la quantité et l'insere dans ItemTotalPoids
CREATE OR REPLACE TRIGGER ajout_poids_item
	before insert on LignePanier 
	for each row
Declare
	poids LignePanier.ItemTotalPoids%type:=0;
begin 
	select Poids into poids
	from produit p
where p.ProdID in (select r.ProdID
										 from represente r
										 where r.LotID = :new.LotID); 
	poids:=poids*:new.Quantite;
  :new.ItemTotalPoids:=poids; 
end; 
/

--avant chaque insertion dans donne, le trigger calcule le montant de la donation grâce à la quantité du produit donné et à son prix unitaire
CREATE OR REPLACE TRIGGER ajout_montant_donne
	before insert on donne 
	for each row
Declare
	prix donne.montant%type:=0;
begin 
	select Valeur into prix
	from produit p
	where p.ProdID in (select r.ProdID
			from represente r
			where r.LotID = :new.LotID); 
	:new.montant := prix*:new.Quantite;
end; 
/

--En cas de mise à jour dans LignePanier, le trigger lève une exception car est incapable de gérer les mises à jour. En cas de suppression dans LignePanier, le prix du panier est actualisé en retirant le prix du produit supprimé. 
CREATE OR REPLACE TRIGGER check_prix_panier_before
  before update or delete on LignePanier 
	for each row
begin 
  if (updating) then Raise_application_error(-20002, 'Mise à jour du prix impossible, Veuillez supprimez et inserer la ligne');
  ELSIF (deleting) then  
  update Panier set ValeurTotP = ValeurTotP - :old.ItemTotalValeur
		where PanierID = :old.PanierID; 
  end if; 
     end; 
/

--Suite à une insertion dans LignePanier, le prix total du panier est mis à jour. Si son montant dépasse le seuil fixé, une exception est levée et l'utilisateur est invité à supprimer la ligne insérée
CREATE OR REPLACE TRIGGER check_prix_panier_after
  after insert on LignePanier 
	for each row
Declare 
  seuil constant number(2):=20; 
  val_tot number(6,2):=0; 
begin  
  update Panier set ValeurTotP = ValeurTotP + :new.ItemTotalValeur
		where PanierID = :new.PanierID;
  
	select ValeurTotP  into val_tot
  	from panier
  	where PanierID = :new.PanierID;
	if(val_tot>seuil) 
  	then
	Raise_application_error(-20002, 'valeur total du panier depasse le seuil de ' || to_char(val_tot-seuil) ||' euros, veuillez supprimer cette ligne du panier');
  	end if;
     end; 
/

--En cas de mise à jour dans LignePanier, le trigger lève une exception car est incapable de gérer les mises à jour. En cas de suppression dans LignePanier, le poids du panier est actualisé en retirant le poids du produit supprimé. 
CREATE OR REPLACE TRIGGER check_poids_panier_before
  before update or delete on LignePanier 
	for each row
begin 
  if (updating) then Raise_application_error(-20002, 'Mise à jour du prix impossible, Veuillez supprimez et inserer la ligne');
  ELSIF (deleting) then  
  update Panier set PoidsTotP = PoidsTotP - :old.ItemTotalPoids
		where PanierID = :old.PanierID; 
  end if; 
     end; 
/

--Suite à une insertion dans LignePanier, le poids total du panier est mis à jour. Si son total dépasse le seuil fixé, une exception est levée et l'utilisateur est invité à supprimer la ligne insérée
CREATE OR REPLACE TRIGGER check_poids_panier_after
  after insert on LignePanier 
	for each row
Declare 
  seuil constant number(2):=10; 
  poids_tot number(10,2):=0; 
begin  
  update Panier set poidsTotP = poidsTotP + :new.ItemTotalpoids
		where PanierID = :new.PanierID;
  
	select poidsTotP  into poids_tot
  	from panier
  	where PanierID = :new.PanierID;
	if(poids_tot>seuil) 
  	then
	Raise_application_error(-20002, 'poids total du panier depasse le seuil de ' || to_char(poids_tot-seuil) ||' kg, veuillez supprimer cette ligne du panier');
  	end if;
     end; 
/

--vérifie qu'un entrepôt ne soit que du type ambiant ou frigorifique: contrainte type d'entrepôt
alter table entrepot add constraint cont_type_entrepot check (lower(type) in ('ambiant','frigorifique')); 

--Verifie le stockage des produits et des exemplaires dans les entrepôt en fonction du type de chacun (les produits frais dans les entrepots frigorifique et les autres types 'non frais', 'mode'.. dans les entrepôts de type ambiant)
CREATE OR REPLACE TRIGGER check_stocke_entrepot
 before insert on Stocke for each row
 Declare
typepot Entrepot.type%type;
typeprod Produit.type%type;
 Begin 
 select  e.type into typepot
 from Entrepot e 
 where e.EtpID=:new.EtpID ;
 select type into typeprod 
 from produit
 where ProdID in 
    (select ProdID
    from represente
    where LotID= :new.LotID);
if((upper(typepot)='AMBIANT' and upper(typeprod)='FRAIS') or(upper(typepot)='FRIGORIFIQUE' and upper(typeprod)!='FRAIS')) then 
raise_application_error(-20002,'type d"entrepot et de produit incompatible, insertion impossible');
		end if;
 end; 
/

 --SUSPENDU: compare le poids max d'un entrepot avec le poids déja presente + le nouveau poids
 CREATE OR REPLACE TRIGGER check_entrepot_poids
 before insert or update or delete on Stocke for each row
 Declare
  poidsent Entrepot.PoidsMax%type; 
  poidstotalprod Entrepot.PoidsMax%type; 
  cursor c1 is 
    select LotId, quantité
    from stocke
 begin 
 
 select PoidsMax into poidsent 
 from Entrepot 
 where :new.EtpID=EtpID ; 


if (inserting) then  
  update Panier set ValeurTotP = ValeurTotP + :new.ItemTotalValeur;
		where PanierID = :new.PanierID;
 end; 
 /

--uniquement a mettre dans le compte rendu
--verifier qu'une ville d'un bénévole ou d'un bénéficiaire ne se trouve pas dans 2 Régions différentes
/*create or replace trigger check_ville_benevole before insert on Benevole for each row
	declare
		reg Benevole.region%type := NULL;
	begin
		select distinct Region into reg
		from Benevole
		where ville = :new.ville;
		if (SQL%FOUND and reg != :new.Region) then 
					raise_application_error(-20002,'violation de dependance fonctionnelle, insertion impossible');
		end if;
	end;
/

create or replace trigger check_ville_beneficiaire before insert on Beneficiaire for each row
	declare
		reg Beneficiaire.region%type := NULL;
	begin
		select distinct Region into reg
		from Beneficiaire
		where ville = :new.ville;
		if (SQL%FOUND and reg != :new.Region) then 
					raise_application_error(-20002,'violation de dependance fonctionnelle, insertion impossible');
		end if;
	end;
/
*/ 
--ne marche pas car quand pas de donnée NO_DATA_FOUND du coup on peut pas insérer de donnée, je crois que le moyen serait de vérifier après avoir insérer et de supprimer mais c'est pas top
--verifier qu'un bénéficiaire ne s'inscrit pas a  discri la même semaine

