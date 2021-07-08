#------------------------------------TITRE--------------------------------------
#  Auteur: Yannick Chaval, INRAE (French National Research Institute for Agriculture, Food and Environment), CEFS (Wildlife, Behaviour and Ecology Research Unit)
#  Date:  23/03/2021
#  Description:
# Documentation:
# https://github.com/daattali/timevis
# pour mes options de timevis voir: https://visjs.github.io/vis-timeline/docs/timeline/#Configuration_Options
# https://rdrr.io/cran/timevis/man/timevis.html
#
#
#
#------------------------------------------------------------------------------
#-------------------------- environnement de travail --------------------------
mypackages<-c("htmlwidgets","utf8","shiny", "shinyjs","timevis","reshape","dplyr","tidyverse","tidyr","DT","lubridate","RPostgreSQL","data.table")
for (p in mypackages){
  if(!require(p, character.only = TRUE)){
    install.packages(p)
    library(p, character.only = TRUE)
  }
}
#-----------------------------------------------------------------------------
#-------------------------- connection aux bases de donnees ------------------
#source("C:/Users/ychaval/Documents/BD_CEFS/con_raspi_dbchevreuils.R")
#source("C:/Users/ychaval/Documents/BD_CEFS/con_raspi_dbchevreuils.R"))
#source("C:/Users/ychaval/Documents/BD_CEFS/con_serveur_dbcefs.R")
source("C:/Users/ychaval/Documents/BD_Gardouch/Programmes/R/con_serveur_dbgardouch.R")
#gar_serveur<- dbConnect(PostgreSQL(), host="localhost", dbname="db_gardouch", port=5432, user="postgres", password="postgres")

#-------------------------- chargement de mes fonctions ----------------------
source("C:/Users/ychaval/Documents/BD_tools/Mes_fonctions_R/fonctions.R")


#install.packages("timevis")
# data <- utf8(dbGetQuery(gar_serveur,"SELECT \"row.names\" as id, anen_date_begin as start, anen_date_end as end, concat('<h2>',anen_enc_name,'</h2>') as content,'color: black;' as style, ind_name as group, 'range' as type FROM tmp_animal_enclosure_anen
#                     "))

data <- utf8(dbGetQuery(gar_serveur,"SELECT aae_id as id,aae_date_debut as start, aae_date_fin as end, concat('<h2>',enc_name,'</h2>') as content,'color: black;' as style, nom_registre as group,'range' as type,aae_remark remarque FROM public.histoire_de_vie"))


#data<-data[c(11:dim(data)[1]),]
#data<-data[c(1:89),]

presents<<-unique(data[which(is.na(data$end)), "group"])
data[which(is.na(data$end)), "end"]<- as.character(ymd(Sys.Date()))


datae<-data
datae$temp<-data$group
datae$group<-gsub("</h2>","",gsub("<h2>","",data$content))
datae$content<- paste0("<h2>",datae$temp,"</h2>")
datae<-datae[order(datae$group), ]
