

##########a continuer, l'idee est de faire l'appli a partir d'un fichier excel, puis de lire l'app avec R, refaire les mises a jour d'enclos et resortir le fichier excel
library("xlsx")
library("RPostgreSQL")
library("httr")
library("jsonlite")
library("tidyr")
library("curl")

setwd("C:/Users/ychaval/Documents/Collegues/Etudiants/BELBOUAB_Jasmine/Programmes/R/save/")
devtools::source_url("https://github.com/yannickkk/mes_fonctions/blob/main/fonctions_sans_connect.R?raw=TRUE")

source("C:/Users/ychaval/Documents/BD_Gardouch/Programmes/R/con_serveur_dbgardouch.R")
if (exists("gar_serveur")){con<-gar_serveur; rm(gar_serveur)}
####fonction permettant de générer les conditions d'affichage du sexe
select_ind<-function(data_ind, enc,ind_enc,sexe){
  if (sexe == "male") {data_indi<- data_ind[data_ind$ani_sexe == "M",]} else if (sexe == "femelle") {data_indi<- data_ind[data_ind$ani_sexe == "F",]}
  res<-NULL
  for (j in 1:length(enc)) {
    ind_enc<-data_indi[data_indi$enc_name == enc[j], "ind_id"]
    if (length(ind_enc) != 0) {
      for (k in 1:length(ind_enc)){
        if (!is.na(ind_enc[k]) & !is.null(ind_enc[k])) {
          res<-append(res,paste0("${nom_",enc[j],"}= ",ind_enc[k],""))}
      }}
  }
  res<-paste0(res, collapse = " or ")
  return (res)
}
######

survey<-openxlsx::readWorkbook("IE_suivi_sanitaire_v3.xlsx", sheet = 2)

choices<-openxlsx::readWorkbook("IE_suivi_sanitaire_v3.xlsx", sheet = 1)

######on reccupere des infos sur les individus
ind<-utf8(dbGetQuery(con, paste0("SELECT ind_id, nom_registre, enc_name, ani_sexe FROM main.v_intermediaire_registre, histoire_de_vie WHERE ani_n_inra = n_inra and aae_date_fin IS NULL and enc_name != 'grand enclos' ")))
######on reccupere la dernière marque connue pour chaque individu
mark <- data.frame(NULL)

for (i in 1:dim(ind)[1]){
  res <- utf8(dbGetQuery(con, paste0("SELECT ind_id, cap_collier marquage FROM individus_total WHERE ind_id in ",v2dbn(ind[i,"ind_id"])," order by obs_date DESC"))[1,])
  mark <- rbind(mark,res)
}

####on fusionne le marquage avec les informatons sur les individus
data_ind<- merge(ind,mark, by = c("ind_id"))


####################################################Observateur #######################
a_survey <- survey[1:which(survey$type == "select_one observateur"),]
a_choices <- choices[choices$list_name =="observateur",]

##############Ajout d'observateur
#rbind(a_choices, c("observateur","toto","toto le hero"))
############
####################################################Enclos #####################################################
b_survey <- survey[which(survey$"label::French" == "Enclos"):max(which(survey$"label::French" == "Selectionnez un animal")),]
b_choices <- choices[choices$list_name =="enclos",]

enc<-sort(unique(data_ind$enc_name))  #####nota la liste des enclos est importe de la bd_gardouch

#b_survey[1,]<-b_survey[1,]

for (i in 1:length(enc)){
  b_survey[i+1,"type"] <-  paste0("select_one nom_",enc[i])
  b_survey[i+1,"name"] <-  paste0("nom_",enc[i])
  b_survey[i+1,"label::French"] <-  "Selectionnez un animal"
  b_survey[i+1,"hint::French"] <-  NA
  b_survey[i+1,"comments"] <-  NA
  b_survey[i+1,"required"] <-  as.character(NA)
  b_survey[i+1,"relevant"] <-  paste0("${enclos}= \"",enc[i],"\"")
  b_survey[i+1,"constraint"] <-  NA
  b_survey[i+1,"constraint_message::French"] <- NA 
  b_survey[i+1,"calculation"] <- NA
  b_survey[i+1,"appearance"] <- "minimal"
  b_survey[i+1,"choice_filter"] <- NA
  b_survey[i+1,"repeat_count"] <- NA
  b_survey[i+1,"media::image"] <- NA
  b_survey[i+1,"default"] <- NA
}

for (i in 1:length(enc)){
  b_choices[i,"list_name"] <-  "enclos"
  b_choices[i,"name"] <-  enc[i]
  b_choices[i,"label::French"] <-  enc[i]
}
##################assemblage de blocks
survey_full <- rbind(a_survey,b_survey)
choices_full <- rbind(a_choices,b_choices)

##################ajout des fins de groupes
survey_full <- rbind(survey_full, survey[which(survey$name == "single_page" & survey$type == "end group"):which(survey$name == "single_page_1"& survey$type == "begin group"),])

c_survey<- survey[min(which(survey$name == "gender" & survey$type == "note")):max(which(survey$name == "gender"& survey$type == "note")),]

for (i in 2:dim(c_survey)[1]){
  c_survey[i,"type"] <-  "note"
  c_survey[i,"name"] <-  "gender"
  c_survey[i,"label::French"] <-  if (i==1) {"MALE"} else {"FEMELLE"}
  c_survey[i,"hint::French"] <-  NA
  c_survey[i,"comments"] <-  NA
  c_survey[i,"required"] <-  as.character(NA)
  c_survey[i,"relevant"] <-  if (i==1) {select_ind(data_ind,enc,ind_enc,"male")} else {select_ind(data_ind,enc,ind_enc,"femelle")}
  c_survey[i,"constraint"] <-  NA
  c_survey[i,"constraint_message::French"] <- NA 
  c_survey[i,"calculation"] <- NA
  c_survey[i,"appearance"] <- NA
  c_survey[i,"choice_filter"] <- NA
  c_survey[i,"repeat_count"] <- NA
  c_survey[i,"media::image"] <- NA
  c_survey[i,"default"] <- NA
}

survey_full <- rbind(survey_full,c_survey)

d_survey<- survey[min(which(survey$name == "marquage" & survey$type == "note")):max(which(survey$name == "marquage"& survey$type == "note")),]

data_ind_tmp<- data_ind[!is.na(data_ind$marquage),]


for (i in 1:dim(data_ind_tmp)[1]){
  d_survey[i,"type"] <-  "note"
  d_survey[i,"name"] <-  "marquage"
  d_survey[i,"label::French"] <-  data_ind_tmp[i,"marquage"]
  d_survey[i,"hint::French"] <-  NA
  d_survey[i,"comments"] <-  NA
  d_survey[i,"required"] <-  as.character(NA)
  d_survey[i,"relevant"] <-  paste0("${nom_",data_ind_tmp[i,"enc_name"],"}= ",data_ind_tmp[i,"ind_id"],"")
  d_survey[i,"constraint"] <-  NA
  d_survey[i,"constraint_message::French"] <- NA 
  d_survey[i,"calculation"] <- NA
  d_survey[i,"appearance"] <- NA
  d_survey[i,"choice_filter"] <- NA
  d_survey[i,"repeat_count"] <- NA
  d_survey[i,"media::image"] <- NA
  d_survey[i,"default"] <- NA
}

survey_full <- rbind(survey_full,d_survey)

# ########################on injecte les alertes
# source("C:/Users/ychaval/Documents/Collegues/Etudiants/BELBOUAB_Jasmine/Programmes/R/ids.R")
# raw_infos <- GET(url = "https://kf.kobotoolbox.org/api/v2/assets/",authenticate(user,password))
# infos_content <- fromJSON(rawToChar(raw_infos$content))
# data_uid <- infos_content$results$uid
# url = paste("https://kf.kobotoolbox.org/api/v2/assets", data_uid[1], "data", sep = "/")
# raw_data <- GET(url = url ,authenticate(user, password))
# data_content <- fromJSON(rawToChar(raw_data$content))$results
# 
# if (length(data_content)!= 0){
# 
# data_content$ind_id<- unite(data_content[,grep("nom",names(data_content))],"ind_id", sep = "", remove = TRUE, na.rm = TRUE)
# 
# data_contentt<-data_content[,c("ind_id","single_page_0/date","single_page_3/feces","single_page_3/blessure","single_page_3/localisation","single_page/enclos")]
# 
# data_contentt<- data_contentt[order(data_contentt[,"single_page_0/date"]),]
# row.names(data_contentt)<- seq(1,dim(data_contentt)[1],1)
# 
# 
# dd_survey<- survey_full[0,]
# 
# for (i in 1:dim(unique(data_contentt[,"ind_id"]))[1]){
# 
#   ##########attention
# 
#   dat<-data_contentt[grep(data_contentt[i,"ind_id"],data_contentt[,"ind_id"][,1]),]
#   row.names(dat)<- seq(1,dim(dat)[1],1)
#   if (dat[which(as.POSIXlt(dat$"single_page_0/date") == Sys.Date()),"single_page_3/feces"] == "pas_vu" | is.na(dat[which(as.POSIXlt(dat$"single_page_0/date") == Sys.Date()),"single_page_3/feces"])) {
#   if (!is.na(dat[which(as.POSIXlt(data_contentt$"single_page_0/date") < Sys.Date() & as.POSIXlt(data_contentt$"single_page_0/date") > Sys.Date()-7),"single_page_3/feces"]) &  dat[which(as.POSIXlt(data_contentt$"single_page_0/date") < Sys.Date() & as.POSIXlt(data_contentt$"single_page_0/date") > Sys.Date()-7),"single_page_3/feces"] != "pas_vu")
#   {
#   dd_survey[i,"type"] <-  "note"
#   dd_survey[i,"name"] <-  "Alerte_feces"
#   dd_survey[i,"label::French"] <-  "ALERTE: cet animal n'a pas eu dobservation de fécès cette semaine"
#   dd_survey[i,"hint::French"] <-  NA
#   dd_survey[i,"comments"] <-  NA
#   dd_survey[i,"required"] <-  as.character(NA)
#   dd_survey[i,"relevant"] <-  paste0("${nom_",dat$"single_page/enclos"[length(dat$"single_page/enclos")],"}= ",dat$ind_id[1,],"")
#   dd_survey[i,"constraint"] <-  NA
#   dd_survey[i,"constraint_message::French"] <- NA
#   dd_survey[i,"calculation"] <- NA
#   dd_survey[i,"appearance"] <- NA
#   dd_survey[i,"choice_filter"] <- NA
#   dd_survey[i,"repeat_count"] <- NA
#   dd_survey[i,"media::image"] <- NA
#   dd_survey[i,"default"] <- NA
#   }}
# }
# }
####################################


e_survey<- survey[min(which(survey$name == "single_page_1" & survey$type == "end group")):max(which(survey$name == "single_page_7"& survey$type == "end group")),]
e_choices<- choices[min(which(choices$list_name == "posture")):which(choices$list_name == "mouche"& choices$name == "non"),]

survey_full <- rbind(survey_full,e_survey)
choices_full <- rbind(choices_full,e_choices)

f_choices<-as.data.frame(cbind(paste0("nom_",data_ind[,c("enc_name")]),data_ind[,c("ind_id")],data_ind[,c("nom_registre")]))
names(f_choices)<-names(choices_full)
choices_full <- rbind(choices_full,f_choices)

#Creation du fichier Excel ###eviter les accents et parler soit french soit anglais (c'est mieux il n'y a pas d'accent et c'est echangeable avec d'autres)
wb<-xlsx::createWorkbook(type="xlsx")

#Creation de la premiere feuille du Formulaire, qui correspond e ce qui s'affiche dans les menus deroulants
sheet1 <- xlsx::createSheet(wb, sheetName = "choices")
#Deuxieme feuille avec les questions (toujours formalise sous forme de formulaire pris en charge par ODK)
sheet2 <- xlsx::createSheet(wb, sheetName = "survey")

xlsx::addDataFrame(survey_full,sheet2,col.names=TRUE,row.names=FALSE,startRow = 1, startColumn = 1,colStyle = NULL, rownamesStyle = NULL,showNA=FALSE,characterNA = "",byrow = FALSE)
xlsx::addDataFrame(choices_full,sheet1,col.names=TRUE,row.names=FALSE,startRow = 1, startColumn = 1,colStyle = NULL, rownamesStyle = NULL,showNA=FALSE,characterNA = "",byrow = FALSE)

xlsx::saveWorkbook(wb, "IE_suivi_sanitaire_v4.xlsx")



######use curl to import

