######transforme les dates de numérique à humain
dinsert<-apply(dinsert,2,as.character)
dupdate<-apply(dupdate,2,as.character)

dinsert[,"di_value"]<-as.character(as.Date(as.numeric(dinsert[,"di_value"]), origin = "1970-01-01"))
dupdate[,"di_value"]<-as.character(as.Date(as.numeric(dupdate[,"di_value"]), origin = "1970-01-01"))
