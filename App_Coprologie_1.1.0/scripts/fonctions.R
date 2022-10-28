#####################FUNCTIONS

####### Passer les premières lettres d'une colonne de df en Majuscule ou toutes les colonnes whole=TRUE
to_upper_first <- function(df,co, whole=FALSE){
if (whole){ 
 for (i in 1:dim(df)[2]) {
   df[,colnames(i)]<- tolower(df[,colnames(i)])
   df[,colnames(i)]<- paste0(toupper(substr(df[,colnames(i)], 1, 1)), substr(df[,colnames(i)], 2, nchar(as.character(df[,colnames(i)]))))
}} else {
cat("seulement les colonnes: ",co," seront concernées pour affecter toutes les colonnes utiliser whole= TRUE");
  if (length(co) == 1) { df[,co]<-paste0(toupper(substr(df[,co], 1, 1)), substr(tolower(df[,co]), 2, nchar(as.character(df[,co]))))} else
  for (i in 1:dim(df[,co])[2]) {
    df[,co[i]]<-paste0(toupper(substr(df[,co[i]], 1, 1)), substr(tolower(df[,co[i]]), 2, nchar(as.character(df[,co[i]]))))}
}
return(df)
}

####### Rendre la casse compatible avec UTF-8 (pour un dataframe)
####### exemple
##dist<-utf8(dbGetQuery(con,"SELECT distinct lfa_remarque FROM public.t_locfaons_lfa where lfa_remarque ~* 'sibbling';"))

utf8 <- function(x) {
  # Declare UTF-8 encoding on all character columns:
  chr <- sapply(x, is.character)
  x[, chr] <- lapply(x[, chr, drop = FALSE], `Encoding<-`, "UTF-8")
  # Same on column names:
  Encoding(names(x)) <- "UTF-8"
  return(x)
}


########pour changer les code echantillons du format francais vers anglais from x_ddmmyyyy_ani_etiq to x_yyyymmdd_ani_etiq
library(stringr)
dmy2ymd<- function(x) {
    invers<- sapply(str_split(x, "_"),"[[",2)
    invers<- paste0(str_sub(invers,5,8),str_sub(invers,3,4),str_sub(invers,1,2))
    invers<-paste0(sapply(str_split(x, "_"),"[[",1),"_",invers,"_",sapply(str_split(x, "_"),"[[",3))
    return(invers)
}

########v2db ###permet de formater un vecteur R pour le rentrer dans une close sql column in ('xx','xx','xx')
########remplace les NA par NULL
########utiliser le ~ pour echaper un ' (~' sera changer en '' pour pouvoir être accepté par postgres
v2db<- function(x) {
if (length(x[which(is.na(x))]) != 0) {x[which(is.na(x))]<-"NA"} else {x<-x}
x<-as.vector(apply(as.data.frame(x),2,as.character))
x<- gsub("'","~'",x)
x[grep("^NA$",as.character(x))]<- ""
x<-paste0("('",paste(x,collapse ="','"),"')")
x<- gsub("''","NULL", x)
x<- gsub("~'","''", x)
return(x)
}

########v2dbn ###permet de formater un vecteur R pour le rentrer dans une close sql column in (xx,xx,xx)
v2dbn<- function(x) {
  x<-paste0("(",paste(x,collapse =","),")")
  return(x)
}

 ###permet de formater un vecteur R pour le rentrer dans une close sql column in ('xx','xx','xx') met en y ajoutant le excluded devant
#####lorsque le vecteur des champs contient insert_source et insert_timestamp ils sont remplacés par update_source et update_timestamp
##### x noms des champs et y noms des champs forment la contrainte unique
maj <- function(x,y) {
  x<-x[-match(y,x)]
  if (length(grep("_insert_",x))!=0){x<-x[-grep("_insert_",x)]} else {x<-x}
  updated<-v2dbn(x)
  alias<-strsplit(unlist(strsplit(gsub("','",",",gsub("\')","",gsub("\\('","",x))),","))[1],"_")[[1]][1]
  x<-gsub(alias,paste0("excluded.",alias),x)
  x<-paste0("(",paste(x,collapse =","),")")
  x<-paste(updated," = ",x)
  return(x)
}

########syn renvoi les ani_etiq valides a partir d'un vecteur d'ani_etiq pour cor_updated = TRUE
# library(RPostgreSQL)
# source("C:/Users/ychaval/Documents/BD_CEFS/con_serveur_dbcefs.R")
# syn<- function(x) {
# cor<-dbGetQuery(serveur,paste0("Select cor_ancien, cor_valide from t_correspondance_animal_cor where cor_updated = TRUE"))
# x[!is.na(match(x, cor[,"cor_ancien"]))]<- cor[na.omit(match(x, cor[,"cor_ancien"])), "cor_valide"]
# return(x)
# }
# cat(objects())
# 
# #######duplique une table source vers une nouvelle table en gardant l'ensemble des contraintes de la table source
# ######le nom de table doit être entre ''
# library(RPostgreSQL)
# source("C:/Users/ychaval/Documents/BD_CEFS/con_local_dbcefs.R")
# ######https://stackoverflow.com/questions/23693873/how-to-copy-structure-of-one-table-to-another-with-foreign-key-constraints-in-ps
# dbSendQuery(local,"
# create or replace function create_table_like(source_table text, new_table text)
# returns void language plpgsql
# as $$
#   declare
# rec record;
# begin
# execute format(
#   'create table %s (like %s including all)',
#   new_table, source_table);
# for rec in
# select oid, conname
# from pg_constraint
# where contype = 'f' 
# and conrelid = source_table::regclass
# loop
# execute format(
#   'alter table %s add constraint %s %s',
#   new_table,
#   replace(rec.conname, source_table, new_table),
#   pg_get_constraintdef(rec.oid));
# end loop;
# end $$;
# --COMMENT ON FUNCTION create_table_like IS 'fonction qui permée de dupliquer une table en conservant l''ENSEMBLE des containtes';
#             ")

#####cree une sequence sur la table passee en x = "schema.table"
#####sur le champ alias_id
####avec la valeur maximum + 1 du champ comme prochaine valeur
# seq <- function(x,y) {
#   con<-x
# sch<-str_split(y, "\\.")[[1]][1]
# tab<-str_split(y, "\\.")[[1]][2]
# alias<-paste0(strsplit(tab,"_")[[1]][length(strsplit(tab,"_")[[1]])],"_")
# if (dim(dbGetQuery(con,paste0("SELECT 0 FROM pg_class where relname = 'seq_",tab,"'")))[1] == 0){
#   dbSendQuery(con, gsub("[\r\n]", " ",paste0("
# DROP SEQUENCE ",sch,".seq_",tab,";CREATE SEQUENCE ",sch,".seq_",tab," OWNED BY ",sch,".",tab,".",alias,"id;")))  
# };
# dbSendQuery(con, gsub("[\r\n]", " ",paste0("
# SELECT SETVAL ('",sch,".seq_",tab,"', COALESCE((SELECT max(",alias,"id)+1 from ",sch,".",tab,")), false);
# ALTER TABLE main.t_localisation_loc ALTER COLUMN loc_id SET DEFAULT nextval('",sch,".seq_",tab,"');
# ")))}



###########################enlever les accents
rm_accent <- function(str,pattern="all") {
  if(!is.character(str))
    str <- as.character(str)
  
  pattern <- unique(pattern)
  
  if(any(pattern=="Ç"))
    pattern[pattern=="Ç"] <- "ç"
  
  symbols <- c(
    acute = "áéíóúÁÉÍÓÚýÝ",
    grave = "àèìòùÀÈÌÒÙ",
    circunflex = "âêîôûÂÊÎÔÛ",
    tilde = "ãõÃÕñÑ",
    umlaut = "äëïöüÄËÏÖÜÿ",
    cedil = "çÇ"
  )
  
  nudeSymbols <- c(
    acute = "aeiouAEIOUyY",
    grave = "aeiouAEIOU",
    circunflex = "aeiouAEIOU",
    tilde = "aoAOnN",
    umlaut = "aeiouAEIOUy",
    cedil = "cC"
  )
  
  accentTypes <- c("´","`","^","~","¨","ç")
  
  if(any(c("all","al","a","todos","t","to","tod","todo")%in%pattern)) # opcao retirar todos
    return(chartr(paste(symbols, collapse=""), paste(nudeSymbols, collapse=""), str))
  
  for(i in which(accentTypes%in%pattern))
    str <- chartr(symbols[i],nudeSymbols[i], str) 
  
  return(str)
}
####################enlever les espaces dans un chaine
wsr<-function(x) {
  gsub("[[:space:]]","",x)
}