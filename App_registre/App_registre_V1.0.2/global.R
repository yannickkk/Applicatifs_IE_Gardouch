
#------------------------------------TITRE--------------------------------------
#  Auteur: Yannick Chaval, INRAE (French National Research Institute for Agriculture, Food and Environment), CEFS (Wildlife, Behaviour and Ecology Research Unit)
#  Date:  06/10/2021
#  version 1.0.2
#  modification: ajout de l'enclos d'entrée en champ mandataire. Lorsque l'animal est nouveau, ce champ crée l'association animal/enclos dans t_asso_ani_enc_aae
#  Description:
#  Documentation:
#
#
#
#
#
#------------------------------------------------------------------------------

#####auto install packages
mypackages<-c("xlsx","shiny", "RPostgreSQL", "lubridate","shinyjs","shinyalert","data.table", "shinyBS", "shinycssloaders","shinybusy","knitr", "kableExtra","DT")
for (p in mypackages){
  if(!require(p, character.only = TRUE)){
    install.packages(p)
    library(p, character.only = TRUE)
  }
}

devtools::source_url("https://github.com/yannickkk/mes_fonctions/blob/main/fonctions_sans_connect.R?raw=TRUE")

source("C:/Users/ychaval/Documents/BD_Gardouch/Programmes/R/structure_actuelle/con_local_db_gardouch.R")
con<-local_gardouch
#####define mandatory fields
fieldsMandatory <- c("login","ani_nom_registre", "ani_n_inra", "ani_sexe", "ani_vient_de", "ani_local","ani_date_arrivee","enclos_entree") #

#####actuellement il n'y a que des chevreuils dans l'installation, j'ai désactivé le sélecteur d'espèce dans l'UI pour pouvoir mettre l'enclos d'entrée
#ani_espece_id<<-"chevreuil"

#####define fields to export into the csv file and to update in db
champsregistre<-append(utf8(dbGetQuery(con,"select var_name_short from  main.tr_variable_var, list.tr_var_domain_level_1_dl1 where dl1_id = var_dl1_id  and dl1_domain_name = 'registre' "))[,1],"enclos_entree")
ani_age<-grep("ani_age",champsregistre)
ani_vivant<-grep("ani_vivant",champsregistre)
fieldsAll <- champsregistre[-c(ani_age,ani_vivant)]


#####function to remove all blank space in responses
noblank<- function(fi) {gsub("[[:space:]]", "", fi)} 

####define refresh time
autoInvalidate <- reactiveTimer(5000)

####function to designate a mandatory label: use labelMandatory() in front of the name of the field to designate it as mandatory
labelMandatory <- function(label) {
  tagList(
    label,
    span("*", class = "mandatory_star")
  )
}

####css to have a red star near mandatory (obligatory) fields
appCSS <-".mandatory_star { color: red; }"

####j'initialise l'affichage des données
registre<<-utf8(as.data.frame(dbGetQuery(con,paste0("SELECT * from registre_gardouch"))))[,2:24]
