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
mypackages<-c("shinybusy","lubridate","RPostgreSQL","data.table", "shiny","shinyjs","shinyalert","shinyBS")
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
#source("C:/Users/ychaval/Documents/BD_MOVIT/con_serveur_dbmovit.R")
#source("C:/Users/ychaval/Documents/BD_bouquetins/Programmes/R/con_serveur_dbbouquetins.R")
#-------------------------- definition lambert93 :from https://epsg.io/2154 OGC WKT----------------------
#usage##geojsonsf::geojson_sf(file,wkt = wkt, input = inp)
#pour avoir un code sql prêt à coller dans DBeaver: gsub("[\r\n]", " ",paste0(""))
#con<<-serveur_gardouch

source("C:/Users/ychaval/Documents/BD_Gardouch/Programmes/R/structure_actuelle/con_server_db_gardouch.R")
con<<-serveur_gardouch

#####define mandatory fields
fieldsMandatory <- c("login","nom_registre", "obs_date")

####function to designate a mandatory label: use labelMandatory() in front of the name of the field to designate it as mandatory
labelMandatory <- function(label) {
  tagList(
    label,
    span("*", class = "mandatory_star")
  )
}

####css to have a red star near mandatory (obligatory) fields
appCSS <-".mandatory_star { color: red; }"

###champ à mettre à jour dans la bdd

fieldsAll <-c("obs_date", "observateur_copro", "capillaria", "coccidies", "dictyocaules", "echinostomida", "haemonchus_contortus", "moniezia", "nematodirus", "oxyures", "strongles_gastro_intestinaux", "strongyloidess_papillosus", "trichuris_ovis")

