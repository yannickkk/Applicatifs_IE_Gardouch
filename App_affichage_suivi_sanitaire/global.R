#------------------------------------VISUALISATION DU SUIVI SANITAIRE--------------------------------------
#  Auteur: Yannick Chaval, INRAE (French National Research Institute for Agriculture, Food and Environment), CEFS (Wildlife, Behaviour and Ecology Research Unit)
#  Date:  29/09/2022
# Version: 1.0.0
# Description: permet de visualiser le suivi sanitaire.
# Documentation:
#
#
#
#
#
#------------------------------------------------------------------------------
#-------------------------- environnement de travail --------------------------
mypackages<-c("lubridate","RPostgreSQL","data.table", "shiny","shinyjs","shinyalert","shinyBS")
for (p in mypackages){
if(!require(p, character.only = TRUE)){
install.packages(p)
library(p, character.only = TRUE)
}
}
#-----------------------------------------------------------------------------
#-------------------------- chargement de mes fonctions ----------------------
source("scripts/fonctions.R")
#-------------------------- connection aux bases de donnees ------------------
#source("C:/Users/ychaval/Documents/BD_CEFS/con_raspi_dbchevreuils.R")
#source("C:/Users/ychaval/Documents/BD_CEFS/con_raspi_dbchevreuils.R"))
#source("C:/Users/ychaval/Documents/BD_CEFS/con_serveur_dbcefs.R")
#source("C:/Users/ychaval/Documents/BD_CEFS/con_localhost_dbcefs.R")

source("C:/Users/ychaval/Documents/BD_Gardouch/Programmes/R/structure_actuelle/con_server_db_gardouch.R")
con<<-serveur_gardouch

#source("C:/Users/ychaval/Documents/BD_MOVIT/con_serveur_dbmovit.R")
#source("C:/Users/ychaval/Documents/BD_bouquetins/Programmes/R/con_serveur_dbbouquetins.R")
#-------------------------- definition lambert93 :from https://epsg.io/2154 OGC WKT----------------------
#usage##geojsonsf::geojson_sf(file,wkt = wkt, input = inp)
#pour avoir un code sql prêt à coller dans DBeaver: gsub("[\r\n]", " ",paste0(""))
#con<<-serveur_gardouch
sanitaire<<-utf8(as.data.frame(dbGetQuery(con,paste0("SELECT numero_inrae, nom_registre, obs_date, nom_experimentateur, sui_blessure, sui_blessure_remarque, sui_comportement, sui_comportement_remarque, sui_condition_physique, sui_condition_physique_remarque, sui_localisation_blessure, sui_localisation_blessure_remarque, sui_mouche_eternue, sui_mouche_eternue_remarque, sui_observations_complementaires, sui_observations_complementaires_remarque, sui_photos, sui_photos_remarque, sui_posture, sui_posture_remarque, sui_remarque_generale, sui_remarque_generale_remarque, sui_salissure_arriere_train, sui_salissure_arriere_train_remarque, sui_secoue_oreillle, sui_secoue_oreillle_droite_remarque, sui_secoue_oreillle_droite, sui_secoue_oreillle_gauche_remarque, sui_secoue_oreillle_gauche, sui_secoue_oreillle_remarque, sui_texture_feces, sui_texture_feces_remarque, sui_videos, sui_videos_remarque
    FROM public.suivi_sanitaire;"))))