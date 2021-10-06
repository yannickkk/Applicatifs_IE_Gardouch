source("C:/Users/ychaval/Documents/BD_Gardouch/Programmes/R/structure_actuelle/con_local_db_gardouch.R")
con<-local_gardouch

#######espece

varia<-var[which(var$var_name_short =="ani_espece_id"),"var_id"]

d[which(d$ii_var_id == varia),"ii_value"]<- dbGetQuery(con,paste0("SELECT obj_id FROM list.tr_object_obj WHERE obj_name = '",d[which(d$ii_var_id == varia),"ii_value"],"'"))

#######parents

varia<-var[which(var$var_name_short =="ani_pere"),"var_id"]

d[which(d$ii_var_id == varia),"ii_value"]<- dbGetQuery(con,paste0("SELECT ani_n_inra FROM public.registre_gardouch WHERE ani_nom_registre = '",d[which(d$ii_var_id == varia),"ii_value"],"'and ani_sexe = 'M'"))

varia<-var[which(var$var_name_short =="ani_mere"),"var_id"]

d[which(d$ii_var_id == varia),"ii_value"]<- dbGetQuery(con,paste0("SELECT ani_n_inra FROM public.registre_gardouch WHERE ani_nom_registre = '",d[which(d$ii_var_id == varia),"ii_value"],"' and ani_sexe = 'F'"))

               
#dbDisconnect(con)
