#######on reccupere l'identifiant de l'objet qui est observé
dat<-responses
ind_obj_id<-dbGetQuery(con,paste0("
                                  SELECT obj_id
                                  FROM list.tr_object_obj where obj_name = 'chevreuil';
                                  "))[,1]

#######reccuperer les identifiants des colonnes
colnam<-dbGetQuery(con,"
        SELECT column_name FROM information_schema.columns WHERE table_schema = 'main' AND table_name   = 't_observation_obs' and (column_default is null OR column_default !~* 'nextval');"
)[,1]

if (action == "insert") {dat$obs_insert_timestamp <- as.character(as.POSIXct(Sys.time()))
dat$obs_insert_source  <- paste0("applicatif de saisie capture Gardouch V1.0.1 - ",user,"")}
if (action == "update") {dat$obs_update_timestamp <- as.character(as.POSIXct(Sys.time()))
dat$obs_update_source <- paste0("applicatif de saisie capture Gardouch V1.0.1 - ",user,"")}

#######reccuperation de l'identifiant de l'individu et insertion des nouvelles lignes.
obs_ind_id<-dbGetQuery(con,paste0("SELECT ind_id FROM main.t_individu_ind where ind_obj_id = '",ind_obj_id,"' and ind_name = '",dat["ani_n_inra"],"'"))
if (action ==  "insert"){
  colnam<-colnam[-grep("_update_",colnam)]
  v<-v2db(enc2utf8(unlist(c(obs_ind_id,dat["obs_date"],"capture_chevreuil_gardouch","NULL",dat["obs_insert_timestamp"],dat["obs_insert_source"]))))
  dbSendQuery(con,enc2utf8(paste0("
                                             INSERT INTO main.t_observation_obs ",v2dbn(colnam)," VALUES ",v," ON CONFLICT (obs_ind_id, obs_date) DO UPDATE SET ",maj(colnam, c("obs_ind_id", "obs_date")),"
                                             ")))
}
if (action ==  "update"){
  colnam<-colnam[-grep("_insert_",colnam)]
  v<-v2db(enc2utf8(unlist(c(obs_ind_id,dat["obs_date"],"capture_chevreuil_gardouch","NULL",dat["obs_update_timestamp"],dat["obs_update_source"]))))
  dbSendQuery(con,enc2utf8(paste0("
                                             INSERT INTO main.t_observation_obs ",v2dbn(colnam)," VALUES ",v," ON CONFLICT (obs_ind_id, obs_date) DO UPDATE SET ",maj(colnam, c("obs_ind_id", "obs_date")),"
                                             ")))
#######mise à jour du transpondeur
  var_id<-dbGetQuery(con,enc2utf8(paste0("SELECT var_id from main.tr_variable_var where var_name_short = 'ani_transpondeur_id'")))
  ai_ind_id <- obs_ind_id
  ani_transpondeur_id_old<-dbGetQuery(con,enc2utf8(paste0("SELECT ai_value from main.tj_individu_alpha_ai WHERE ai_var_id = '",var_id,"' and ai_ind_id = '",ai_ind_id,"'")))
  if (length(toupper(ani_transpondeur_id_old)) != 0){
    if  (dat["ani_transpondeur_id"] != "" & toupper(ani_transpondeur_id_old) != toupper(dat["ani_transpondeur_id"])){
  dbSendQuery(con,enc2utf8(paste0("UPDATE main.tj_individu_alpha_ai SET ai_value = '",dat["ani_transpondeur_id"],"',
                                  ai_update_timestamp = '",dat$obs_update_timestamp,"',
                                  ai_update_source = '",dat$obs_update_source,"'
                                  where ai_var_id = '",var_id,"' and ai_ind_id = '",ai_ind_id,"'")))}}

  }
