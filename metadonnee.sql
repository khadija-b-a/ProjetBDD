
--liste_ora_constraints
select constraint_name, constraint_type,table_name
from user_constraints
order by table_name, constraint_type; 

CONSTRAINT_NAME                C TABLE_NAME
------------------------------ - ------------------------------
CPK                            P BCOMPOSEP
PCFK                           R BCOMPOSEP
BCFK                           R BCOMPOSEP
ETABNN                         C BENEFICIAIRE
EMAILNN                        C BENEFICIAIRE
BFIDNN                         C BENEFICIAIRE
NOMNN                          C BENEFICIAIRE
CONT_BENEF_CONTACT             C BENEFICIAIRE
IDNATBFPK                      P BENEFICIAIRE
BFIDU                          U BENEFICIAIRE
BVIDNN                         C BENEVOLE

CONSTRAINT_NAME                C TABLE_NAME
------------------------------ - ------------------------------
NOMBENEVNN                     C BENEVOLE
VILLEBENEV                     C BENEVOLE
IDNATBVPK                      P BENEVOLE
BVIDU                          U BENEVOLE
VILLEDISNN                     C DISTRIBUE
DATEDISNN                      C DISTRIBUE
DISPK                          P DISTRIBUE
BVDISFK                        R DISTRIBUE
PANIERDISFK                    R DISTRIBUE
BFDISFK                        R DISTRIBUE
NOMDNN                         C DONATEUR

CONSTRAINT_NAME                C TABLE_NAME
------------------------------ - ------------------------------
DTYPENN                        C DONATEUR
DOIDNN                         C DONATEUR
CONT_TYPE_DONA                 C DONATEUR
IDNATDOPK                      P DONATEUR
DOIDU                          U DONATEUR
MDNN                           C DONNE
QDNN                           C DONNE
DPK                            P DONNE
LDFK                           R DONNE
DDFK                           R DONNE
VILLENN                        C ENTREPOT

CONSTRAINT_NAME                C TABLE_NAME
------------------------------ - ------------------------------
CONT_TYPE_ENTREPOT             C ENTREPOT
POIDSMAXNN                     C ENTREPOT
ETPIDPK                        P ENTREPOT
DPNN                           C EXEMPLAIRE
QNN                            C EXEMPLAIRE
LOTIDPK                        P EXEMPLAIRE
ITVNN                          C LIGNEPANIER
QLPNN                          C LIGNEPANIER
ITPNN                          C LIGNEPANIER
LPPK                           P LIGNEPANIER
PANLPFK                        R LIGNEPANIER

CONSTRAINT_NAME                C TABLE_NAME
------------------------------ - ------------------------------
LOTLPFK                        R LIGNEPANIER
PTPNN                          C PANIER
VTPNN                          C PANIER
PANIERIDPK                     P PANIER
CONT_TYPE_PROD                 C PRODUIT
VALEURPRODNN                   C PRODUIT
POIDSPRODNN                    C PRODUIT
TYPEPRODNN                     C PRODUIT
NOMPRODNN                      C PRODUIT
PRODIDPK                       P PRODUIT
RPK                            P REPRESENTE

CONSTRAINT_NAME                C TABLE_NAME
------------------------------ - ------------------------------
LRFK                           R REPRESENTE
PRFK                           R REPRESENTE
QSNN                           C STOCKE
SPK                            P STOCKE
LSFK                           R STOCKE
ESFK                           R STOCKE


--liste_ora_triggers
select trigger_name, trigger_type, table_name 
from user_triggers
order by table_name,trigger_type;

TRIGGER_NAME                   TRIGGER_TYPE     TABLE_NAME
------------------------------ ---------------- ------------------------------
TRG_CHECK_DATE_DIS             BEFORE EACH ROW  DISTRIBUE
AJOUT_MONTANT_DONNE            BEFORE EACH ROW  DONNE
INCREMENTATION_ENTREPOT        BEFORE EACH ROW  ENTREPOT
CHECK_PRIX_PANIER_AFTER        AFTER EACH ROW   LIGNEPANIER
CHECK_POIDS_PANIER_AFTER       AFTER EACH ROW   LIGNEPANIER
CHECK_POIDS_PANIER_BEFORE      BEFORE EACH ROW  LIGNEPANIER
AJOUT_PRIX_ITEM                BEFORE EACH ROW  LIGNEPANIER
AJOUT_POIDS_ITEM               BEFORE EACH ROW  LIGNEPANIER
CHECK_PRIX_PANIER_BEFORE       BEFORE EACH ROW  LIGNEPANIER
CHECK_STOCKE_ENTREPOT          BEFORE EACH ROW  STOCKE


--liste_ora_views
select view_name 
from user_views; 

VIEW_NAME
--------------------
DATE_DISTRIBUTION
DON_PRODUIT
HISTORIQUE_BENEVOLE
MOY_BENEFICIAIRE
POIDS_ENTREPOT
SOMME_BENEFICIAIRE


--liste_ora_views
select table_name
from user_tables;

TABLE_NAME
------------------------------
BENEFICIAIRE
BENEVOLE
DONATEUR
ENTREPOT
PANIER
EXEMPLAIRE
PRODUIT
DISTRIBUE
LIGNEPANIER
DONNE
REPRESENTE

TABLE_NAME
------------------------------
BCOMPOSEP
STOCKE
