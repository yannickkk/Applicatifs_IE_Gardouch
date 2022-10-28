#######on reccupere l'identifiant de l'objet qui est observé
ind_obj_id<<-dbGetQuery(con,paste0("
                                  SELECT obj_id
                                  FROM list.tr_object_obj where obj_name = 'chevreuil';
                                  "))[,1]

obs_ind_id<-dbGetQuery(con,paste0("SELECT ind_id FROM public.registre_gardouch where ani_nom_registre = '",dat["nom_registre"],"'"))

#####on teste si il y a déjà une observation pur cet individu à cette date
if (is.na(match(paste0(obs_ind_id, dat["obs_date"]), dbGetQuery(con,"SELECT distinct concat(obs_ind_id, substring(obs_date::varchar,1,10)) from main.t_observation_obs")))
) {action <- "insert"} else {action <- "update"}
#######reccuperer les identifiants des colonnes
colnam<-dbGetQuery(con,"
        SELECT column_name FROM information_schema.columns WHERE table_schema = 'main' AND table_name   = 't_observation_obs' and (column_default is null OR column_default !~* 'nextval');"
)[,1]

 if (action == "insert") {dat["obs_insert_timestamp"] <- as.character(as.POSIXct(Sys.time()))
 dat["obs_insert_source"]  <- paste0("applicatif de saisie coprologies Gardouch V1.0.0 - ",dat["observateur_copro"],"")}
 if (action == "update") {dat["obs_update_timestamp"] <- as.character(as.POSIXct(Sys.time()))
 dat["obs_update_source"] <- paste0("applicatif de saisie coprologies Gardouch V1.0.0 - ",dat["observateur_copro"],"")}

#######reccuperation de l'identifiant de l'individu et insertion des nouvelles lignes
 if (action ==  "insert"){
   colnam<-colnam[-grep("_update_",colnam)]
   v<-v2db(enc2utf8(unlist(c(obs_ind_id,dat["obs_date"],dat["obs_remarque"],"coprologie_chevreuil_gardouch",dat["obs_insert_timestamp"],dat["obs_insert_source"]))))
    dbSendQuery(con,enc2utf8(paste0("
                                               INSERT INTO main.t_observation_obs ",v2dbn(colnam)," VALUES ",v," ON CONFLICT (obs_ind_id, obs_date) DO UPDATE SET ",maj(colnam, c("obs_ind_id", "obs_date")),"
                                               ")))
 }
 if (action ==  "update"){
   colnam<-colnam[-grep("_insert_",colnam)]
   v<-v2db(enc2utf8(unlist(c(obs_ind_id,dat["obs_date"],dat["obs_remarque"],"coprologie_chevreuil_gardouch",dat["obs_update_timestamp"],dat["obs_update_source"]))))
   dbSendQuery(con,enc2utf8(paste0("
                                              INSERT INTO main.t_observation_obs ",v2dbn(colnam)," VALUES ",v," ON CONFLICT (obs_ind_id, obs_date) DO UPDATE SET ",maj(colnam, c("obs_ind_id", "obs_date")),"
                                              ")))
rm(action)
  }
