
library(httr) # Pour effectuer la requete HTTP sur l'API de Kobotoolbox
library(jsonlite) # Pour convertir les données de JSON au format dataframe de R
library(tidyverse) # Pour la manibulation des données
library(readr) #Pour ouvrir un csv
library(openxlsx) #Pour écrire dans un fichier excel
library("RPostgreSQL")



#Documentation  
#https://kf.kobotoolbox.org/api/v2/assets/
#https://humanitarian-user-group.github.io/post/kobo_restapi/
#https://knsamati.netlify.app/2020/01/03/utiliser-r-et-python-pour-se-connecter-%C3%A0-lapi-de-kobotoolbox-odk-afin-dautomatiser-ces-resultats/
#https://github.com/ppsapkota/kobohrtoolbox/blob/master/R/r_func_ps_kobo_utils.R#L3
#Le plus important : https://support.kobotoolbox.org/api.html

#On va récupérer les données envoyés depuis l'application


#On requête Kobo avec les identifiants (possiblité de changer, format id, pw)
#On récupère l'identifiant du dernier formulaire envoyé dans kobotoolbox
#raw_infos <- GET(url = "https://kf.kobotoolbox.org/api/v2/assets/",authenticate("jasmine_b","jaja2411"))
source("C:/Users/ychaval/Documents/Collegues/Etudiants/BELBOUAB_Jasmine/Programmes/R/ids.R")
raw_infos <- GET(url = "https://kf.kobotoolbox.org/api/v2/assets/",authenticate(user,password))

#On vérifie que la requête soit passée (code 200 )
print(paste0("Status Code: ",raw_infos$status_code))
str(raw_infos)

#On récupère les données et notamment l'uid du dernier formulaire. 
infos_content = fromJSON(rawToChar(raw_infos$content))
names(infos_content)

data_uid = infos_content$results$uid[1]


#On requête kobo pour avoir les données envoyés dans les formulaires 
url = paste("https://kf.kobotoolbox.org/api/v2/assets", data_uid, "data", sep = "/")

#raw_data <- GET(url = url ,authenticate("jasmine_b","jaja2411"))
raw_data <- GET(url = url ,authenticate(user, password))
print(paste0("Status Code: ",raw_data$status_code))
str(raw_data)

#On récupère les données (elles sont récupérés en json, on veut pouvoir les lire)
data_content = fromJSON(rawToChar(raw_data$content))
names(data_content)
#On a une vue d'ensemble 
View(data_content)


#Reste à selectionner les données et les entrer dans la base pg
#Dans un premier temps, il faudra associer le nom de l'animal sélectionné (qui est sous forme d'id) à un nom précis d'animal dans la base
#Ensuite on entre les données associés à l'animal dans la base 


drv <- dbDriver("PostgreSQL")
#On fait la connexion à la base, toujours possible de changer 
con <- dbConnect(drv, dbname = "db_gardouch",
                 host = "pggeodb.nancy.inrae.fr", port = 5432,
                 user = "jbelbouab", password = "belbouabj",
                 options="-c search_path=main,public,animals")


blessure <- data_content$results$`main_group2/blessure`
description <- data_content$results$`main_group3/description`
secoue_oreille <- data_content$results$`main_group2/secoue`
feces <- data_content$results$`main_group2/feces`
comportement <- data_content$results$`main_group2/comportement`
localisation <- data_content$results$`main_group2/localisation`
posture <- data_content$results$`main_group2/posture`
date_releve <- data_content$results$`main_group2/single_page/date`
remarque <- data_content$results$`main_group3/remarque`
salissure <- data_content$results$`main_group2/salissure`
observateur <- data_content$results$`main_group1/observateur`
cote_oreille <- data_content$results$`main_group2/oreille`
mouche_eternue <- data_content$results$`main_group2/mouche`
condition_physique <- data_content$results$`main_group2/condition_physique`
enclos <- data_content$results$`main_group1/enclos`

global_result<- as.data.frame(NULL)


##########recuperation des donnees globales
source("C:/Users/ychaval/Documents/Collegues/Etudiants/BELBOUAB_Jasmine/Programmes/R/ids.R")
raw_infos <- GET(url = "https://kf.kobotoolbox.org/api/v2/assets/",authenticate(user,password))
infos_content <- fromJSON(rawToChar(raw_infos$content))
data_uid <- infos_content$results$uid
url = paste("https://kf.kobotoolbox.org/api/v2/assets", data_uid, "data", sep = "/")
raw_data <- GET(url = url ,authenticate(user, password))
data_content <- fromJSON(rawToChar(raw_data$content))$results
