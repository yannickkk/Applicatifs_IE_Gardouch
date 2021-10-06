source("C:/Users/ychaval/Documents/BD_Gardouch/Programmes/R/structure_actuelle/con_local_db_gardouch.R")
con<-local_gardouch

#######on récupère les identifiants de variable et leur type
var <- data.frame(var_id = NA,var_name_short = NA,var_type = NA)
for (i in 1:length(names(responses))){
  var[i,1]<-dbGetQuery(con, paste0("select var_id from main.tr_variable_var where var_name_short = '",names(responses)[i],"' "))
  var[i,2]<-dbGetQuery(con, paste0("select var_name_short from main.tr_variable_var where var_name_short = '",names(responses)[i],"' "))
  var[i,3]<-dbGetQuery(con, paste0("select var_type from main.tr_variable_var where var_name_short = '",names(responses)[i],"' "))
}

#######bascule du vecteur pour avoir une table en long avec les colonnes: ani_n_inra, variable, value, type
response<-responses
response<-as.data.frame(response)
ind_id<-dbGetQuery(con,paste0("SELECT ind_id FROM main.t_individu_ind where ind_name = '",response[1,1],"' "))
response$ani_n_inra<-rep(ind_id, dim(response)[1])
response$variable<-var$var_id
response$value<-response$response
response$type<-var$var_type
response<-response[,-1]
response<-response[-1,]

for (i in unique(var$var_type)){
  d<-subset(response, type == i)
  if (dim(d)[1] == 0) {next}
  if (length(which(d$value == "")) !=0) {d<-d[-which(d$value == ""),]}
  rownames(d) <- seq_len(nrow(d))###on reindexe après le subset
  if (i == "integer") {i<-"integ"};if (i == "boolean") {i<-"bool"};if (i == "varchar") {i<-"alpha"};if (i == "real") {i<-"num"};if (i == "date") {i<-"date"}
  tab_name<-dbGetQuery(con,paste0("SELECT distinct (table_name) FROM information_schema.columns WHERE table_schema = 'main' AND table_name  ~* '",paste0("tj_individu_",i,""),"';"))[1,]
  if (i == "integ") {i<-"integer"};if (i == "bool") {i<-"boolean"};if (i == "alpha") {i<-"varchar"};if (i == "num") {i<-"real"};if (i == "date") {i<-"date"}
  prefixe<-paste0(sapply(strsplit(as.character(tab_name),"_"),"[[",length(strsplit(as.character(tab_name),"_")[[1]])),"_")
  names(d)[which(names(d)=="variable")]<- paste0(prefixe,"var_id")
  names(d)[which(names(d)=="value")]<- paste0(prefixe,"value")
  names(d)[which(names(d)=="value")]<- paste0(prefixe,"ind_id")

  if (i == "integer"){source("scripts/server_varchar2int.R")}

  d[,paste0(prefixe,"remark")] <- NA
  d[,paste0(prefixe,"insert_timestamp")] <- as.character(as.POSIXct(Sys.time()))
  d[,paste0(prefixe,"insert_source")]<-  paste0("applicatif de saisie registre Gardouch V1.0.1 _ ",user,"")
  d[,paste0(prefixe,"update_timestamp")] <- as.character(as.POSIXct(Sys.time()))
  d[,paste0(prefixe,"update_source")]<-  paste0("applicatif de saisie registre Gardouch V1.0.1 _ ",user,"")
  d<-d[,-which(names(d) == "type")]
  names(d)[which(names(d) == "ani_n_inra")]<-paste0(prefixe,"ind_id")

  colnaminsert<-dbGetQuery(con,paste0("
                SELECT column_name FROM information_schema.columns WHERE table_schema = 'main' AND table_name   =  '",tab_name,"' and (column_default is null OR column_default !~* 'nextval') and column_name != '",paste0(prefixe,"update_timestamp"),"' and column_name != '",paste0(prefixe,"update_source"),"' ;"
                 ))[,1]
  colnamupdate<-dbGetQuery(con,paste0("
                 SELECT column_name FROM information_schema.columns WHERE table_schema = 'main' AND table_name   =  '",tab_name,"' and (column_default is null OR column_default !~* 'nextval')and column_name != '",paste0(prefixe,"insert_timestamp"),"' and column_name != '",paste0(prefixe,"insert_source"),"' ;"
                 ))[,1]

  dinsert<-d[,colnaminsert]
  dupdate<-d[,colnamupdate]

  if (i == "date"){source("scripts/server_int2date.R")}
#########insertion/maj des variables: ici on sépare en deux pour pouvoir mettre à jour les champs de insert et update suivant si la variable existe déjà ou non.
##########INSERT
  for (j in 1:dim(d)[1]){
  if (action == "insert") {
    dbSendQuery(con,paste0("
    INSERT INTO main.",tab_name," ",v2dbn(colnaminsert)," values ",v2db(dinsert[j,])," ON CONFLICT (",paste0(prefixe,"ind_id",",",prefixe,"var_id"),") DO UPDATE SET ",maj(colnaminsert, c(paste0(prefixe,"ind_id"),paste0(prefixe,"var_id"))),"
                                    "))
    ####si la variable ani_date_depart n'est pas nulle alors on met a jours l'association animal/enclos pour que la date aae_date_fin qui est Null pour cet individu soit égale à ani_date_depart 
    ani_date_depart<-dbGetQuery(con, paste0("select var_id from main.tr_variable_var where var_name_short = 'ani_date_depart' "))
    if (!is.null(dinsert[j,"di_var_id"]) && dinsert[j,"di_var_id"] == ani_date_depart && !is.na(dinsert[j,"di_value"])) {
      dbSendQuery(con,paste0("UPDATE main.t_asso_ani_enc_aae SET aae_date_fin = '",dinsert[j,"di_value"],"' where aae_animal_ind_id = ",dinsert[j,"di_ind_id"]," and aae_date_fin is null"))
      }
    }###balaye le sous jeu de données (pour un type de variable) et alimente la table correspondante

##########UPDATE
if (action == "update") {

  dbSendQuery(con,paste0("
INSERT INTO main.",tab_name," ",v2dbn(colnamupdate)," values ",v2db(dupdate[j,])," ON CONFLICT (",paste0(prefixe,"ind_id",",",prefixe,"var_id"),") DO UPDATE SET ",maj(colnamupdate, c(paste0(prefixe,"ind_id"),paste0(prefixe,"var_id"))),"
                                    "))
  ####si la variable ani_date_depart n'est pas nulle alors on met a jours l'association animal/enclos pour que la date aae_date_fin qui est Null pour cet individu soit égale à ani_date_depart 
  ani_date_depart<-dbGetQuery(con, paste0("select var_id from main.tr_variable_var where var_name_short = 'ani_date_depart' "))
    if (!is.null(dinsert[j,"di_var_id"]) && dinsert[j,"di_var_id"] == ani_date_depart && !is.na(dinsert[j,"di_value"])) {
    dbSendQuery(con,paste0("UPDATE main.t_asso_ani_enc_aae SET aae_date_fin = '",dinsert[j,"di_value"],"' where aae_animal_ind_id = ",dinsert[j,"di_ind_id"]," and aae_date_fin is null"))
  }
  }###balaye le sous jeu de données (pour un type de variable) et alimente la table correspondante
}#####j
    }####i

