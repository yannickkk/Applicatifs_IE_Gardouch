#------------------------------------TITRE--------------------------------------
#  Auteur: Yannick Chaval, INRAE (French National Research Institute for Agriculture, Food and Environment), CEFS (Wildlife, Behaviour and Ecology Research Unit)
#  Date:  18/02/2021
#  version 1.0.1
#  modification: ajout de l'utilisateur en champ mandataire
#  Description:
#  Documentation:
#
#
#
#
#
#------------------------------------------------------------------------------
#####auto install packages
mypackages<-c("xlsx","knitr", "kableExtra","shinybusy","shinycssloaders","shiny","shinyBS", "RPostgreSQL", "lubridate","shinyjs","shinyalert","data.table","shinyTime")
for (p in mypackages){
  if(!require(p, character.only = TRUE)){
    install.packages(p)
    library(p, character.only = TRUE)
  }
}

if(exists("obs_id")) {rm("obs_id", env= .GlobalEnv)}
if(exists("heure")) {rm("heure", env= .GlobalEnv)}
#rm(list=ls(), env= .GlobalEnv)
source("scripts/fonctions.R")


source("C:/Users/ychaval/Documents/BD_Gardouch/Programmes/R/con_serveur_dbgardouch.R")
con<-gar_serveur

# var_tab1<-c("ani_n_inra","ani_nom_registre","ani_transpondeur_id","obs_date","cap_collier","cap_echt_peau","cap_echt_poil_cou","cap_echt_feces","cap_echt_poil_croupe","cap_echt_sang_rouge","cap_echt_sang_violet","cap_echt_sang_bleu","cap_echt_sang_vert","cap_echt_tique","cap_echt_salive_1","cap_echt_salive_2","cap_echt_nasal","cap_echt_vaginal","cap_echt_vag","cap_anesthesie","cap_anesthesie_heure","cap_heure_reveil","cap_acepromazine_bol","cap_dose_acepromazine","cap_tranquilisant","cap_traitement")
# var_tab2<-c("ani_n_inra","ani_nom_registre","obs_date","cap_circ_thorax","cap_longueur_tarse","cap_circ_cou","cap_longueur_machoire","cap_boite_pleine","cap_boite_vide","cap_poids","cap_temp_ext","cap_temp_rectale_text","cap_temp_rectale_finale","cap_cardio_15s_debut","cap_cardio_15s_fin","heure_cardio_3","cap_cardio_20_3","cap_cardio_60_3","heure_cardio_2","cap_cardio_20_2","cap_cardio_60_2","heure_cardio_1","cap_cardio_20_1","cap_cardio_60_1","cap_produit_tranquilisant","cap_prophilaxie","cap_bois_dur","cap_lg_bois_d","cap_lg_bois_g","cap_lg_oreille","cap_cnt_tiques","cap_poids","cap_lg_bois_d","cap_lg_bois_g","cap_bois_velour","cap_bois_tombe","cap_bois_dur","cap_allaitante","cap_blessure","cap_diarrhee","cap_glycemie_1","cap_glycemie_2","cap_cnt_tiques_oreille","cap_tiques_pres","cap_cnt_tiques_gorgees","cap_puces_pres","cap_poux_pres","cap_hypobosq_pres","cap_echt_salive_heure_1","cap_echt_salive_heure_2","cap_tble_h_deb","cap_tble_temp_exterieur","cap_tble_temp_animal_moy","heure_repiro_1","cap_respiro_20_1","cap_respiro_60_1","heure_repiro_2","cap_respiro_20_2","cap_respiro_60_2","heure_repiro_3","cap_respiro_20_3","cap_respiro_60_3","cap_heure_lache")
# var_tab3<-c("ani_n_inra","ani_nom_registre","obs_date","cap_tble_lutte","cap_tble_halete","cap_tble_cri_bague","cap_tble_cri_autre","cap_lache_course","cap_lache_bolide","cap_lache_cabriole_saut","cap_lache_gratte_collier","cap_lache_tombe","cap_lache_calme","cap_lache_nbre_stop","cap_lache_cri","cap_lache_titube","cap_lache_couche","cap_lache_visibilite","cap_lache_public","cap_lache_remark","cap_arrivee_filet_course","cap_arrivee_filet_pas_vu","cap_filet_panique","cap_filet_lutte","cap_filet_halete","cap_filet_cri","cap_sabot_retournement","cap_sabot_couche","cap_sabot_agitation")
# 
#####define mandatory fields
fieldsMandatory <- c("login","ani_n_inra", "ani_nom_registre", "obs_date")

#####define fields to export into the csv file and to update in db
# champsregistre<-t(utf8(dbGetQuery(con,"select var_name_short from  main.tr_variable_var, list.tr_var_domain_level_1_dl1 where dl1_id = var_dl1_id  and dl1_domain_name = 'registre' ")))
# ani_age<-grep("ani_age",champsregistre)
# ani_vivant<-grep("ani_vivant",champsregistre)

#fieldsAll <- unique(append(append(var_tab1,var_tab2),var_tab3))
fieldsAll <-c("ani_n_inra", "ani_nom_registre","obs_date","ani_transpondeur_id")

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

