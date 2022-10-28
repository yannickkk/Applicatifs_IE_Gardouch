for (quoi in c("observateur_copro", "capillaria","coccidies", "dictyocaules", "echinostomida", "haemonchus_contortus","moniezia", 
     "nematodirus", "oxyures", "strongles_gastro_intestinaux", "strongyloidess_papillosus", "trichuris_ovis","paramphistomum")){
#########si il y a une heure et qu'elle est différente de 00:00:00 alors on change l etype de la varaible qui devient time_type
i<<-dbGetQuery(con,enc2utf8(paste0("SELECT var_type from main.tr_variable_var where var_name_short = '",quoi,"'")))

# if (exists("heure")){
# if (!is.null(heure) & format(heure, format = "%H:%M:%S") != "00:00:00") {
# i <- paste0("time~",i,"")}
# }

var_id<<-dbGetQuery(con,enc2utf8(paste0("SELECT var_id from main.tr_variable_var where var_name_short = '",quoi,"'")))

if (i == "integer") {i<-"integ"};if (i == "boolean") {i<-"bool"};if (i == "varchar") {i<-"alpha"};if (i == "real") {i<-"num"};if (i == "time") {i<-"time"}; if (i == "time~integer") {i<-"integ_time"};if (i == "time~varchar") {i<-"alpha_time"};if (i == "time~real") {i<-"num_time"};if (i == "time~boolean") {i<-"bool_time"}
tab_name<-dbGetQuery(con,paste0("SELECT distinct (table_name) FROM information_schema.columns WHERE table_schema = 'main' AND table_name  ~* '",paste0("tj_observation_",i,""),"';"))[1,]
if (i == "integ") {i<-"integer"};if (i == "bool") {i<-"boolean"};if (i == "alpha") {i<-"varchar"};if (i == "num") {i<-"real"}
prefixe<-paste0(sapply(strsplit(as.character(tab_name),"_"),"[[",length(strsplit(as.character(tab_name),"_")[[1]])),"_")

colnam<-dbGetQuery(con,paste0("SELECT column_name FROM information_schema.columns WHERE table_schema = 'main' AND table_name   = '",tab_name,"' and (column_default is null OR column_default !~* 'nextval');"
))[,1]

d<-NA

obs_id<-dbGetQuery(con,paste0("SELECT obs_id from main.t_observation_obs where obs_ind_id = ",obs_ind_id," and substring(obs_date::varchar,1,10) = '",dat["obs_date"],"'" ))

if (!is.na(dat[paste0(quoi,"_remarque")])) {remarque<-dat[paste0(quoi,"_remarque")]}
  
if (exists("action")){
  
  d[paste0(prefixe,"var_id")]<- var_id
  d[paste0(prefixe,"obs_id")]<- obs_id
  if (tab_name == "tj_observation_time_tob") {d[paste0(prefixe,"local_time_cest")]<- format(dat[quoi], format = "%H:%M:%S"); exeption<- TRUE} else {d[paste0(prefixe,"value")]<- trimws(dat[quoi])}
  if (exists("remarque")) {if (remarque != "") {d[paste0(prefixe,"remark")]<- trimws(remarque)} else {d[paste0(prefixe,"remark")]<- ""}} else {d[paste0(prefixe,"remark")]<- ""}
  if (exists("heure")){if (!is.null(heure) & length(grep("_time",i)) != 0) {d[paste0(prefixe,"local_time_cest")]<- format(heure, format = "%H:%M:%S")}}
  
if (action =="insert"){
d[paste0(prefixe,"insert_timestamp")]<- as.character(as.POSIXct(Sys.time()))
d[paste0(prefixe,"insert_source")]<- paste0("applicatif de saisie coprologie Gardouch V1.0.0 - ",dat["observateur_copro"],"")
}

if (action =="update"){
d[paste0(prefixe,"update_timestamp")]<- as.character(as.POSIXct(Sys.time()))
d[paste0(prefixe,"update_source")]<- paste0("applicatif de saisie coprologie Gardouch V1.0.0 - ",dat["observateur_copro"],"")
}
  d<-d[-1]
  d<-unlist(d)
  }

colnam<-na.omit(colnam[match(names(d),colnam)])

if (i == "integer") {d[paste0(prefixe,"value")]<- round(as.numeric(gsub(",",".",dat[quoi])))}
print(d)

if (is.na(d[paste0(prefixe,"local_time_cest")]) | exists("exeption")){ 
dbSendQuery(con,paste0("INSERT INTO main.",tab_name," ",v2dbn(colnam)," values ",v2db(d)," ON CONFLICT (",paste0(prefixe,"obs_id"),",",paste0(prefixe,"var_id"),") DO UPDATE SET ",maj(colnam, c(paste0(prefixe,"obs_id"),paste0(prefixe,"var_id"))),"
                                      "))} else {
dbSendQuery(con,paste0("INSERT INTO main.",tab_name," ",v2dbn(colnam)," values ",v2db(d)," ON CONFLICT (",paste0(prefixe,"obs_id"),",",paste0(prefixe,"var_id"),",",paste0(prefixe,"local_time_cest"),") DO UPDATE SET ",maj(colnam, c(paste0(prefixe,"obs_id"),paste0(prefixe,"var_id"),paste0(prefixe,"local_time_cest"))),"
                                      "))}
}
rm(quoi, dat, i)

