server <- function(session,input, output) {
  
  session$onSessionEnded(stopApp)
  session$onSessionEnded(mortauxcons) ####supprime les connexions à la fermeture


  time_display<- function(data){ ####fonction qui affiche les données dans le timevis
    output$timelineInteractivei <- renderTimevis(
      timevis(
        data,
        options = list(editable = FALSE, multiselect = TRUE, align = "center", orientation = 'both'),
        groups = data.frame(id = unique(data$group), content =  unique(data$group),
                            fit = TRUE
        )
      )
    )}


  time_display(data)


  ###################################onglet A
  
  #################################### UTILISATEUR ########################
  output$selectuser<- renderUI({
    selectInput("selectus", tags$h4("Utilisateur:"), choices = c("","Nicolas Cebe","Arnaud Bonnet","Jean-Luc Rames","Marie-Line Maublanc","Hélène Verheyden"))
  })
  #################################### crée le tag pour la source #########
  observeEvent(input$selectus, {
    vers<<- paste0("histoire_vie_v01_",gsub(" ","_",input$selectus,""))
  })
  #########################################################################
  ###################################### ACTIONS ##########################
  
  observeEvent(input$fiti, { #####afficher toute la sélection
    fitWindow("timelineInteractivei")
  })
  
  
  observeEvent(input$focusSelectioni, {#####zommer sur la sélection
    centerItem("timelineInteractivei", input$timelineInteractivei_selected)
  })
  #########################################################################
  
  # #######affiche la valeur de l'individu sélectionné lorsqu'on clique sur entrer c'est pour chercher le bug de la ligne 47
  # observeEvent(input$enterItemi,{
  #   print(input$selectIdsi)
  # })
  
  ##################################### chevreuils ########################
  output$selectIdsOutputi <- renderUI({
    selectInput("selectIdsi", tags$h4("chevreuil(s):"), choices = unique(input$timelineInteractivei_data[,"group"]),
                multiple = TRUE, selected = input$selectIdsi)
  })
  #########################################################################
  
  #######lorsqu'on appuie sur le bouton sélectionner les animaux ##################### 
  
  observeEvent(input$selectItemsi, {
    if (is.null(input$selectIdsi)){
      data <<- utf8(dbGetQuery(gar_serveur,"SELECT aae_id as id,aae_date_debut as start, aae_date_fin as end, concat('<h2>',enc_name,'</h2>') as content,'color: black;' as style, nom_registre as group,'range' as type,aae_remark remarque FROM public.histoire_de_vie"))
    } else {
      data <<- utf8(dbGetQuery(gar_serveur,paste0("SELECT aae_id as id,aae_date_debut as start, aae_date_fin as end, concat('<h2>',enc_name,'</h2>') as content,'color: black;' as style, nom_registre as group,'range' as type,aae_remark remarque FROM public.histoire_de_vie where nom_registre in ",v2db(input$selectIdsi),"")))}
    data[which(is.na(data$end)), "end"]<- as.character(ymd(Sys.Date()))
    time_display(data)
    new_enclos_display()
  })
  ############################################################################
  

  ##############Afficher seulement les animaux present aujourd'hui ########
  observeEvent(input$selectpresi, {
    if (input$selectpresi){
      data <<- utf8(dbGetQuery(gar_serveur,paste0("SELECT aae_id as id,aae_date_debut as start, aae_date_fin as end, concat('<h2>',enc_name,'</h2>') as content,'color: black;' as style, nom_registre as group,'range' as type,aae_remark remarque FROM public.histoire_de_vie where nom_registre in ",v2db(presents),"")))
      data[which(is.na(data$end)), "end"]<- as.character(ymd(Sys.Date()))
      time_display(data)
      datae<-data
      datae$temp<-data$group
      datae$group<-gsub("</h2>","",gsub("<h2>","",data$content))
      datae$content<- paste0("<h2>",datae$temp,"</h2>")
      datae<<-datae[order(datae$group), ]
      time_displaye(datae)} else {
      data <<- utf8(dbGetQuery(gar_serveur,"SELECT aae_id as id,aae_date_debut as start, aae_date_fin as end, concat('<h2>',enc_name,'</h2>') as content,'color: black;' as style, nom_registre as group,'range' as type,aae_remark remarque FROM public.histoire_de_vie"))
      data[which(is.na(data$end)), "end"]<- as.character(ymd(Sys.Date()))
      time_display(data)
      datae<<-data
      datae$temp<-data$group
      datae$group<-gsub("</h2>","",gsub("<h2>","",data$content))
      datae$content<- paste0("<h2>",datae$temp,"</h2>")
      datae<-datae[order(datae$group), ]
      time_displaye(datae)
      }
  })
 ##############################################################################
 ############################## Mise à jour des données #######################
  observeEvent(input$enterItemi, {
  sel<-input$timelineInteractivei_selected
  if (length(sel) != 1){ ######on vérifie qu'il n'y ai pas de sous sélection (ie pas de portion d'histoire de vie sélectionné pour un individu), si tel est le cas alors la données est donc nouvelle il faut faire un insert
  aae_animal_ind_id<<- utf8(dbGetQuery(gar_serveur,paste0("SELECT distinct(aae_animal_ind_id) FROM public.histoire_de_vie where nom_registre in ",v2db(input$selectIdsi),"")))
  aae_enclos_ind_id<<- utf8(dbGetQuery(gar_serveur,paste0("SELECT ind_id FROM  main.t_individu_ind, list.tr_object_obj  where ind_name in ",v2db(input$encnew)," and obj_id =ind_obj_id and obj_name = 'enclos'")))
  if (dim(dbGetQuery(gar_serveur,paste0("SELECT aae_id FROM public.histoire_de_vie WHERE aae_animal_ind_id = ",aae_animal_ind_id," AND aae_date_fin IS NULL")))[1]!=0){
  id_enclos_precedent <<- dbGetQuery(gar_serveur,paste0("SELECT aae_id FROM public.histoire_de_vie WHERE aae_animal_ind_id = ",aae_animal_ind_id," AND aae_date_fin IS NULL"))[,1]} #aae_enclos_ind_id = ",aae_enclos_ind_id," and a
  if (exists("id_enclos_precedent")) {dbSendQuery(gar_serveur,paste0("UPDATE main.t_asso_ani_enc_aae SET aae_date_fin = '",input$begDate,"',
                                                                        aae_update_timestamp = '",substr(Sys.time(), 1, 19),"',
                                                                        aae_update_source = '",vers,"'
                                                                        where aae_id = ",as.numeric(id_enclos_precedent),""))}

  req<- paste0("INSERT INTO main.t_asso_ani_enc_aae (aae_animal_ind_id,  aae_enclos_ind_id, aae_date_debut, aae_date_fin, aae_remark, aae_insert_timestamp, aae_insert_source)
               values (",aae_animal_ind_id,",", aae_enclos_ind_id,",'",input$begDate,"','",input$endDate,"','",input$remark,"','",substr(Sys.time(), 1, 19),"','",vers,"')")

  req <- gsub("'NA'","NULL", req)
  req <- gsub("''","NULL", req)

  dbSendQuery(gar_serveur,req)
  time_display(data)
   ####fin controle un seul individu
  } else {
    aae_enclos_ind_id<<- utf8(dbGetQuery(gar_serveur,paste0("SELECT ind_id FROM  main.t_individu_ind, list.tr_object_obj  where ind_name in ",v2db(input$encnew)," and obj_id =ind_obj_id and obj_name = 'enclos'")))
    req <- paste0("UPDATE main.t_asso_ani_enc_aae set aae_enclos_ind_id = ",as.numeric(aae_enclos_ind_id),",
                                    aae_date_debut = '",input$begDate,"',
                                    aae_date_fin = '",input$endDate,"',
                                    aae_remark = '",input$remark,"',
                                    aae_update_timestamp = '",substr(Sys.time(), 1, 19),"',
                                    aae_update_source = '",vers,"' where aae_id = ",sel,"")
    req <- gsub("'NA'","NULL", req)
    req <- gsub("''","NULL", req)

    dbSendQuery(gar_serveur,req)
    time_display(data)
  } ###fin de l'update de la portion d'histoire de vie sélectionnée
  })
###########################################################################
  

new_enclos_display<- function(){ ######fonction qui permet l'affichage des fenêtres de saisie lorsqu'on sélectionne un individu
  output$begDateOutputi <- renderUI({
    if (!is.null(input$selectIdsi) & length(input$selectIdsi) == 1 & input$selectus != "") {
    if (is.null(input$timelineInteractivei_selected)){val<-NA}
    if (!is.null(input$timelineInteractivei_selected) & length(input$timelineInteractivei_selected) == 1){val<-as.character(ymd(data[which(data[,"id"] == input$timelineInteractivei_selected),"start"]))}
      dateInput(inputId = "begDate", label= tags$h4("Date de debut"), value = val)
    }
  })

  output$endDateOutputi <- renderUI({
    if (!is.null(input$selectIdsi) & length(input$selectIdsi) == 1 & input$selectus != "") {
    if (is.null(input$timelineInteractivei_selected)){val<-NA}
    if (!is.null(input$timelineInteractivei_selected) & length(input$timelineInteractivei_selected) == 1){val<-as.character(ymd(data[which(data[,"id"] == input$timelineInteractivei_selected),"end"]))}
      dateInput(inputId = "endDate", label= tags$h4("Date de fin"), value = val)
      }
   })


  output$selectIdsOutputee <- renderUI({
    if (!is.null(input$selectIdsi) & length(input$selectIdsi) == 1 & input$selectus != "") {
    if (is.null(input$timelineInteractivei_selected)){select<-NA}
    if (!is.null(input$timelineInteractivei_selected) & length(input$timelineInteractivei_selected) == 1){select<-gsub("</h2>","",gsub("<h2>","",as.character(data[which(data[,"id"] == input$timelineInteractivei_selected),"content"])))}
    selectInput(inputId = "encnew", label= tags$h4("enclos:"), choices = c("", utf8(dbGetQuery(gar_serveur,"Select ind_name from main.t_individu_ind, list.tr_object_obj where obj_name = 'enclos' and obj_id = ind_obj_id order by ind_name"))[,1]), selected = select)} ###liste des enclos dans la table individus
  })

  output$remark <- renderUI({
    if (!is.null(input$selectIdsi) & length(input$selectIdsi) == 1 & input$selectus != "") {
      if (is.null(input$timelineInteractivei_selected)){select<-NA}
      if (!is.null(input$timelineInteractivei_selected) & length(input$timelineInteractivei_selected) == 1){select<-gsub("</h2>","",gsub("<h2>","",as.character(data[which(data[,"id"] == input$timelineInteractivei_selected),"content"])))}
      textInput(inputId ="remarque", label =tags$h4("Remarque"))
    }
  })
}####fin de la fonction d'affichage des outils de saisie

########affichage du bouton permettant de mettre à jour les données
  output$enterItemiOutput <- renderUI({
    if (!is.null(input$selectIdsi) & length(input$selectIdsi) == 1 & length(nchar(input$begDate)>1)) { print("ok")
      if (input$encnew != "" & input$selectus != ""){print("okok");print(input$selectus);print(input$encnew);
      actionButton("enterItemi", "Entrer")}}
  })


  ####### onglet B
  time_displaye<- function (datae){
    output$timelineInteractivee <- renderTimevis(
      timevis(
        datae,
        options = list(editable = FALSE, multiselect = TRUE, align = "center", orientation = 'both'),
        groups = #data.frame(id = c("E1","E2","E3","E4","E6","GE"), content = c("E1","E2","E3","E4","E6","GE"),
          data.frame(id = unique(datae$group), content = unique(datae$group),
                     fit = TRUE
          )
      )
    )}


  ############onglet B ctions et selectitem

  output$selectedi <- renderText(
    paste(input$timelineInteractivei_selected, collapse = " ")
  )

  output$tablei <- renderTable( ####affiche les données de l'individu à commenter
    input$timelineInteractivei_data
  )



  observeEvent(input$fite, {
    fitWindow("timelineInteractivee")
  })
   observeEvent(input$focusSelectione, {
     centerItem("timelineInteractivee", input$timelineInteractivee_selected)
   })
  observeEvent(input$selectItemse, {
    setSelection("timelineInteractivee", input$selectIdse,
                 options = list(focus = input$selectFocuse))
    observeEvent(input$selectItemse, {
      if (is.null(input$selectIdse)){
        datae <<- utf8(dbGetQuery(gar_serveur,"SELECT aae_id as id,aae_date_debut as start, aae_date_fin as end, concat('<h2>',nom_registre,'</h2>') as content,'color: black;' as style, enc_name as group,'range' as type,aae_remark remarque FROM public.histoire_de_vie"))

                                 
      } else {
        datae <<- utf8(dbGetQuery(gar_serveur,paste0("SELECT aae_id as id,aae_date_debut as start, aae_date_fin as end, concat('<h2>',nom_registre,'</h2>') as content,'color: black;' as style, enc_name as group,'range' as type,aae_remark remarque FROM public.histoire_de_vie where enc_name in ",v2db(input$selectIdse),"")))}
      datae[which(is.na(datae$end)), "end"]<- as.character(ymd(Sys.Date()))
      time_displaye(datae)
      #new_enclos_display()
    })
    
  })
 # })
  output$selectIdsOutpute <- renderUI({
    selectInput("selectIdse", tags$h4("Enclos:"), sort(input$timelineInteractivee_data[,"group"]),
                multiple = TRUE)
  })

  
  #########export des données      
  
  output$downloadcsv2 <-  downloadHandler(
    filename = function() {
      paste0("histoire_de_vie_chevreuils_", gsub("-","_",Sys.Date()),".csv")
    },
    content = function(file) {
      write.csv2(data, file, row.names = FALSE)
    }
  )
  output$downloadcsv2e <-  downloadHandler(
    filename = function() {
      paste0("histoire_de_vie_enclos_", gsub("-","_",Sys.Date()),".csv")
    },
    content = function(file) {
      write.csv2(datae, file, row.names = FALSE)
    }
  )
  
  mytimeline<<-      timevis(
    data,
    options = list(editable = FALSE, multiselect = TRUE, align = "center", orientation = 'both'),
    groups = data.frame(id = unique(data$group), content =  unique(data$group),
                        fit = TRUE
    )
  )
  
  
  output$downloadhtml <-  downloadHandler(
    filename = function() {
      paste0("histoire_de_vie_chevreuils_", gsub("-","_",Sys.Date()),".html")
    },
    content = function(file) {
      htmlwidgets::saveWidget(mytimeline,file = file, selfcontained = F)

    }
  )
  # output$downloadhtmle <-  downloadHandler(
  #   filename = function() {
  #     paste0("histoire_de_vie_enclos_", gsub("-","_",Sys.Date()),".html")
  #   },
  #   content = function(file) {
  #     registre %>%
  #       kbl() %>%
  #       kable_styling(bootstrap_options = c("striped", "hover"))  %>%
  #       save_kable(file = file, self_contained = T)
  #   }
  # )

  
}


