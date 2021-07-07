
#Export des librairies 
library("RPostgreSQL")
library('dplyr')
library('xlsx')


########fonction qui permet d'eviter les problemes avec les accents (pour un df)
utf8 <- function(x) {
  # Declare UTF-8 encoding on all character columns:
  chr <- sapply(x, is.character)
  x[, chr] <- lapply(x[, chr, drop = FALSE], `Encoding<-`, "UTF-8")
  # Same on column names:
  Encoding(names(x)) <- "UTF-8"
  return(x)
}

#Creation du fichier Excel ###eviter les accents et parler soit french soit anglais (c'est mieux il n'y a pas d'accent et c'est echangeable avec d'autres)
wb<-createWorkbook(type="xlsx")

#Creation de la premiere feuille du Formulaire, qui correspond e ce qui s'affiche dans les menus deroulants
sheet <- createSheet(wb, sheetName = "choices")
#Deuxieme feuille avec les questions (toujours formalise sous forme de formulaire pris en charge par ODK)
sheet2 <- createSheet(wb, sheetName = "survey")

drv <- dbDriver("PostgreSQL")
# creation de la connexion
# on va utiliser con
# on connecte directement la base de l'Installation expérimentale de Gardouch (possible de changer user et pw)
con <- dbConnect(drv, dbname = "db_gardouch",
                 host = "pggeodb.nancy.inrae.fr", port = 5432,
                 user = "xxxxx", password = "xxxxx",
                 options="-c search_path=main,public,animals")


#Verification des noms des enclos

res <- dbSendQuery(con, "SELECT DISTINCT enc_name FROM histoire_de_vie")
enclos <- utf8(dbFetch(res, n=-1))
enclos
#YC##########plus rapidement
enclos<-utf8(dbGetQuery(con, "SELECT DISTINCT enc_name FROM histoire_de_vie"))

#Enclos de 0 e 9, on met dans des dataframes differents

nom_dans_enclos_0 <- dbSendQuery(con, "SELECT DISTINCT nom_registre FROM histoire_de_vie WHERE enc_name LIKE'0%' AND aae_date_fin IS NULL ")
df_enclos_0 <- utf8(dbFetch(nom_dans_enclos_0, n=-1))
#YC###de meme
df_enclos_0 <- utf8(dbGetQuery(con, "SELECT DISTINCT nom_registre FROM histoire_de_vie WHERE enc_name LIKE'0%' AND aae_date_fin IS NULL "))

nom_dans_enclos_1 <- dbSendQuery(con, "SELECT DISTINCT nom_registre FROM histoire_de_vie WHERE enc_name LIKE'1%' AND aae_date_fin IS NULL ")
df_enclos_1 <- utf8(dbFetch(nom_dans_enclos_1, n=-1))

nom_dans_enclos_2 <- dbSendQuery(con, "SELECT DISTINCT nom_registre FROM histoire_de_vie WHERE enc_name LIKE'2%' AND aae_date_fin IS NULL ")
df_enclos_2 <- utf8(dbFetch(nom_dans_enclos_2, n=-1))

nom_dans_enclos_3 <- dbSendQuery(con, "SELECT DISTINCT nom_registre FROM histoire_de_vie WHERE enc_name LIKE'3%' AND aae_date_fin IS NULL ")
df_enclos_3 <- utf8(dbFetch(nom_dans_enclos_3, n=-1))

nom_dans_enclos_4 <- dbSendQuery(con, "SELECT DISTINCT nom_registre FROM histoire_de_vie WHERE enc_name LIKE'4%' AND aae_date_fin IS NULL ")
df_enclos_4 <- utf8(dbFetch(nom_dans_enclos_4, n=-1))

nom_dans_enclos_5 <- dbSendQuery(con, "SELECT DISTINCT nom_registre FROM histoire_de_vie WHERE enc_name LIKE'5%' AND aae_date_fin IS NULL ")
df_enclos_5 <- utf8(dbFetch(nom_dans_enclos_5, n=-1))

nom_dans_enclos_6 <- dbSendQuery(con, "SELECT DISTINCT nom_registre FROM histoire_de_vie WHERE enc_name LIKE'6%' AND aae_date_fin IS NULL ")
df_enclos_6 <- utf8(dbFetch(nom_dans_enclos_6, n=-1))

nom_dans_enclos_7 <- dbSendQuery(con, "SELECT DISTINCT nom_registre FROM histoire_de_vie WHERE enc_name LIKE'7%' AND aae_date_fin IS NULL ")
df_enclos_7 <- utf8(dbFetch(nom_dans_enclos_7, n=-1))

nom_dans_enclos_8 <- dbSendQuery(con, "SELECT DISTINCT nom_registre FROM histoire_de_vie WHERE enc_name LIKE'8%' AND aae_date_fin IS NULL ")
df_enclos_8 <- utf8(dbFetch(nom_dans_enclos_8, n=-1))

nom_dans_enclos_9 <- dbSendQuery(con, "SELECT DISTINCT nom_registre FROM histoire_de_vie WHERE enc_name LIKE'9%' AND aae_date_fin IS NULL ")
df_enclos_9 <- utf8(dbFetch(nom_dans_enclos_9, n=-1))

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
for (i in 0:n) {    ###YC####quelle est l'interet de faire partir la boucle de zero....pourquoi pas de 1
  res_0[i] <- 'nom_0'
  l0[i] <- dbGetQuery(con, paste0("SELECT ind_id FROM main.v_intermediaire_registre, histoire_de_vie WHERE ani_n_inra = n_inra and ani_nom_registre = '",df_enclos_0[,1][i],"' and enc_name LIKE'0%' AND aae_date_fin IS NULL "))
}

l1 <- NULL
res_1 <- NULL
n1 <- nrow(df_enclos_1)
for (i in 0:n1) {
  res_1[i] <- 'nom_1'
  l1[i] <- dbGetQuery(con, paste0("SELECT ind_id FROM main.v_intermediaire_registre, histoire_de_vie WHERE ani_n_inra = n_inra and ani_nom_registre = '",df_enclos_1[,1][i],"' and enc_name LIKE'1%' AND aae_date_fin IS NULL "))
}

l2 <- NULL
res_2 <- NULL
n2 <- nrow(df_enclos_2)
for (i in 0:n2) {
  res_2[i] <- 'nom_2'
  l2[i] <- dbGetQuery(con, paste0("SELECT ind_id FROM main.v_intermediaire_registre, histoire_de_vie WHERE ani_n_inra = n_inra and ani_nom_registre = '",df_enclos_2[,1][i],"' and enc_name LIKE'2%' AND aae_date_fin IS NULL "))
}

l3 <-NULL
res_3 <- NULL
n3 <- nrow(df_enclos_3)
for (i in 0:n3) {
  res_3[i] <- 'nom_3'
  l3[i] <- dbGetQuery(con, paste0("SELECT ind_id FROM main.v_intermediaire_registre, histoire_de_vie WHERE ani_n_inra = n_inra and ani_nom_registre = '",df_enclos_3[,1][i],"' and enc_name LIKE'3%' AND aae_date_fin IS NULL "))
}

l4 <- NULL
res_4 <- NULL
n4 <- nrow(df_enclos_4)
for (i in 0:n4) {
  res_4[i] <- 'nom_4'
  l4[i] <- dbGetQuery(con, paste0("SELECT ind_id FROM main.v_intermediaire_registre, histoire_de_vie WHERE ani_n_inra = n_inra and ani_nom_registre = '",df_enclos_4[,1][i],"' and enc_name LIKE'4%' AND aae_date_fin IS NULL "))
}

l5 <- NULL
res_5 <- NULL
n5 <- nrow(df_enclos_5)
for (i in 0:n5) {
  res_5[i] <- 'nom_5'
  l5[i] <- dbGetQuery(con, paste0("SELECT ind_id FROM main.v_intermediaire_registre, histoire_de_vie WHERE ani_n_inra = n_inra and ani_nom_registre = '",df_enclos_5[,1][i],"' and enc_name LIKE'5%' AND aae_date_fin IS NULL "))
}

l6 <- NULL
res_6 <- NULL
n6 <- nrow(df_enclos_6)
for (i in 0:n6) {
  res_6[i] <- 'nom_6'
  l6[i] <- dbGetQuery(con, paste0("SELECT ind_id FROM main.v_intermediaire_registre, histoire_de_vie WHERE ani_n_inra = n_inra and ani_nom_registre = '",df_enclos_6[,1][i],"' and enc_name LIKE'6%' AND aae_date_fin IS NULL "))
}

l7 <- NULL
res_7 <- NULL
n7 <- nrow(df_enclos_7)
for (i in 0:n7) {
  res_7[i] <- 'nom_7'
  l7[i] <- dbGetQuery(con, paste0("SELECT ind_id FROM main.v_intermediaire_registre, histoire_de_vie WHERE ani_n_inra = n_inra and ani_nom_registre = '",df_enclos_7[,1][i],"' and enc_name LIKE'7%' AND aae_date_fin IS NULL "))
}

l8 <- NULL
res_8 <- NULL
n8 <- nrow(df_enclos_8)
for (i in 0:n8) {
  res_8[i] <- 'nom_8'
  l8[i] <- dbGetQuery(con, paste0("SELECT ind_id FROM main.v_intermediaire_registre, histoire_de_vie WHERE ani_n_inra = n_inra and ani_nom_registre = '",df_enclos_8[,1][i],"' and enc_name LIKE'8%' AND aae_date_fin IS NULL "))
}

l9 <- NULL
res_9 <- NULL
n9 <- nrow(df_enclos_9)
for (i in 0:n9) {
  res_9[i] <- 'nom_9'
  l9[i] <- dbGetQuery(con, paste0("SELECT ind_id FROM main.v_intermediaire_registre, histoire_de_vie WHERE ani_n_inra = n_inra and ani_nom_registre = '",df_enclos_9[,1][i],"' and enc_name LIKE'9%' AND aae_date_fin IS NULL "))
}

#Les deux colonnes du sheet choices (specifiquement demande par ODK) 

list_name <- c(res_0,res_1,res_2,res_3,res_4,res_5,res_6,res_7,res_8,res_9)
tab3 <- data.frame(list_name)
colnames(tab3)[1] <- 'list_name'

name <- c(l0,l1,l2,l3,l4,l5,l6,l7,l8,l9)
tab4 <- data.frame(unlist(name))
colnames(tab4)[1] <- 'name'



label_french <- rbind(df_enclos_0,df_enclos_1,df_enclos_2,df_enclos_3,df_enclos_4,df_enclos_5,df_enclos_6,df_enclos_7,df_enclos_8,df_enclos_9)
colnames(label_french)[1] <- 'label::French'
label_french

#On met les trois colonnes dans un dataframe 

test <- bind_cols(tab3,tab4,label_french)


res_sexe_marquage <- data.frame(NULL)

for (i in 1:dim(tab4)[1]){
res <- utf8(dbGetQuery(con, paste0("SELECT ani_sexe sexe, cap_collier marquage FROM individus_total WHERE ind_id = ",tab4[,1][i]," order by obs_date DESC"))[1,])
res_sexe_marquage <- rbind(res_sexe_marquage,res)
}
#df_marquage <- dbFetch(res_marquage, n=-1)
df_marquage



#Vecteurs avec les variables qui vont potentiellement pas bouger 
#A voir si il faut sortir les noms des observateurs via la base e C'est possible

V1 <- c('observateur','observateur','observateur','observateur','observateur','observateur','observateur','enclos','enclos','enclos','enclos','enclos','enclos','enclos','enclos','enclos','enclos','gender','gender','posture','posture','posture','posture','comportement','comportement','comportement','comportement','comportement','comportement','comportement','physique','physique','physique','physique','blessure','blessure','blessure','blessure','blessure','blessure','localisation','localisation','localisation','localisation','localisation','localisation','feces','feces','feces','feces','salissure','salissure','salissure','salissure','secoue','secoue','secoue','oreille','oreille','mouche','mouche','mouche');
V2 <- c('rames','bonnet','cebe','maublanc','ver','merlet','picot','zero','un','deux','trois','quatre','cinq','six','sept','huit','neuf','male','female','pas_vu','mouvement','debout','couche','pas_vu_2','normal','dos_rond','apathie','stereo','voracite','brise_vent','pas_vu_3','normal_2','maigre','gras','pas_vu_4','aucune','boiterie','plaie','absces','oedeme','pas_vu_5','avant_droit','arriere_droit','avant_gauche','arriere_gauche','tete','pas_vu_6','normal_3','boudin','diarrhee','pas_vu_7','propre','anus','pattes','pas_vu_8','yes','no','left','right','pas_vu_9','oui','non');
V3 <- c('Jean-Luc Rames','Arnaud Bonnet','Nicolas Cebe','Marie-Line Maublanc','Helene Verheyden','Joel Merlet','Denis Picot','0','1','2','3','4','5','6','7','8','9','Male','Femelle','Pas vu','Mouvement','Debout','Couche','Pas vu','Normal','Dos rond','Apathie','Stereotypie','Voracite','Mange le brise vent','Pas vu ','Normal','Maigre','Gras','Pas vu','Aucune','Boiterie','Plaie','Absces','Oedeme','Pas vu','Avant droit','Arriere droit','Avant gauche','Arriere gauche','Tete','Pas vu','Normal','Boudin mou','Diarrhee','Pas vu','Propre','Anus souille','Pattes souillees','Pas vu','Oui','Non','Gauche','Droite','Pas vu','Oui','Non')

liste2 <- list(V1,V2,V3);
tab2 <- data.frame(liste2);
colnames(tab2) <- c('list_name','name','label::French');

#Fusion des df 'statiques' et des df qui prennent les infos dans la base 

df_choices <- rbind(tab2,test)


#On ajoute le sheet des choix dans le worbook

addDataFrame(df_choices,sheet,col.names=TRUE,row.names=TRUE,startRow = 1, startColumn = 1,colStyle = NULL, rownamesStyle = NULL,showNA=FALSE,characterNA = "",byrow = FALSE);

#On va creer un data frame contenant ce qu'on voudrait faire apparaitre dans le tableau excel 

#Pour la page survey : 
#Relevant sert e faire apparaitre ou pas une question selon ce que l'on selectionne avant


v1 <- c('start','end','today','begin group','select_one observateur','select_one enclos','end group','begin group','begin group','select_one gender','date','select_one nom_0','select_one nom_1','select_one nom_2','select_one nom_3','select_one nom_4','select_one nom_5','select_one nom_6','select_one nom_7','select_one nom_8','select_one nom_9','end group','select_one posture','select_multiple comportement','select_one physique','select_multiple blessure','select_one localisation','select_one feces','select_multiple salissure','select_one secoue','select_one oreille','select_one mouche','end group','begin group','text','text','end group');
v2 <- c('start','end','today','main_group1','observateur','enclos','main_group1','main_group2','single_page','gender','date','nom_0','nom_1','nom_2','nom_3','nom_4','nom_5','nom_6','nom_7','nom_8','nom_9','single_page','posture','comportement','condition_physique','blessure','localisation','feces','salissure','secoue','oreille','mouche','main_group2','main_group3','description','remarque','main_group3'); 
v3 <- c(NA,NA,NA,'Section 1',"Selectionnez l'observateur",'Enclos',NA,'Section 2','page','Sexe','Date du jour du releve','Selectionnez un animal','Selectionnez un animal','Selectionnez un animal','Selectionnez un animal','Selectionnez un animal','Selectionnez un animal','Selectionnez un animal','Selectionnez un animal','Selectionnez un animal','Selectionnez un animal',NA,'Posture','Comportement','Condition physique','Blessure observe','Localisation de la blessure','Feces','Salissure arriere train','Secoue oreille','De quel cete e','Mouche/eternue',NA,'Section 3','Description complementaire e','Remarque generalee',NA);
v4 <- rep(NA,length(v1))##YC## pour v4,v5,v8,v9,v10,v12,v13,14,15 faire rep(NA,length(v1)) ####l'avantage est que c'est moins long a ecrire et que si v1 change de longueur ce n'est pas un probleme
v5 <- c(NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA);
v6 <- c(NA,NA,NA,NA,'yes','yes',NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA);
v7 <- c(NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,'${enclos}="zero"','${enclos}="un"','${enclos}="deux"','${enclos}="trois"','${enclos}="quatre"','${enclos}="cinq"','${enclos}="six"','${enclos}="sept"','${enclos}="huit"','${enclos}="neuf"',NA,NA,NA,NA,NA,'not((${blessure}="pas_vu_4" or ${blessure}="aucune"))',NA,NA,NA,'${secoue}="yes"',NA,NA,NA,NA,NA,NA);
v8 <- c(NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA);
v9 <- c(NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA);
v10 <-c(NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA);
v11 <- c(NA,NA,NA,NA,'minimal','minimal',NA,NA,'field-list','minimal',NA,'minimal','minimal','minimal','minimal','minimal','minimal','minimal','minimal','minimal','minimal',NA,'minimal','minimal','minimal','minimal','minimal','minimal','minimal','minimal','minimal','minimal',NA,NA,NA,NA,NA);
v12 <-c(NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA);
v13 <-c(NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA);
v14 <-c(NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA);
v15 <-c(NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA);
###YC##les ; en fin de ligne ne servent a rien

liste <- list(v1,v2,v3,v4,v5,v6,v7,v8,v9,v10,v11,v12,v13,v14,v15);
tab1 <- data.frame(liste);
##yc###tab1<- as.data.frame(cbind(v1,v2,v3,v4,v5,v6,v7,v8,v9,v10,v11,v12,v13,v14,v15))
colnames(tab1) <- c('type','name','label::French','hint::French','comments','required','relevant','constraint','constraint_message::French','calculation','appearance','choice_filter','repeat_count','media::image','default');
rownames(tab1) <- c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37);
##YC## rownames(tab1) <- seq(1,dim(tab1)[1],1)


tab1

addDataFrame(tab1,sheet2,col.names=TRUE,row.names=TRUE,startRow = 1, startColumn = 1,colStyle = NULL, rownamesStyle = NULL,showNA=FALSE,characterNA = "",byrow = FALSE);

sheet2


#ToDo par ordre de priorite : 1 ) Pour le marquage, creer une procedure postgresql 
#La procedure prend le nom de l'animal qui a ete selectionne et sort son marquage (presque OK)
#On prend la colonne cap_collier et on selectionne le maximum 
#2) Finioler les derniers details du excel et tester sur tablette la v finale
# 3) automatisation des csv qui vont aller dans la base (script en R, presque OK)
#4) : Les alertes eee Potentiellement les inclure dans le formulaire, trouver une faeon de contourner le fonctionnement usuel de ODK 




#On enregistre le worbook et on le telecharge 

saveWorkbook(wb, "XLSForm_v2_2.xlsx")


##########a continuer, l'idee est de faire l'appli a partir d'un fichier excel, puis de lire l'app avec R, refaire les mises a jour d'enclos et resortir le fichier excel
# library('xlsx')
# library(openxlsx)
# setwd("C:/Users/ychaval/Documents/Collegues/Etudiants/BELBOUAB_Jasmine/Programmes/R/Gardouch_suivi_sanitaire")
# 
# choices<-readWorkbook("XLSForm_v2_2.xlsx", sheet = 1)
# survey<-readWorkbook("XLSForm_v2_2.xlsx", sheet = 2)
# XLSForm_v2_2
