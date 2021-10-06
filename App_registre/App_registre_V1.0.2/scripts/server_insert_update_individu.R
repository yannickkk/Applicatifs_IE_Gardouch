source("C:/Users/ychaval/Documents/BD_Gardouch/Programmes/R/structure_actuelle/con_local_db_gardouch.R")
con<-local_gardouch

ind_obj_id<-dbGetQuery(con,paste0("select obj_id from list.tr_object_obj where obj_name = '",as.character(responses["ani_espece_id"]),"' "))

######metadonnees fichier et heure. insertion des informations d'insertion et de mise à jour
if (action == "insert") {ind_insert_timestamp <- as.character(as.POSIXct(Sys.time()))}
ind_insert_source  <- paste0("applicatif de saisie registre Gardouch V1.0.1 _ ",user,"")
if (action == "update") {ind_update_timestamp <- as.character(as.POSIXct(Sys.time()))}
ind_update_source <- paste0("applicatif de saisie registre Gardouch V1.0.1 _ ",user,"")
ind_remark<-enc2utf8("N°INRA_numéro invariant de l~'individu sur l~'installation expérimentale de gardouch")

#########insertion/maj d'un nouvel individu
##########INSERT
  if (action == "insert") {
    vinsert<<-v2db(enc2utf8(unlist(c(ind_obj_id, responses["ani_n_inra"],ind_remark,enc2utf8(responses["ani_remarque"]),ind_insert_timestamp,ind_insert_source))))
    colnaminsert<-dbGetQuery(con,"
                SELECT column_name FROM information_schema.columns WHERE table_schema = 'main' AND table_name   = 't_individu_ind' and (column_default is null OR column_default !~* 'nextval') and column_name != 'ind_update_timestamp' and column_name != 'ind_update_source';"
    )[,1]
  dbGetQuery(con,enc2utf8(paste0("
INSERT INTO main.t_individu_ind ",v2dbn(colnaminsert)," VALUES ",vinsert," ON CONFLICT (ind_obj_id, ind_name) DO UPDATE SET ",maj(colnaminsert, c("ind_obj_id", "ind_name")),"
                                             ")))
  aae_animal_ind_id<-dbGetQuery(con,paste0("SELECT ind_id from main.t_individu_ind where ind_obj_id = ",ind_obj_id," and ind_name = '",responses["ani_n_inra"],"'"))
  aae_enclos_ind_id<-dbGetQuery(con,paste0("SELECT ind_id from main.t_individu_ind, list.tr_object_obj where obj_id = ind_obj_id and obj_name = 'enclos' and ind_name = '",responses["enclos_entree"],"'"))
  
  dbSendQuery(con,enc2utf8(paste0("
INSERT INTO main.t_asso_ani_enc_aae (aae_animal_ind_id, aae_enclos_ind_id, aae_date_debut) VALUES (",aae_animal_ind_id,",",aae_enclos_ind_id,",'",as.Date(as.numeric(responses["ani_date_arrivee"]), origin = "1970-01-01"),"')")
                           ))
                      
}
##########UPDATE
  if (action == "update") {
    vupdate<-v2db(enc2utf8(unlist(c(ind_obj_id, responses["ani_n_inra"],ind_remark,responses["ani_remarque"],ind_update_timestamp,ind_update_source))))
    colnamupdate<-dbGetQuery(con,"
              SELECT column_name FROM information_schema.columns WHERE table_schema = 'main' AND table_name   = 't_individu_ind' and (column_default is null OR column_default !~* 'nextval')and column_name != 'ind_insert_timestamp' and column_name != 'ind_insert_source';"
    )[,1]
  dbSendQuery(con,enc2utf8(paste0("
 INSERT INTO main.t_individu_ind ",v2dbn(colnamupdate)," VALUES ",vupdate," ON CONFLICT (ind_obj_id, ind_name) DO UPDATE SET ",maj(colnamupdate, c("ind_obj_id", "ind_name")),"
                                             ")))
}


