#On appelle la librarie Postgre

library("RPostgreSQL")
library('dplyr')


drv <- dbDriver("PostgreSQL")
# creates a connection to the postgres database
# note that "con" will be used later in each connection to the database
#on connecte directement à la base de l'INRAE (possible de changer user et pw)
con <- dbConnect(drv, dbname = "db_gardouch",
                 host = "pggeodb.nancy.inrae.fr", port = 5432,
                 user = "jbelbouab", password = "belbouabj",
                 options="-c search_path=main,public,animals")

#Test pour vérifier si une table existe (ça ne marche pas sur les vues) 
dbExistsTable(con, "tr_object_obj")
dbExistsTable(con, "t_individu_ind")

#Test de requête SQL sur la db 
rs <- dbSendQuery(con, "SELECT * FROM tr_object_obj ORDER BY obj_id ASC")

#Création d'un dataframe (test)
df <- fetch(rs, n=-1)
df

#Import du package XLSX
install.packages("xlsx")
library("xlsx")


#Création du sheet
wb<-createWorkbook(type="xlsx")

#Création de la première feuille du Formulaire, qui correspondra à ce qui s'affiche dans les menus déroulants
sheet <- createSheet(wb, sheetName = "choices")
#Deuxième feuille avec les questions 
sheet2 <- createSheet(wb, sheetName = "survey")

#Visualiser ce qu'on doit avoir grosso modo dans le formulaire 
library(readxl)
data_sheet1 <- read_excel("C:/Users/jbelb/Downloads/XLSForm.xlsx", sheet = 'survey')
data_sheet2 <- read_excel('C:/Users/jbelb/Downloads/XLSForm.xlsx', sheet = 'choices')

#On va créer un data frame contenant ce qu'on voudrait faire apparaitre dans le tableau excel 

#Pour la page survey : 
#Relevant sert à faire apparaitre ou pas une question selon ce que l'on sélectionne avant


v1 <- c('start','end','today','begin group','select_one observateur','select_one enclos','end group','begin group','begin group','select_one marquage','select_one nom','select_one gender','date','select_one nom_0','select_one nom_1','select_one nom_2','select_one nom_3','select_one nom_4','select_one nom_5','select_one nom_6','select_one nom_7','select_one nom_8','select_one nom_9','end group','select_one posture','select_multiple comportement','select_one physique','select_multiple blessure','select_one localisation','select_one feces','select_multiple salissure','select_one secoue','select_one oreille','select_one mouche','end group','begin group','text','text','end group');
v2 <- c('start','end','today','main_group1','observateur','enclos','main_group1','main_group2','single_page','marquage','nom','gender','date','nom_0','nom_1','nom_2','nom_3','nom_4','nom_5','nom_6','nom_7','nom_8','nom_9','single_page','posture','comportement','condition_physique','blessure','localisation','feces','salissure','secoue','oreille','mouche','main_group2','main_group3','description','remarque','main_group3');
v3 <- c(NA,NA,NA,'Section 1',"Selectionnez l'observateur",'Enclos',NA,'Section 2','page','Marquage','Nom','Sexe','Date du jour du relevé','Sélectionnez un animal','Sélectionnez un animal','Sélectionnez un animal','Sélectionnez un animal','Sélectionnez un animal','Sélectionnez un animal','Sélectionnez un animal','Sélectionnez un animal','Sélectionnez un animal','Sélectionnez un animal',NA,'Posture','Comportement','Condition physique','Blessure observé','Localisation de la blessure','Féces','Salissure arrière train','Secoue oreille','De quel côté ?','Mouche/éternue',NA,'Section 3','Description complémentaire ?','Remarque générale?',NA);
v4 <- c(NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA);
v5 <- c(NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA);
v6 <- c(NA,NA,NA,NA,'yes','yes',NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA);
v7 <- c(NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,'${enclos}="zero"','${enclos}="un"','${enclos}="deux"','${enclos}="trois"','${enclos}="quatre"','${enclos}="cinq"','${enclos}="six"','${enclos}="sept"','${enclos}="huit"','${enclos}="neuf"',NA,NA,NA,NA,NA,'not((${blessure}="pas_vu_4" or ${blessure}="aucune"))',NA,NA,NA,'${secoue}="yes"',NA,NA,NA,NA,NA,NA);
v8 <- c(NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA);
v9 <- c(NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA);
v10 <-c(NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA);
v11 <- c(NA,NA,NA,NA,NA,NA,NA,NA,'field-list',NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA);
v12 <-c(NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA);
v13 <-c(NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA);
v14 <-c(NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA);
v15 <-c(NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA);


liste <- list(v1,v2,v3,v4,v5,v6,v7,v8,v9,v10,v11,v12,v13,v14,v15);
tab1 <- data.frame(liste);
colnames(tab1) <- c('type','name','label::French','hint::French','comments','required','relevant','constraint','constraint_message::French','calculation','appearance','choice_filter','repeat_count','media::image','default');
rownames(tab1) <- c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,31,32,33,34,35,36,37,38,39);
tab1

addDataFrame(tab1,sheet2,col.names=TRUE,row.names=TRUE,startRow = 1, startColumn = 1,colStyle = NULL, rownamesStyle = NULL,showNA=FALSE,characterNA = "",byrow = FALSE);

sheet2

#Pour le sheet des choix 

#Je vérifie que les vues existent et que la connexion se fait bien à la base. 
dbReadTable(con,"v_intermediaire_registre")
dbReadTable(con, "individus_total")

#On selectionne les identifiants des enclos dans la base, on les met dans un dataframe 
#Je regarde les noms des enclos 

enclos <- dbSendQuery(con, "SELECT DISTINCT cap_en_sabot FROM individus_total")
df_enclos <- dbFetch(enclos, n=-1)
df_enclos

#De 0 jusqu'à 9 + Ge (avec des sous enclos, on va ignorer ça et faire comme si ils étaient tous dans le même, et donc sortir de 0 à 9 )

#Et les noms des animaux par enclos 
#On change le nom de la colonne en label::French, pour fusionner les df. 
nom_dans_enclos_0 <- dbSendQuery(con, "SELECT DISTINCT ani_nom_registre FROM individus_total WHERE cap_en_sabot = '0' OR cap_en_sabot = '0abc' OR  cap_en_sabot = '0abcd' OR cap_en_sabot = '0b' OR cap_en_sabot = '0def' ")
df_enclos_0 <- dbFetch(nom_dans_enclos_0, n=-1)

nom_dans_enclos_1 <- dbSendQuery(con, "SELECT DISTINCT ani_nom_registre FROM individus_total WHERE cap_en_sabot = '1' OR cap_en_sabot = '1b' OR cap_en_sabot = '1bc' OR cap_en_sabot = '1c' OR cap_en_sabot = '1d' ")
df_enclos_1 <- dbFetch(nom_dans_enclos_1, n=-1)

nom_dans_enclos_2 <- dbSendQuery(con, "SELECT DISTINCT ani_nom_registre FROM individus_total WHERE cap_en_sabot = '2' OR cap_en_sabot = '2b' OR cap_en_sabot = '2e' OR cap_en_sabot = '2 et 2b' ")
df_enclos_2 <- dbFetch(nom_dans_enclos_2, n=-1)

nom_dans_enclos_3 <- dbSendQuery(con, "SELECT DISTINCT ani_nom_registre FROM individus_total WHERE cap_en_sabot = '3' ")
df_enclos_3 <- dbFetch(nom_dans_enclos_3, n=-1)

nom_dans_enclos_4 <- dbSendQuery(con, "SELECT DISTINCT ani_nom_registre FROM individus_total WHERE cap_en_sabot = '4' OR cap_en_sabot = '4c' ")
df_enclos_4 <- dbFetch(nom_dans_enclos_4, n=-1)   

nom_dans_enclos_5 <- dbSendQuery(con, "SELECT DISTINCT ani_nom_registre FROM individus_total WHERE cap_en_sabot = '5' ")
df_enclos_5 <-dbFetch(nom_dans_enclos_5, n=-1)

nom_dans_enclos_6 <- dbSendQuery(con, "SELECT DISTINCT ani_nom_registre FROM individus_total WHERE cap_en_sabot = '6' OR cap_en_sabot = '6a' OR cap_en_sabot = '6ab' OR cap_en_sabot = '6b' OR cap_en_sabot = '6c' ")
df_enclos_6 <- dbFetch(nom_dans_enclos_6, n=-1)

nom_dans_enclos_7 <- dbSendQuery(con, "SELECT DISTINCT ani_nom_registre FROM individus_total WHERE cap_en_sabot = '7' ")
df_enclos_7 <-dbFetch(nom_dans_enclos_7, n=-1)

nom_dans_enclos_8 <- dbSendQuery(con, "SELECT DISTINCT ani_nom_registre FROM individus_total WHERE cap_en_sabot = '8' ")
df_enclos_8 <-dbFetch(nom_dans_enclos_8, n=-1)

nom_dans_enclos_9 <- dbSendQuery(con, "SELECT DISTINCT ani_nom_registre FROM individus_total WHERE cap_en_sabot = '9' ")
df_enclos_9 <-dbFetch(nom_dans_enclos_9, n=-1)

colnames(df_enclos_0)[1] <- 'label::French'
colnames(df_enclos_1)[1] <- 'label::French'
colnames(df_enclos_2)[1] <- 'label::French'
colnames(df_enclos_3)[1] <- 'label::French'
colnames(df_enclos_4)[1] <- 'label::French'
colnames(df_enclos_5)[1] <- 'label::French'
colnames(df_enclos_6)[1] <- 'label::French'
colnames(df_enclos_7)[1] <- 'label::French'
colnames(df_enclos_8)[1] <- 'label::French'
colnames(df_enclos_9)[1] <- 'label::French'

#Boucles pour remplir les deux colonnes restantes des choices (list_name et name)

res_0 <- NULL
l0 <- NULL
n <- nrow(df_enclos_0)
for (i in 0:n) {
  res_0[i] <- 'nom_0'
  l0[i] <- paste('nom0',i)
}

l1 <- NULL
res_1 <- NULL
n1 <- nrow(df_enclos_1)
for (i in 0:n1) {
  res_1[i] <- 'nom_1'
  l1[i] <- paste('nom1',i)
}

l2 <- NULL
res_2 <- NULL
n2 <- nrow(df_enclos_2)
for (i in 0:n2) {
  res_2[i] <- 'nom_2'
  l2[i] <- paste('nom2',i)
}

l3 <-NULL
res_3 <- NULL
n3 <- nrow(df_enclos_3)
for (i in 0:n3) {
  res_3[i] <- 'nom_3'
  l3[i] <- paste('nom3',i)
}

l4 <- NULL
res_4 <- NULL
n4 <- nrow(df_enclos_4)
for (i in 0:n4) {
  res_4[i] <- 'nom_4'
  l4[i] <- paste('nom4',i)
}

l5 <- NULL
res_5 <- NULL
n5 <- nrow(df_enclos_5)
for (i in 0:n5) {
  res_5[i] <- 'nom_5'
  l5[i] <- paste('nom5',i)
}

l6 <- NULL
res_6 <- NULL
n6 <- nrow(df_enclos_6)
for (i in 0:n6) {
  res_6[i] <- 'nom_6'
  l6[i] <- paste('nom6', i)
}

l7 <- NULL
res_7 <- NULL
n7 <- nrow(df_enclos_7)
for (i in 0:n7) {
  res_7[i] <- 'nom_7'
  l7[i] <- paste('nom7', i)
}

l8 <- NULL
res_8 <- NULL
n8 <- nrow(df_enclos_8)
for (i in 0:n8) {
  res_8[i] <- 'nom_8'
  l8[i] <- paste('nom8', i)
}

l9 <- NULL
res_9 <- NULL
n9 <- nrow(df_enclos_9)
for (i in 0:n9) {
  res_9[i] <- 'nom_9'
  l9[i] <- paste('nom9', i)
}

#Les deux colonnes du sheet choices 

list_name <- c(res_0,res_1,res_2,res_3,res_4,res_5,res_6,res_7,res_8,res_9)
tab3 <- data.frame(list_name)
colnames(tab3)[1] <- 'list_name'

name <- c(l0,l1,l2,l3,l4,l5,l6,l7,l8,l9)
tab4 <- data.frame(name)
colnames(tab4)[1] <- 'name'



label_french <- rbind(df_enclos_0,df_enclos_1,df_enclos_2,df_enclos_3,df_enclos_4,df_enclos_5,df_enclos_6,df_enclos_7,df_enclos_8,df_enclos_9)
colnames(label_french)[1] <- 'label::French'
label_french


test <- bind_cols(tab3,tab4,label_french)

#On met les enclos dans un data frame dont on change le nom de la colonne
#On fera par la suite la fusion des dataframe 


df_nom <- dbFetch(nom, n= -1)

colnames(df_nom)[1] <- 'label::French'

#On commence à créer le dataframe du choices 
#(attention vecteurs sans les noms des animaux)



V1 <- c('observateur','observateur','observateur','observateur','observateur','observateur','observateur','enclos','enclos','enclos','enclos','enclos','enclos','enclos','enclos','enclos','enclos','gender','gender','posture','posture','posture','posture','comportement','comportement','comportement','comportement','comportement','comportement','comportement','physique','physique','physique','physique','blessure','blessure','blessure','blessure','blessure','blessure','localisation','localisation','localisation','localisation','localisation','localisation','feces','feces','feces','feces','salissure','salissure','salissure','salissure','secoue','secoue','secoue','oreille','oreille','mouche','mouche','mouche');
V2 <- c('rames','bonnet','cebe','maublanc','ver','merlet','picot','zero','un','deux','trois','quatre','cinq','six','sept','huit','neuf','male','female','pas_vu','mouvement','debout','couche','pas_vu_2','normal','dos_rond','apathie','stereo','voracite','brise_vent','pas_vu_3','normal_2','maigre','gras','pas_vu_4','aucune','boiterie','plaie','absces','oedeme','pas_vu_5','avant_droit','arriere_droit','avant_gauche','arriere_gauche','tete','pas_vu_6','normal_3','boudin','diarrhee','pas_vu_7','propre','anus','pattes','pas_vu_8','yes','no','left','right','pas_vu_9','oui','non');
V3 <- c('Jean-Luc Rames','Arnaud Bonnet','Nicolas Cebe','Marie-Line Maublanc','Hélène Verheyden','Joël Merlet','Denis Picot','0','1','2','3','4','5','6','7','8','9','Mâle','Femelle','Pas vu','Mouvement','Debout','Couché','Pas vu','Normal','Dos rond','Apathie','Stéréotypie','Voracité','Mange le brise vent','Pas vu ','Normal','Maigre','Gras','Pas vu','Aucune','Boiterie','Plaie','Abscès','Oedème','Pas vu','Avant droit','Arrière droit','Avant gauche','Arrière gauche','Tête','Pas vu','Normal','Boudin mou','Diarrhée','Pas vu','Propre','Anus souillé','Pattes souillées','Pas vu','Oui','Non','Gauche','Droite','Pas vu','Oui','Non')



liste2 <- list(V1,V2,V3);
tab2 <- data.frame(liste2);
colnames(tab2) <- c('list_name','name','label::French');






#Noms par enclos, 10 list_name, un par enclos
#Pour fusionner les df : http://www.sthda.com/french/wiki/fusion-des-donnees-avec-r

df_choices <- rbind(tab2,test)


#On ajoute le sheet des choix dans le worbook

addDataFrame(df_choices,sheet,col.names=TRUE,row.names=TRUE,startRow = 1, startColumn = 1,colStyle = NULL, rownamesStyle = NULL,showNA=FALSE,characterNA = "",byrow = FALSE);



#ToDo par ordre de priorité : 1 ) Pour le marquage, créer une procédure postgresql 
#La procédure prend le nom de l'animal qui a été sélectionné et sort son marquage (presque OK)
#2) Finioler les derniers détails du excel et tester sur tablette la v finale
# 3) automatisation des csv qui vont aller dans la base (script en R, presque OK)
#4) : Les alertes ??? Potentiellement les inclure dans le formulaire, trouver une façon de contourner le fonctionnement usuel de ODK 











#On enregistre le worbook et on le télécharge ! 

saveWorkbook(wb, "XLSForm_v2.xlsx")

