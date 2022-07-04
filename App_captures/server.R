# Define server
shinyServer(function(input, output, session) {
  
   close_session <- function() {
     rm(obs_id)
     stopApp()
   }
   session$onSessionEnded(close_session)
  
  #####on récupère le nom de l'utilisateur
  observeEvent(input$login, {
    user<<- input$login})
###########################################################################
######### observe if mandatory fields are filled or not ###################
###########################################################################  
  
  observe({
    # check if all mandatory fields have a value
    mandatoryFilled <-
      vapply(fieldsMandatory,
             function(x) {
               !is.null(as.character(input[[x]])) && as.character(input[[x]]) != "" && !is.na(as.character(input[[x]])) && isTruthy(as.character(input[[x]]))
             },
             logical(1))

    # enable/disable the submit button
    shinyjs::toggleState(id = "subcol", condition = all(mandatoryFilled)) ###if ref and frequence of a collar are integrated then allow submission of a new collar
  })


  formData <- reactive({
    nouvelleentree <<- sapply(fieldsAll, function(x) input[[x]])
    nouvelleentree
  })

  

#######################################################  
############# Creation ou maj de la capture ###########
#######################################################  

#############on teste si la capture existe
   
  saveData <- function(nouvelleentree) {
    responses <<- sapply(nouvelleentree,"[",1)

    ########check if eqt_id_usuel already exist inside the db and then give the choice to update existing data or delete entering data 
     #obj <<- as.numeric(dbGetQuery(con,paste0("SELECT obj_id FROM list.tr_object_obj WHERE obj_name = '",responses["ani_espece_id"],"'"))[,1])
     verif<<- utf8(dbGetQuery(con,paste0("Select numero_inrae, obs_date  from capture_gardouch")))
     verif<<- paste0(verif[,1], verif[,2])
     responses["obs_date"]<<- as.character(as.Date(as.numeric(responses["obs_date"]), origin = "1970-01-01"))
     ent<-paste0(responses["ani_n_inra"],responses["obs_date"])
     if (length(grep(ent,verif)!= 0)) {shinyalert("Attention !!!", "Cette capture existe déjà",showCancelButton = TRUE, confirmButtonText = "Mettre à jour les données de cette capture",cancelButtonText = "Ne rien faire", type = "error", callbackR = function (va) {


#si la capture existe on la met à jour#
#######################################

        if (va == TRUE) {
        action <<-"update"
        
        source("scripts/server_insert_update_observation.R")
        reset_old_val()####remise à la valeur de l'obs des widgets
        #print(paste0("upsdate après script:",obs_ind_id," ",paste0(responses["obs_date"])," "))
        obs_id<<-dbGetQuery(con,enc2utf8(paste0("SELECT obs_id from main.t_observation_obs where obs_ind_id = '",obs_ind_id,"' and date(obs_date) = '",paste0(responses["obs_date"]),"' ")))
        #print(paste0("upsdate après script:",obs_id,""))
        reloadData()#### selectionne les donnees de la capture consernée
        
        
        } else {reset()}####remise à zero des widjets
    }
    )} else { 
        
########no entry duplicated
###########################

        action <<-"insert"
        
        source("scripts/server_insert_update_observation.R")
        obs_id<<-dbGetQuery(con,enc2utf8(paste0("SELECT obs_id from main.t_observation_obs where obs_ind_id = '",obs_ind_id,"' and obs_date = '",paste0(responses["obs_date"]),"' ")))
        reset()####remise à zero des widjets
        reloadData()#### selectionne les donnees de la capture consernée
        set_false()#### met tous les boléens à false par défaut
        #compteur<<- 1
        }
        }

###################################################
######### Maj variables de capture onglet 1 #######
###################################################
  #########################################################################
  ###################### COLLIER ##########################################
  #########################################################################  
  
  observeEvent(input$cap_collier, { variable <- 1; 
  if (input$cap_collier != "" & exists("obs_id")){
    quoi<<- "cap_collier"
      valeur<<-input$cap_collier
      source("scripts/server_insert_update_variables_observation.R")
      reloadData()
    }
  })

      
  #########################################################################
  ###################### echantillon peau/poils/feces #####################
  #########################################################################  

 #########################observer sur quel echantillon    
  observeEvent(input$variable_1, { variable <- 2;
  if (input$variable_1 != "" & exists("obs_id")) {
     updateNumericInput(session,inputId = "variable_1_valeur", value = former_val(input$variable_1));
     #updateTimeInput(session,inputId = "variable_1_heure", value = paste(date(Sys.time()),substr(former_val(paste0(input$variable_1,"_heure"),1,8)," CET"));
     updateTextInput(session,inputId = "variable_1_rq", value = former_val(paste0(input$variable_1,"_remarque")));
    if (!is.null(input$variable_1_valeur) & !is.na(input$variable_1_valeur)){
 #   if (exists("compteur") & compteur == "insert"){ ####ici compteur (1) lors du premier passage (car incrémenté par le passage de la boucle au dessuus) mais il est inférieur à variable (2) lors du premier passage donc on fait rien et compteur devient 2 etc etc 
      quoi<<-input$variable_1
      valeur<<-input$variable_1_valeur
      if (!is.null(input$variable_1_heure)) {heure<<-format(input$variable_1_heure, format = "%H:%M:%S")} else {rm(heure)}
      if (!is.null(input$variable_1_rq)) {remarque<<-input$variable_1_rq} else {rm(remarque)}
      source("scripts/server_insert_update_variables_observation.R")
      reloadData()
      # }
    }}
  })
 #########################observer nbre échant
  observeEvent(input$variable_1_valeur, {variable <- 3;
    if (input$variable_1 != "" & exists("obs_id") & !is.null(input$variable_1_valeur)){
 #   if (exists("compteur") & compteur == "insert"){
      quoi<<-input$variable_1
      valeur<<-input$variable_1_valeur
      if (!is.null(input$variable_1_heure)) {heure<<-format(input$variable_1_heure, format = "%H:%M:%S")} else {rm(heure)}
      if (!is.null(input$variable_1_rq)) {remarque<<-input$variable_1_rq} else {rm(remarque)}
      source("scripts/server_insert_update_variables_observation.R")
      reloadData()
#       }
    }
  })
   #########################observer heure
  observeEvent(input$variable_1_heure, {variable <- 4;
    if (format(input$variable_1_heure, format = "%H:%M:%S") != "00:00:00" & exists("obs_id") & !is.null(input$variable_1_valeur) & input$variable_1 != ""){
 #   if (exists("compteur") & compteur == "insert"){
      quoi<<-input$variable_1
      valeur<<-input$variable_1_valeur
      if (!is.null(input$variable_1_heure)) {heure<<-format(input$variable_1_heure, format = "%H:%M:%S")} else {rm(heure)}
      if (!is.null(input$variable_1_rq)) {remarque<<-input$variable_1_rq} else {rm(remarque)}
      source("scripts/server_insert_update_variables_observation.R")
      reloadData()
#       }
    }
  })
#########################observer remarque
  observeEvent(input$variable_1_rq, {variable <- 5;
    if (input$variable_1 != "" & exists("obs_id") & !is.null(input$variable_1_valeur) & input$variable_1_rq != ""){
 #   if (exists("compteur") & compteur == "insert"){
      quoi<<-input$variable_1
      valeur<<-input$variable_1_valeur
      if (!is.null(input$variable_1_heure)) {heure<<-format(input$variable_1_heure, format = "%H:%M:%S")} else {rm(heure)}
      if (!is.null(input$variable_1_rq)) {remarque<<-input$variable_1_rq} else {rm(remarque)}
      source("scripts/server_insert_update_variables_observation.R")
      reloadData()
#       }
    }
  })

  #########################################################################
  ###################### echantillon sang  ################################
  #########################################################################  
  #########################observer sur quel echantillon    
  observeEvent(input$variable_2, {variable <- 6;
  if (input$variable_2 != "" & exists("obs_id")) {
    updateNumericInput(session,inputId = "variable_2_valeur", value = former_val(input$variable_2));
    #updateTimeInput(session,inputId = "variable_2_heure", value = paste(date(Sys.time()),substr(former_val(paste0(input$variable_2,"_heure"),1,8)," CET"));
    updateTextInput(session,inputId = "variable_2_rq", value = former_val(paste0(input$variable_2,"_remarque")));
    if (!is.null(input$variable_2_valeur) & !is.na(input$variable_2_valeur)){
 #   if (exists("compteur") & compteur == "insert"){
      quoi<<-input$variable_2
      valeur<<-input$variable_2_valeur
      if (!is.null(input$variable_2_heure)) {heure<<-format(format(input$variable_2_heure, format = "%H:%M:%S"), format = "%H:%M:%S")} else {rm(heure)}
      if (!is.null(input$variable_2_rq)) {remarque<<-input$variable_2_rq} else {rm(remarque)}
      source("scripts/server_insert_update_variables_observation.R")
      reloadData()
#       }
    }}
  })
  
  #########################observer nbre échant
  observeEvent(input$variable_2_valeur, {variable <- 7;
    if (input$variable_2 != "" & exists("obs_id") & !is.null(input$variable_2_valeur)){
 #   if (exists("compteur") & compteur == "insert"){
      quoi<<-input$variable_2
      valeur<<-input$variable_2_valeur
      if (!is.null(input$variable_2_heure)) {heure<<-format(input$variable_2_heure, format = "%H:%M:%S")} else {rm(heure)}
      if (!is.null(input$variable_2_rq)) {remarque<<-input$variable_2_rq} else {rm(remarque)}
      source("scripts/server_insert_update_variables_observation.R")
      reloadData()
#       }
    }
  })
  #########################observer heure
  observeEvent(input$variable_2_heure, {variable <- 8;
    if (format(input$variable_2_heure, format = "%H:%M:%S") != "00:00:00" & exists("obs_id") & !is.null(input$variable_2_valeur) & input$variable_2 != ""){
 #   if (exists("compteur") & compteur == "insert"){
      quoi<<-input$variable_2
      valeur<<-input$variable_2_valeur
      if (!is.null(input$variable_2_heure)) {heure<<-format(input$variable_2_heure, format = "%H:%M:%S")} else {rm(heure)}
      if (!is.null(input$variable_2_rq)) {remarque<<-input$variable_2_rq} else {rm(remarque)}
      source("scripts/server_insert_update_variables_observation.R")
      reloadData()
#       }
    }
  })
  #########################observer remarque
  observeEvent(input$variable_2_rq, {variable <- 9;
    if (input$variable_2 != "" & exists("obs_id") & !is.null(input$variable_2_valeur) & input$variable_2_rq != ""){
 #   if (exists("compteur") & compteur == "insert"){
      quoi<<-input$variable_2
      valeur<<-input$variable_2_valeur
      if (!is.null(input$variable_2_heure)) {heure<<-format(input$variable_2_heure, format = "%H:%M:%S")} else {rm(heure)}
      if (!is.null(input$variable_2_rq)) {remarque<<-input$variable_2_rq} else {rm(remarque)}
      source("scripts/server_insert_update_variables_observation.R")
      reloadData()
#       }
    }
  })


  #########################################################################
  ###################### echantillon parasites   ##########################
  #########################################################################  
  #########################observer sur quel echantillon    
  observeEvent(input$variable_3, {variable <- 10;
  if (input$variable_3 != "" & exists("obs_id")) {
  updateNumericInput(session,inputId = "variable_3_valeur", value = former_val(input$variable_3));
  #updateTimeInput(session,inputId = "variable_3_heure", value = paste(date(Sys.time()),substr(former_val(paste0(input$variable_3,"_heure"),1,8)," CET"));
  updateTextInput(session,inputId = "variable_3_rq", value = former_val(paste0(input$variable_3,"_remarque")));
    if (!is.null(input$variable_3_valeur) & !is.na(input$variable_3_valeur)){
 #   if (exists("compteur") & compteur == "insert"){
      quoi<<-input$variable_3
      valeur<<-input$variable_3_valeur
      if (!is.null(input$variable_3_heure)) {heure<<-format(input$variable_3_heure, format = "%H:%M:%S")} else {rm(heure)}
      if (!is.null(input$variable_3_rq)) {remarque<<-input$variable_3_rq} else {rm(remarque)}
      source("scripts/server_insert_update_variables_observation.R")
      reloadData()
#       }
    }}
  })
  
  
  #########################observer nbre échant
  observeEvent(input$variable_3_valeur, {variable <- 11;
    if (input$variable_3 != "" & exists("obs_id") & !is.null(input$variable_3_valeur)){
 #   if (exists("compteur") & compteur == "insert"){
      quoi<<-input$variable_3
      valeur<<-input$variable_3_valeur
      if (!is.null(input$variable_3_heure)) {heure<<-format(input$variable_3_heure, format = "%H:%M:%S")} else {rm(heure)}
      if (!is.null(input$variable_3_rq)) {remarque<<-input$variable_3_rq} else {rm(remarque)}
      source("scripts/server_insert_update_variables_observation.R")
      reloadData()
#       }
    }
  })
  #########################observer heure
  observeEvent(input$variable_3_heure, {variable <- 12;
    if (format(input$variable_3_heure, format = "%H:%M:%S") != "00:00:00" & exists("obs_id") & !is.null(input$variable_3_valeur) & input$variable_3 != ""){
 #   if (exists("compteur") & compteur == "insert"){
      quoi<<-input$variable_3
      valeur<<-input$variable_3_valeur
      if (!is.null(input$variable_3_heure)) {heure<<-format(input$variable_3_heure, format = "%H:%M:%S")} else {rm(heure)}
      if (!is.null(input$variable_3_rq)) {remarque<<-input$variable_3_rq} else {rm(remarque)}
      source("scripts/server_insert_update_variables_observation.R")
      reloadData()
#       }
    }
  })
  #########################observer remarque
  observeEvent(input$variable_3_rq, {variable <- 13;
    if (input$variable_3 != "" & exists("obs_id") & !is.null(input$variable_3_valeur) & input$variable_3_rq != ""){
 #   if (exists("compteur") & compteur == "insert"){
      quoi<<-input$variable_3
      valeur<<-input$variable_3_valeur
      if (!is.null(input$variable_3_heure)) {heure<<-format(input$variable_3_heure, format = "%H:%M:%S")} else {rm(heure)}
      if (!is.null(input$variable_3_rq)) {remarque<<-input$variable_3_rq} else {rm(remarque)}
      source("scripts/server_insert_update_variables_observation.R")
      reloadData()
#       }
    }
  })


  #########################################################################
  ###################### echantillon sécréssions     ######################
  #########################################################################  
  #########################observer sur quel echantillon    
  observeEvent(input$variable_4, {variable <- 14;
  if (input$variable_4 != "" & exists("obs_id")) {
  updateNumericInput(session,inputId = "variable_4_valeur", value = former_val(input$variable_4));
  #updateTimeInput(session,inputId = "variable_4_heure", value = paste(date(Sys.time()),substr(former_val(paste0(input$variable_4,"_heure"),1,8)," CET"));
  updateTextInput(session,inputId = "variable_4_rq", value = former_val(paste0(input$variable_4,"_remarque")));
    if (!is.null(input$variable_4_valeur) & !is.na(input$variable_4_valeur)){
 #   if (exists("compteur") & compteur == "insert"){
      quoi<<-input$variable_4
      valeur<<-input$variable_4_valeur
      if (!is.null(input$variable_4_heure)) {heure<<-format(input$variable_4_heure, format = "%H:%M:%S")} else {rm(heure)}
      if (!is.null(input$variable_4_rq)) {remarque<<-input$variable_4_rq} else {rm(remarque)}
      source("scripts/server_insert_update_variables_observation.R")
      reloadData()
#       }
    }}
  })
  
  #########################observer nbre échant
  observeEvent(input$variable_4_valeur, {variable <- 15;
    if (input$variable_4 != "" & exists("obs_id") & !is.null(input$variable_4_valeur)){
 #   if (exists("compteur") & compteur == "insert"){
      quoi<<-input$variable_4
      valeur<<-input$variable_4_valeur
      if (!is.null(input$variable_4_heure)) {heure<<-format(input$variable_4_heure, format = "%H:%M:%S")} else {rm(heure)}
      if (!is.null(input$variable_4_rq)) {remarque<<-input$variable_4_rq} else {rm(remarque)}
      source("scripts/server_insert_update_variables_observation.R")
      reloadData()
#       }
    }
  })
  #########################observer heure
  observeEvent(input$variable_4_heure, {variable <- 16;
    if (format(input$variable_4_heure, format = "%H:%M:%S") != "00:00:00" & exists("obs_id") & !is.null(input$variable_4_valeur) & input$variable_4 != ""){
 #   if (exists("compteur") & compteur == "insert"){
      quoi<<-input$variable_4
      valeur<<-input$variable_4_valeur
      if (!is.null(input$variable_4_heure)) {heure<<-format(input$variable_4_heure, format = "%H:%M:%S")} else {rm(heure)}
      if (!is.null(input$variable_4_rq)) {remarque<<-input$variable_4_rq} else {rm(remarque)}
      source("scripts/server_insert_update_variables_observation.R")
      reloadData()
#       }
    }
  })
  #########################observer remarque
  observeEvent(input$variable_4_rq, {variable <- 17;
    if (input$variable_4 != "" & exists("obs_id") & !is.null(input$variable_4_valeur) & input$variable_4_rq != ""){
 #   if (exists("compteur") & compteur == "insert"){
      quoi<<-input$variable_4
      valeur<<-input$variable_4_valeur
      heure<<-format(input$variable_4_heure, format = "%H:%M:%S")
      if (!is.null(input$variable_4_heure)) {heure<<-format(input$variable_4_heure, format = "%H:%M:%S")} else {rm(heure)}
      if (!is.null(input$variable_4_rq)) {remarque<<-input$variable_4_rq} else {rm(remarque)}
      source("scripts/server_insert_update_variables_observation.R")
      reloadData()
#       }
    }
  })
  #########################################################################
  ###################### Comptage parasites    ############################
  #########################################################################  
  
  #########################observer sur quel echantillon    
  observeEvent(input$variable_9, {variable <- 18;
  if (input$variable_9 != "" & exists("obs_id")) {
    updateSelectInput(session,inputId = "variable_9_valeur", selected = former_val(input$variable_9));
    #updateTimeInput(session,inputId = "variable_9_heure", value = paste(date(Sys.time()),substr(former_val(paste0(input$variable_9,"_heure"),1,8)," CET"));
    updateTextInput(session,inputId = "variable_9_rq", value = former_val(paste0(input$variable_9,"_remarque")));
    if (input$variable_9_valeur != "" & !is.na(input$variable_9_valeur)){
 #   if (exists("compteur") & compteur == "insert"){
      quoi<<-input$variable_9
      valeur<<-input$variable_9_valeur
      if (!is.null(input$variable_9_heure)) {heure<<-format(input$variable_9_heure, format = "%H:%M:%S")} else {rm(heure)}
      if (!is.null(input$variable_9_rq)) {remarque<<-input$variable_9_rq} else {rm(remarque)}
      source("scripts/server_insert_update_variables_observation.R")
      reloadData()
#       }
    }}
  })
  #########################observer nbre échant
  observeEvent(input$variable_9_valeur, {variable <- 19;
    if (input$variable_9 != "" & exists("obs_id") & input$variable_9_valeur != ""){
 #   if (exists("compteur") & compteur == "insert"){
      quoi<<-input$variable_9
      valeur<<-input$variable_9_valeur
      if (!is.null(input$variable_9_heure)) {heure<<-format(input$variable_9_heure, format = "%H:%M:%S")} else {rm(heure)}
      if (!is.null(input$variable_9_rq)) {remarque<<-input$variable_9_rq} else {rm(remarque)}
      source("scripts/server_insert_update_variables_observation.R")
      reloadData()
#       }
    }
  })
  #########################observer heure
  observeEvent(input$variable_9_heure, {variable <- 20;
    if (format(input$variable_9_heure, format = "%H:%M:%S") != "00:00:00" & exists("obs_id") & !is.null(input$variable_9_valeur) & input$variable_9 != ""){
 #   if (exists("compteur") & compteur == "insert"){
      quoi<<-input$variable_9
      valeur<<-input$variable_9_valeur
      if (!is.null(input$variable_9_heure)) {heure<<-format(input$variable_9_heure, format = "%H:%M:%S")} else {rm(heure)}
      if (!is.null(input$variable_9_rq)) {remarque<<-input$variable_9_rq} else {rm(remarque)}
      source("scripts/server_insert_update_variables_observation.R")
      reloadData()
#       }
    }
  })
  #########################observer remarque
  observeEvent(input$variable_9_rq, {variable <- 21;
    if (input$variable_9 != "" & exists("obs_id") & !is.null(input$variable_9_valeur) & input$variable_9_rq != ""){
 #   if (exists("compteur") & compteur == "insert"){
      quoi<<-input$variable_9
      valeur<<-input$variable_9_valeur
      if (!is.null(input$variable_9_heure)) {heure<<-format(input$variable_9_heure, format = "%H:%M:%S")} else {rm(heure)}
      if (!is.null(input$variable_9_rq)) {remarque<<-input$variable_9_rq} else {rm(remarque)}
      source("scripts/server_insert_update_variables_observation.R")
      reloadData()
#       }
    }
  })
  
  
  #########################################################################
  ###################### puces ############################################
  #########################################################################  
  
  observeEvent(input$cap_puces_pres, {variable <- 22;
    if (exists("obs_id")){
 #   if (exists("compteur") & compteur == "insert"){
      quoi<<- "cap_puces_pres"
      valeur<<-input$cap_puces_pres
      #print(paste0("écriture 435",valeur," "))
      source("scripts/server_insert_update_variables_observation.R")
      reloadData()
#       }
    }
  })

  #########################################################################
  ###################### poux #############################################
  #########################################################################  
  
  observeEvent(input$cap_poux_pres, {variable <- 23;
    if (exists("obs_id")){
 #   if (exists("compteur") & compteur == "insert"){
      quoi<<- "cap_poux_pres"
      valeur<<-input$cap_poux_pres
      source("scripts/server_insert_update_variables_observation.R")
      reloadData()
#       }
    }
  })
  #########################################################################
  ###################### hippobosques #####################################
  #########################################################################  

  observeEvent(input$cap_hypobosq_pres, {variable <- 24;
    if (exists("obs_id")){
 #   if (exists("compteur") & compteur == "insert"){
      quoi<<- "cap_hypobosq_pres"
      valeur<<-input$cap_hypobosq_pres
      source("scripts/server_insert_update_variables_observation.R")
      reloadData()
#       }
    }
  })

  #########################################################################
  ###################### bois velours #####################################
  #########################################################################  
  
  observeEvent(input$cap_bois_velour, {variable <- 25;
    if (exists("obs_id")){
 #   if (exists("compteur") & compteur == "insert"){
      quoi<<- "cap_bois_velour"
      valeur<<-input$cap_bois_velour
      source("scripts/server_insert_update_variables_observation.R")
      reloadData()
#       }
    }
  })
  #########################################################################
  ###################### bois durs    #####################################
  #########################################################################  
  
  observeEvent(input$cap_bois_dur, {variable <- 26;
    if (exists("obs_id")){
 #   if (exists("compteur") & compteur == "insert"){
      quoi<<- "cap_bois_dur"
      valeur<<-input$cap_bois_dur
      source("scripts/server_insert_update_variables_observation.R")
      reloadData()
#       }
    }
  })
  #########################################################################
  ###################### bois tombés    ###################################
  #########################################################################  
  
  observeEvent(input$cap_bois_tombe, {variable <- 27;
    if (exists("obs_id")){
 #   if (exists("compteur") & compteur == "insert"){
      quoi<<- "cap_bois_tombe"
      valeur<<-input$cap_bois_tombe
      source("scripts/server_insert_update_variables_observation.R")
      reloadData()
#       }
    }
  })
  #########################################################################
  ###################### bois sciés  ######################################
  #########################################################################  
  
  observeEvent(input$cap_bois_scies, {variable <- 28;
    if (exists("obs_id")){
 #   if (exists("compteur") & compteur == "insert"){
      quoi<<- "cap_bois_scies"
      valeur<<-input$cap_bois_scies 
      source("scripts/server_insert_update_variables_observation.R")
      reloadData()
#       }
    }
  })
  #########################################################################
  ###################### allaitement  #####################################
  #########################################################################  
  
  observeEvent(input$cap_allaitante, {variable <- 29;
    if (exists("obs_id")){
 #   if (exists("compteur") & compteur == "insert"){
      quoi<<- "cap_allaitante"
      valeur<<-input$cap_allaitante
      source("scripts/server_insert_update_variables_observation.R")
      reloadData()
#       }
    }
  })
  #########################################################################
  ###################### diarrhée  ########################################
  #########################################################################  
  
  observeEvent(input$cap_diarrhee, {variable <- 30;
    if (exists("obs_id")){
 #   if (exists("compteur") & compteur == "insert"){
      quoi<<- "cap_diarrhee"
      valeur<<-input$cap_diarrhee
      source("scripts/server_insert_update_variables_observation.R")
      reloadData()
#       }
    }
  })
  
  
  #########################################################################
  ###################### Blessure #########################################
  #########################################################################  
  observeEvent(input$cap_blessure, {variable <- 31;
    if (input$cap_blessure != "" & exists("obs_id")){
 #   if (exists("compteur") & compteur == "insert"){
      quoi<<- "cap_blessure"
      valeur<<-input$cap_blessure
      source("scripts/server_insert_update_variables_observation.R")
      reloadData()
#       }
    }
  })  
  observeEvent(input$cap_traitement, {variable <- 32;
    if (input$cap_traitement != "" & exists("obs_id")){
 #   if (exists("compteur") & compteur == "insert"){
      quoi<<- "cap_traitement"
      valeur<<-input$cap_traitement
      source("scripts/server_insert_update_variables_observation.R")
      reloadData()
#       }
    }
  })
  #########################################################################
  ###################### Anesthésie #######################################
  #########################################################################  
  
  observeEvent(input$cap_anesthesie, {variable <- 33;
    if (input$cap_anesthesie != "" & exists("obs_id")){
 #   if (exists("compteur") & compteur == "insert"){
      quoi<<- "cap_anesthesie"
      valeur<<-input$cap_anesthesie
      source("scripts/server_insert_update_variables_observation.R")
      reloadData()
#       }
    }
  })
  
  observeEvent(input$cap_anesthesie_heure, {variable <- 34;
    if (format(input$cap_anesthesie_heure, format = "%H:%M:%S") != "00:00:00" & exists("obs_id")){
 #   if (exists("compteur") & compteur == "insert"){
      quoi<<- "cap_anesthesie_heure"
      valeur<<-format(input$cap_anesthesie_heure, format = "%H:%M:%S")
      source("scripts/server_insert_update_variables_observation.R")
      reloadData()
#       }
    }
  })
  
  observeEvent(input$cap_heure_reveil, {variable <- 35;
    if (format(input$cap_heure_reveil, format = "%H:%M:%S") != "00:00:00" & exists("obs_id")){
 #   if (exists("compteur") & compteur == "insert"){
      quoi<<- "cap_heure_reveil"
      valeur<<-format(input$cap_heure_reveil, format = "%H:%M:%S")
      source("scripts/server_insert_update_variables_observation.R")
      reloadData()
#       }
    }
  })

  observeEvent(input$cap_dose_acepromazine, {variable <- 36;
    if (!is.null(input$cap_dose_acepromazine) & exists("obs_id")){
 #   if (exists("compteur") & compteur == "insert"){
      quoi<<- "cap_dose_acepromazine"
      valeur<<-input$cap_dose_acepromazine
      source("scripts/server_insert_update_variables_observation.R")
      reloadData()
#       }
    }
  })
  
  observeEvent(input$cap_tranquilisant, {variable <- 37;
    if (input$cap_tranquilisant != "" & exists("obs_id")){
 #   if (exists("compteur") & compteur == "insert"){
      quoi<<- "cap_tranquilisant"
      valeur<<-input$cap_tranquilisant
      source("scripts/server_insert_update_variables_observation.R")
      reloadData()
#       }
    }
  })
  
  observeEvent(input$cap_anesthesie_heure_remarque, {variable <- 38;
    if (input$cap_anesthesie_heure_remarque != "" & exists("obs_id")){
 #   if (exists("compteur") & compteur == "insert"){
        quoi<<- "cap_anesthesie_heure_remarque"
        valeur<<-input$cap_anesthesie_heure_remarque
        source("scripts/server_insert_update_variables_observation.R")
        reloadData()
#       }
    }
  })
  
  observeEvent(input$cap_reveil_heure_remarque, {variable <- 39;
    if (input$cap_reveil_heure_remarque != "" & exists("obs_id")){
 #   if (exists("compteur") & compteur == "insert"){
        quoi<<- "cap_reveil_heure_remarque"
        valeur<<-input$cap_reveil_heure_remarque
        source("scripts/server_insert_update_variables_observation.R")
        reloadData()
#       }
    }
  })
  
  observeEvent(input$cap_dose_acepro_remarque, {variable <- 40;
    if (input$cap_dose_acepro_remarque != "" & exists("obs_id")){
# #   if (exists("compteur") & compteur == "insert"){
        quoi<<- "cap_dose_acepro_remarque"
        valeur<<-input$cap_dose_acepro_remarque
        source("scripts/server_insert_update_variables_observation.R")
        reloadData()
#       } else {compteur<<-"insert"}
    }
  })

  
###################################################
######### Maj variables de capture onglet 2 #######
###################################################
  #########################################################################
  ###################### sabot    #########################################
  #########################################################################  
  
  observeEvent(input$cap_num_sabot, { variable <- 1; 
  if (input$cap_num_sabot != "" & exists("obs_id")){
    quoi<<- "cap_num_sabot"
    valeur<<-input$cap_num_sabot
    source("scripts/server_insert_update_variables_observation.R")
    reloadData()
  }
  }) 
  
  
  #########################################################################
  ###################### Poids    #########################################
  #########################################################################  
 
  #########################observer sur quel echantillon    
  observeEvent(input$variable_8, {variable <- 41;
    if (input$variable_8 != "" & exists("obs_id")) {
    updateNumericInput(session,inputId = "variable_8_valeur", value = former_val(input$variable_8));
    #updateTimeInput(session,inputId = "variable_8_heure", value = paste(date(Sys.time()),substr(former_val(paste0(input$variable_8,"_heure"),1,8)," CET"));
    updateTextInput(session,inputId = "variable_8_rq", value = former_val(paste0(input$variable_8,"_remarque")));
    if (!is.null(input$variable_8_valeur)){
 #   if (exists("compteur") & compteur == "insert"){
        quoi<<-input$variable_8
        valeur<<-input$variable_8_valeur
        if (!is.null(input$variable_8_heure)) {heure<<-format(input$variable_8_heure, format = "%H:%M:%S")} else {rm(heure)}
        if (!is.null(input$variable_8_rq)) {remarque<<-input$variable_8_rq} else {rm(remarque)}
        source("scripts/server_insert_update_variables_observation.R")
        reloadData()
        poids_p<-enc2utf8(dbGetQuery(con,enc2utf8(paste0("SELECT cap_boite_pleine FROM public.capture_gardouch where ind_id = '",obs_ind_id,"' and obs_date = '",paste0(responses["obs_date"]," 00:00:00+00"),"' ")))[,1])
        poids_v<-enc2utf8(dbGetQuery(con,enc2utf8(paste0("SELECT cap_boite_vide FROM public.capture_gardouch where ind_id = '",obs_ind_id,"' and obs_date = '",paste0(responses["obs_date"]," 00:00:00+00"),"' ")))[,1])
        if(!is.na(trimws(poids_p)) & !is.na(trimws(poids_v))) {
          quoi<<-"cap_poids"
          valeur<<-as.character(as.numeric(trimws(poids_p))- as.numeric(trimws(poids_v)))
          if (!is.null(input$variable_8_heure)) {heure<<-format(input$variable_8_heure, format = "%H:%M:%S")} else {rm(heure)}
          if (!is.null(input$variable_8_rq)) {remarque<<-input$variable_8_rq} else {rm(remarque)}
          source("scripts/server_insert_update_variables_observation.R")
          reloadData()
        #}
       }
    }}
  })
  #########################observer nbre échant
  observeEvent(input$variable_8_valeur, {variable <- 42;
    if (input$variable_8 != "" & exists("obs_id") & !is.null(input$variable_8_valeur)){
 #   if (exists("compteur") & compteur == "insert"){
        quoi<<-input$variable_8
        valeur<<-input$variable_8_valeur
        if (!is.null(input$variable_8_heure)) {heure<<-format(input$variable_8_heure, format = "%H:%M:%S")} else {rm(heure)}
        if (!is.null(input$variable_8_rq)) {remarque<<-input$variable_8_rq} else {rm(remarque)}
        source("scripts/server_insert_update_variables_observation.R")
        reloadData()
        poids_p<-enc2utf8(dbGetQuery(con,enc2utf8(paste0("SELECT cap_boite_pleine FROM public.capture_gardouch where ind_id = '",obs_ind_id,"' and obs_date = '",paste0(responses["obs_date"]," 00:00:00+00"),"' ")))[,1])
        poids_v<-enc2utf8(dbGetQuery(con,enc2utf8(paste0("SELECT cap_boite_vide FROM public.capture_gardouch where ind_id = '",obs_ind_id,"' and obs_date = '",paste0(responses["obs_date"]," 00:00:00+00"),"' ")))[,1])
        if(!is.na(trimws(poids_p)) & !is.na(trimws(poids_v))) {
          quoi<<-"cap_poids"
          valeur<<-as.character(as.numeric(trimws(poids_p))- as.numeric(trimws(poids_v)))
          if (!is.null(input$variable_8_heure)) {heure<<-format(input$variable_8_heure, format = "%H:%M:%S")} else {rm(heure)}
          if (!is.null(input$variable_8_rq)) {remarque<<-input$variable_8_rq} else {rm(remarque)}
          source("scripts/server_insert_update_variables_observation.R")
          reloadData()
 #       }
           }
    }
  })
  #########################observer heure
  observeEvent(input$variable_8_heure, {variable <- 43;
    if (format(input$variable_8_heure, format = "%H:%M:%S") != "00:00:00" & exists("obs_id") & !is.null(input$variable_8_valeur) & input$variable_8 != ""){
 #   if (exists("compteur") & compteur == "insert"){
        quoi<<-input$variable_8
        valeur<<-input$variable_8_valeur
        if (!is.null(input$variable_8_heure)) {heure<<-format(input$variable_8_heure, format = "%H:%M:%S")} else {rm(heure)}
        if (!is.null(input$variable_8_rq)) {remarque<<-input$variable_8_rq} else {rm(remarque)}
        source("scripts/server_insert_update_variables_observation.R")
        reloadData()
#       }
    }
  })
  #########################observer remarque
  observeEvent(input$variable_8_rq, {variable <- 44;
    if (input$variable_8 != "" & exists("obs_id") & !is.null(input$variable_8_valeur) & input$variable_8_rq != ""){
 #   if (exists("compteur") & compteur == "insert"){
        quoi<<-input$variable_8
        valeur<<-input$variable_8_valeur
        if (!is.null(input$variable_8_heure)) {heure<<-format(input$variable_8_heure, format = "%H:%M:%S")} else {rm(heure)}
        if (!is.null(input$variable_8_rq)) {remarque<<-input$variable_8_rq} else {rm(remarque)}
        source("scripts/server_insert_update_variables_observation.R")
        reloadData()
#       }
    }
  })
  
###########################################################################
################################# heures et durées ########################
###########################################################################  
    #########################observer variable 
  observeEvent(input$variable_15, {
  if (input$variable_15 != "" & exists("obs_id")) {
    updateNumericInput(session,inputId = "variable_15_valeur", value = former_val(input$variable_15));
    #updateTimeInput(session,inputId = "variable_15_heure", value = paste(date(Sys.time()),substr(former_val(paste0(input$variable_15,"_heure"),1,8)," CET"));
    updateTextInput(session,inputId = "variable_15_rq", value = former_val(paste0(input$variable_15,"_remarque")));
    if (!is.null(input$variable_15_valeur) & !is.na(input$variable_15_valeur)){
      #   if (exists("compteur") & compteur == "insert"){ ####ici compteur (1) lors du premier passage (car incrémenté par le passage de la boucle au dessuus) mais il est inférieur à variable (2) lors du premier passage donc on fait rien et compteur devient 2 etc etc 
      quoi<<-input$variable_15
      valeur<<-input$variable_15_valeur
      if (!is.null(input$variable_15_heure)) {heure<<-format(input$variable_15_heure, format = "%H:%M:%S")} else {rm(heure)}
      if (!is.null(input$variable_15_rq)) {remarque<<-input$variable_15_rq} else {rm(remarque)}
      source("scripts/server_insert_update_variables_observation.R")
      reloadData()
      # }
    }}
  })
  #########################observer nbre échant
  observeEvent(input$variable_15_valeur, {variable <- 3;
  if (input$variable_15 != "" & exists("obs_id") & !is.null(input$variable_15_valeur)){
    #   if (exists("compteur") & compteur == "insert"){
    quoi<<-input$variable_15
    valeur<<-input$variable_15_valeur
    if (!is.null(input$variable_15_heure)) {heure<<-format(input$variable_15_heure, format = "%H:%M:%S")} else {rm(heure)}
    if (!is.null(input$variable_15_rq)) {remarque<<-input$variable_15_rq} else {rm(remarque)}
    source("scripts/server_insert_update_variables_observation.R")
    reloadData()
    #       }
  }
  })
  #########################observer heure
  observeEvent(input$variable_15_heure, {variable <- 4;
  if (format(input$variable_15_heure, format = "%H:%M:%S") != "00:00:00" & exists("obs_id") & !is.null(input$variable_15_valeur) & input$variable_15 != ""){
    #   if (exists("compteur") & compteur == "insert"){
    quoi<<-input$variable_15
    valeur<<-input$variable_15_valeur
    if (!is.null(input$variable_15_heure)) {heure<<-format(input$variable_15_heure, format = "%H:%M:%S")} else {rm(heure)}
    if (!is.null(input$variable_15_rq)) {remarque<<-input$variable_15_rq} else {rm(remarque)}
    source("scripts/server_insert_update_variables_observation.R")
    reloadData()
    #       }
  }
  })
  #########################observer remarque
  observeEvent(input$variable_15_rq, {variable <- 5;
  if (input$variable_15 != "" & exists("obs_id") & !is.null(input$variable_15_valeur) & input$variable_15_rq != ""){
    #   if (exists("compteur") & compteur == "insert"){
    quoi<<-input$variable_15
    valeur<<-input$variable_15_valeur
    if (!is.null(input$variable_15_heure)) {heure<<-format(input$variable_15_heure, format = "%H:%M:%S")} else {rm(heure)}
    if (!is.null(input$variable_15_rq)) {remarque<<-input$variable_15_rq} else {rm(remarque)}
    source("scripts/server_insert_update_variables_observation.R")
    reloadData()
    #       }
  }
  })
  
  #########################################################################
  ###################### Mensurations #####################################
  #########################################################################  
  
  #########################observer quoi    
  observeEvent(input$variable_5, {variable <- 45;
  if (input$variable_5 != "" & exists("obs_id")) {
    updateNumericInput(session,inputId = "variable_5_valeur", value = former_val(input$variable_5));
    #updateTimeInput(session,inputId = "variable_5_heure", value = paste(date(Sys.time()),substr(former_val(paste0(input$variable_5,"_heure"),1,8)," CET"));
    updateTextInput(session,inputId = "variable_5_rq", value = former_val(paste0(input$variable_5,"_remarque")));
    if (!is.null(input$variable_5_valeur) & !is.na(input$variable_5_valeur)){
 #   if (exists("compteur") & compteur == "insert"){
      quoi<<-input$variable_5
      valeur<<-input$variable_5_valeur
      if (!is.null(input$variable_5_heure)) {heure<<-format(input$variable_5_heure, format = "%H:%M:%S")} else {rm(heure)}
      if (!is.null(input$variable_5_rq)) {remarque<<-input$variable_5_rq} else {rm(remarque)}
      source("scripts/server_insert_update_variables_observation.R")
      reloadData()
#       }
    }}
  })
  #########################observer valeur
  observeEvent(input$variable_5_valeur, {variable <- 46;
    if (input$variable_5 != "" & exists("obs_id") & !is.null(input$variable_5_valeur)){
 #   if (exists("compteur") & compteur == "insert"){
      quoi<<-input$variable_5
      valeur<<-input$variable_5_valeur
      if (!is.null(input$variable_5_heure)) {heure<<-format(input$variable_5_heure, format = "%H:%M:%S")} else {rm(heure)}
      if (!is.null(input$variable_5_rq)) {remarque<<-input$variable_5_rq} else {rm(remarque)}
      source("scripts/server_insert_update_variables_observation.R")
      reloadData()
#       }
    }
  })
  #########################observer heure
  observeEvent(input$variable_5_heure, {variable <- 47;
    if (format(input$variable_5_heure, format = "%H:%M:%S") != "00:00:00" & exists("obs_id") & !is.null(input$variable_5_valeur) & input$variable_5 != ""){
 #   if (exists("compteur") & compteur == "insert"){
      quoi<<-input$variable_5
      valeur<<-input$variable_5_valeur
      if (!is.null(input$variable_5_heure)) {heure<<-format(input$variable_5_heure, format = "%H:%M:%S")} else {rm(heure)}
      if (!is.null(input$variable_5_rq)) {remarque<<-input$variable_5_rq} else {rm(remarque)}
      source("scripts/server_insert_update_variables_observation.R")
      reloadData()
#       }
    }
  })
  #########################observer remarque
  observeEvent(input$variable_5_rq, {variable <- 48;
    if (input$variable_5 != "" & exists("obs_id") & !is.null(input$variable_5_valeur) & input$variable_5_rq != ""){
 #   if (exists("compteur") & compteur == "insert"){
      quoi<<-input$variable_5
      valeur<<-input$variable_5_valeur
      if (!is.null(input$variable_5_heure)) {heure<<-format(input$variable_5_heure, format = "%H:%M:%S")} else {rm(heure)}
      if (!is.null(input$variable_5_rq)) {remarque<<-input$variable_5_rq} else {rm(remarque)}
      source("scripts/server_insert_update_variables_observation.R")
      reloadData()
#       }
    }
  })
  
  #########################################################################
  ###################### Mesures ponctuelles ##############################
  #########################################################################  
    #########################observer quoi    
  observeEvent(input$variable_6, {variable <- 45;
  if (input$variable_6 != "" & exists("obs_id")) {
    updateNumericInput(session,inputId = "variable_6_valeur", value = former_val(input$variable_6));
    updateTimeInput(session,inputId = "variable_6_heure", value = paste(date(Sys.time()),substr(former_val(paste0(input$variable_6,"_heure")),1,8)," CET"));
    updateTextInput(session,inputId = "variable_6_rq", value = former_val(paste0(input$variable_6,"_remarque")));
    if (!is.null(input$variable_6_valeur) & !is.na(input$variable_6_valeur)){
      #   if (exists("compteur") & compteur == "insert"){
      quoi<<-input$variable_6
      valeur<<-input$variable_6_valeur
      if (!is.null(input$variable_6_heure)) {heure<<-format(input$variable_6_heure, format = "%H:%M:%S")} else {rm(heure)}
      if (!is.null(input$variable_6_rq)) {remarque<<-input$variable_6_rq} else {rm(remarque)}
      source("scripts/server_insert_update_variables_observation.R")
      reloadData()
      #       }
    }}
  })
  #########################observer valeur
  observeEvent(input$variable_6_valeur, {variable <- 49;
  if (input$variable_6 != "" & exists("obs_id") &!is.null(input$variable_6_valeur)) {
      quoi<<-input$variable_6
      valeur<<-input$variable_6_valeur
      if (!is.null(input$variable_6_heure)) {heure<<-format(input$variable_6_heure, format = "%H:%M:%S")} else {rm(heure)}
      if (!is.null(input$variable_6_rq)) {remarque<<-input$variable_6_rq} else {rm(remarque)}
      source("scripts/server_insert_update_variables_observation.R")
      reloadData()
  }
  })
  #########################observer heure , l'heure est une variable ici
  observeEvent(input$variable_6_heure, {
    if (format(input$variable_6_heure, format = "%H:%M:%S") != "00:00:00" & exists("obs_id") & !is.null(input$variable_6_valeur) & input$variable_6 != ""){
      quoi<<-paste0(input$variable_6,"_heure")
      valeur<<-format(input$variable_6_heure, format = "%H:%M:%S")
      remarque<<-input$variable_6_rq
      source("scripts/server_insert_update_variables_observation.R")
      reloadData()

    }
  })
  
  observeEvent(input$cap_anesthesie_heure, {variable <- 34;
  if (format(input$cap_anesthesie_heure, format = "%H:%M:%S") != "00:00:00" & exists("obs_id")){
    #   if (exists("compteur") & compteur == "insert"){
    quoi<<- "cap_anesthesie_heure"
    valeur<<-format(input$cap_anesthesie_heure, format = "%H:%M:%S")
    source("scripts/server_insert_update_variables_observation.R")
    reloadData()
    #       }
  }
  })
  
  #########################observer remarque    
  observeEvent(input$variable_6_rq, { variable <- 51;
    if (input$variable_6 != "" & exists("obs_id") & !is.null(input$variable_6_valeur) & input$variable_6_rq != ""){
 #   if (exists("compteur") & compteur == "insert"){
      quoi<<-input$variable_6
      valeur<<-input$variable_6_valeur
      heure<<-format(input$variable_6_heure, format = "%H:%M:%S")
      remarque<<-input$variable_6_rq
      source("scripts/server_insert_update_variables_observation.R")
      reloadData()
#       }
    }
  })
  
  
  
  #########################################################################
  ###################### Mesures répétées #################################
  #########################################################################  
  
  #########################observer quoi
  observeEvent(input$variable_7, { variable <- 52;
    if (input$variable_7 != "" & exists("obs_id")) { ##########DANS LE CAS DE MESURES REPETEES ON NE PEUT PAS RAPPELER LES DONNEES
     updateNumericInput(session,inputId = "variable_7_valeur", value = NA);
     updateTimeInput(session,inputId = "variable_7_heure", value = NULL);
     updateTextInput(session,inputId = "variable_7_rq", value = "");
    if (!is.null(input$variable_7_valeur) & !is.na(input$variable_7_valeur)){
 #   if (exists("compteur") & compteur == "insert"){
      quoi<<-input$variable_7
      valeur<<-input$variable_7_valeur
      if (!is.null(input$variable_7_heure)) {heure<<-format(input$variable_7_heure, format = "%H:%M:%S")} else {rm(heure)}
      if (!is.null(input$variable_7_rq)) {remarque<<-input$variable_7_rq} else {rm(remarque)}
      source("scripts/server_insert_update_variables_observation.R")
      reloadData()
#       }
    }}
  })
  #########################observer valeur
  observeEvent(input$variable_7_valeur, { variable <- 53;
    if (input$variable_7 != "" & exists("obs_id") & !is.null(input$variable_7_valeur) & format(input$variable_7_heure, format = "%H:%M:%S") != "00:00:00" & !is.null(input$variable_7_heure)){
 #   if (exists("compteur") & compteur == "insert"){
      quoi<<-input$variable_7
      valeur<<-input$variable_7_valeur
      if (!is.null(input$variable_7_heure)) {heure<<-format(input$variable_7_heure, format = "%H:%M:%S")} else {rm(heure)}
      if (!is.null(input$variable_7_rq)) {remarque<<-input$variable_7_rq} else {rm(remarque)}
      source("scripts/server_insert_update_variables_observation.R")
      reloadData()
#       }
    }
  })
  #########################observer heure
  onclick("valid", { #######il y a ici un bouton de validation car sinon on met à jour pour chaque valeur d'heure
    if (format(input$variable_7_heure, format = "%H:%M:%S") != "00:00:00" & exists("obs_id") & !is.null(input$variable_7_valeur) & input$variable_7 != ""){
 #   if (exists("compteur") & compteur == "insert"){
      quoi<<-input$variable_7
      valeur<<-input$variable_7_valeur
      if (!is.null(input$variable_7_heure)) {heure<<-format(input$variable_7_heure, format = "%H:%M:%S")} else {rm(heure)}
      if (!is.null(input$variable_7_rq)) {remarque<<-input$variable_7_rq} else {rm(remarque)}
      source("scripts/server_insert_update_variables_observation.R")
      updateNumericInput(session,inputId = "variable_7_valeur", value = NA);
      updateTimeInput(session,inputId = "variable_7_heure", value = NA);
      updateTextInput(session,inputId = "variable_7_rq", value = "");
      updateSelectInput(session,inputId = "variable_7", selected = "");
#       }
    }
  })
  #########################observer remarque
  observeEvent(input$variable_7_rq, { variable <- 55;
    if (input$variable_7 != "" & exists("obs_id") & !is.null(input$variable_7_valeur) & input$variable_7_rq != ""){
 #   if (exists("compteur") & compteur == "insert"){
      quoi<<-input$variable_7
      valeur<<-input$variable_7_valeur
      if (!is.null(input$variable_7_heure)) {heure<<-format(input$variable_7_heure, format = "%H:%M:%S")} else {rm(heure)}
      if (!is.null(input$variable_7_rq)) {remarque<<-input$variable_7_rq} else {rm(remarque)}
      source("scripts/server_insert_update_variables_observation.R")
      reloadData()
#       }
    }
  })
  

###################################################
######### Maj variables de capture onglet 3 #######
###################################################  
  #########################observer met a jour les listes de choix (choices) en fonction du choix de l'utilisateur
  observeEvent(input$variable_10, { #print(input$variable_10)
  if (input$variable_10 == "cap_filet_cri") {updateSelectInput(session, inputId = "variable_10_valeur", label = "Valeur", choices = list(votre_choix = "","0","1","2",">2"))} else {
    updateSelectInput(session, inputId = "variable_10_valeur", label = "Valeur", choices = list(votre_choix = "",oui = TRUE,non = FALSE))
  }
    
  })
  observeEvent(input$variable_13, {
    if (input$variable_13 == "cap_tble_cri_bague" | input$variable_13 == "cap_tble_cri_autre") {updateSelectInput(session, inputId = "variable_13_valeur", label = "Valeur", choices = list(votre_choix = "","0","1","2",">2"))} else {
      updateSelectInput(session, inputId = "variable_13_valeur", label = "Valeur", choices = list(votre_choix = "",oui = TRUE,non = FALSE))
    }
    
  })
  #########################cmpt filet
  observeEvent(input$variable_10, { 
    if (input$variable_10 != "" & exists("obs_id")) {
      updateSelectInput(session,inputId = "variable_10_valeur", selected = fifelse(former_val(input$variable_10) == "false", FALSE, TRUE));
      #updateTimeInput(session,inputId = "variable_10_heure", value = paste(date(Sys.time()),substr(former_val(paste0(input$variable_10,"_heure"),1,8)," CET"));
      updateTextInput(session,inputId = "variable_10_rq", value = former_val(paste0(input$variable_10,"_remarque")));
      if (input$variable_10_valeur != "" & !is.na(input$variable_10_valeur)){
        quoi<<-input$variable_10
        valeur<<-input$variable_10_valeur
        if (!is.null(input$variable_10_heure)) {heure<<-format(input$variable_10_heure, format = "%H:%M:%S")} else {rm(heure)}
        if (!is.null(input$variable_10_rq)) {remarque<<-input$variable_10_rq} else {rm(remarque)}
        source("scripts/server_insert_update_variables_observation.R")
        reloadData()
        #       }
      }}
  })
  #########################observer nbre échant
  observeEvent(input$variable_10_valeur, {variable <- 3;
  if (input$variable_10 != "" & exists("obs_id") & !is.null(input$variable_10_valeur)){
    #   if (exists("compteur") & compteur == "insert"){
    quoi<<-input$variable_10
    valeur<<-input$variable_10_valeur
    if (!is.null(input$variable_10_heure)) {heure<<-format(input$variable_10_heure, format = "%H:%M:%S")} else {rm(heure)}
    if (!is.null(input$variable_10_rq)) {remarque<<-input$variable_10_rq} else {rm(remarque)}
    source("scripts/server_insert_update_variables_observation.R")
    reloadData()
    #       }
  }
  })
  
  #########################observer heure
  observeEvent(input$variable_10_heure, {variable <- 20;
  if (format(input$variable_10_heure, format = "%H:%M:%S") != "00:00:00" & exists("obs_id") & !is.null(input$variable_10_valeur) & input$variable_10 != ""){
    #   if (exists("compteur") & compteur == "insert"){
    quoi<<-input$variable_10
    valeur<<-input$variable_10_valeur
    if (!is.null(input$variable_10_heure)) {heure<<-format(input$variable_10_heure, format = "%H:%M:%S")} else {rm(heure)}
    if (!is.null(input$variable_10_rq)) {remarque<<-input$variable_10_rq} else {rm(remarque)}
    source("scripts/server_insert_update_variables_observation.R")
    reloadData()
    #       }
  }
  })
  #########################observer remarque
  observeEvent(input$variable_10_rq, {variable <- 21;
  if (input$variable_10 != "" & exists("obs_id") & !is.null(input$variable_10_valeur) & input$variable_10_rq != ""){
    #   if (exists("compteur") & compteur == "insert"){
    quoi<<-input$variable_10
    valeur<<-input$variable_10_valeur
    if (!is.null(input$variable_10_heure)) {heure<<-format(input$variable_10_heure, format = "%H:%M:%S")} else {rm(heure)}
    if (!is.null(input$variable_10_rq)) {remarque<<-input$variable_10_rq} else {rm(remarque)}
    source("scripts/server_insert_update_variables_observation.R")
    reloadData()
    #       }
  }
  })
  
  #########################cmpt sabot
  observeEvent(input$variable_11, {
    if (input$variable_11 != "" & exists("obs_id")) {
      updateSelectInput(session,inputId = "variable_11_valeur", selected = fifelse(former_val(input$variable_11) == "false", FALSE, TRUE));
      #updateTimeInput(session,inputId = "variable_11_heure", value = paste(date(Sys.time()),substr(former_val(paste0(input$variable_11,"_heure"),1,8)," CET"));
      updateTextInput(session,inputId = "variable_11_rq", value = former_val(paste0(input$variable_11,"_remarque")));
      if (input$variable_11_valeur != "" & !is.na(input$variable_11_valeur)){
        quoi<<-input$variable_11
        valeur<<-input$variable_11_valeur
        if (!is.null(input$variable_11_heure)) {heure<<-format(input$variable_11_heure, format = "%H:%M:%S")} else {rm(heure)}
        if (!is.null(input$variable_11_rq)) {remarque<<-input$variable_11_rq} else {rm(remarque)}
        source("scripts/server_insert_update_variables_observation.R")
        reloadData()
        #       }
      }}
  })
  #########################observer nbre échant
  observeEvent(input$variable_11_valeur, {variable <- 3;
  if (input$variable_11 != "" & exists("obs_id") & !is.null(input$variable_11_valeur)){
    #   if (exists("compteur") & compteur == "insert"){
    quoi<<-input$variable_11
    valeur<<-input$variable_11_valeur
    if (!is.null(input$variable_11_heure)) {heure<<-format(input$variable_11_heure, format = "%H:%M:%S")} else {rm(heure)}
    if (!is.null(input$variable_11_rq)) {remarque<<-input$variable_11_rq} else {rm(remarque)}
    source("scripts/server_insert_update_variables_observation.R")
    reloadData()
    #       }
  }
  })
  
  #########################observer heure
  observeEvent(input$variable_11_heure, {variable <- 20;
  if (format(input$variable_11_heure, format = "%H:%M:%S") != "00:00:00" & exists("obs_id") & !is.null(input$variable_11_valeur) & input$variable_11 != ""){
    #   if (exists("compteur") & compteur == "insert"){
    quoi<<-input$variable_11
    valeur<<-input$variable_11_valeur
    if (!is.null(input$variable_11_heure)) {heure<<-format(input$variable_11_heure, format = "%H:%M:%S")} else {rm(heure)}
    if (!is.null(input$variable_11_rq)) {remarque<<-input$variable_11_rq} else {rm(remarque)}
    source("scripts/server_insert_update_variables_observation.R")
    reloadData()
    #       }
  }
  })
  #########################observer remarque
  observeEvent(input$variable_11_rq, {variable <- 21;
  if (input$variable_11 != "" & exists("obs_id") & !is.null(input$variable_11_valeur) & input$variable_11_rq != ""){
    #   if (exists("compteur") & compteur == "insert"){
    quoi<<-input$variable_11
    valeur<<-input$variable_11_valeur
    if (!is.null(input$variable_11_heure)) {heure<<-format(input$variable_11_heure, format = "%H:%M:%S")} else {rm(heure)}
    if (!is.null(input$variable_11_rq)) {remarque<<-input$variable_11_rq} else {rm(remarque)}
    source("scripts/server_insert_update_variables_observation.R")
    reloadData()
    #       }
  }
  })
  
  #########################Observateurs sabot
  observeEvent(input$variable_12, { variable <- 1; 
  if (input$variable_12 != "" & exists("obs_id")){ 
    #   if (exists("compteur") & compteur == "insert"){ 
    quoi<<- "cap_sabot_observateur"
    valeur<<-input$variable_12
    source("scripts/server_insert_update_variables_observation.R")
    reloadData()
    #  }
  }
  })
  
  #########################cmpt Table
  observeEvent(input$variable_13, {
    if (input$variable_13 != "" & exists("obs_id")) {
      updateSelectInput(session,inputId = "variable_13_valeur", selected = fifelse(former_val(input$variable_13) == "false", FALSE, TRUE));
      #updateTimeInput(session,inputId = "variable_13_heure", value = paste(date(Sys.time()),substr(former_val(paste0(input$variable_13,"_heure"),1,8)," CET"));
      updateTextInput(session,inputId = "variable_13_rq", value = former_val(paste0(input$variable_13,"_remarque")));
      if (input$variable_13_valeur != "" & !is.na(input$variable_13_valeur)){
        quoi<<-input$variable_13
        valeur<<-input$variable_13_valeur
        if (!is.null(input$variable_13_heure)) {heure<<-format(input$variable_13_heure, format = "%H:%M:%S")} else {rm(heure)}
        if (!is.null(input$variable_13_rq)) {remarque<<-input$variable_13_rq} else {rm(remarque)}
        source("scripts/server_insert_update_variables_observation.R")
        reloadData()
        #       }
      }}
  })
  #########################observer nbre échant
  observeEvent(input$variable_13_valeur, {variable <- 3;
  if (input$variable_13 != "" & exists("obs_id") & !is.null(input$variable_13_valeur)){
    #   if (exists("compteur") & compteur == "insert"){
    quoi<<-input$variable_13
    valeur<<-input$variable_13_valeur
    if (!is.null(input$variable_13_heure)) {heure<<-format(input$variable_13_heure, format = "%H:%M:%S")} else {rm(heure)}
    if (!is.null(input$variable_13_rq)) {remarque<<-input$variable_13_rq} else {rm(remarque)}
    source("scripts/server_insert_update_variables_observation.R")
    reloadData()
    #       }
  }
  })
  
  #########################observer heure
  observeEvent(input$variable_13_heure, {variable <- 20;
  if (format(input$variable_13_heure, format = "%H:%M:%S") != "00:00:00" & exists("obs_id") & !is.null(input$variable_13_valeur) & input$variable_13 != ""){
    #   if (exists("compteur") & compteur == "insert"){
    quoi<<-input$variable_13
    valeur<<-input$variable_13_valeur
    if (!is.null(input$variable_13_heure)) {heure<<-format(input$variable_13_heure, format = "%H:%M:%S")} else {rm(heure)}
    if (!is.null(input$variable_13_rq)) {remarque<<-input$variable_13_rq} else {rm(remarque)}
    source("scripts/server_insert_update_variables_observation.R")
    reloadData()
    #       }
  }
  })
  #########################observer remarque
  observeEvent(input$variable_13_rq, {variable <- 21;
  if (input$variable_13 != "" & exists("obs_id") & !is.null(input$variable_13_valeur) & input$variable_13_rq != ""){
    #   if (exists("compteur") & compteur == "insert"){
    quoi<<-input$variable_13
    valeur<<-input$variable_13_valeur
    if (!is.null(input$variable_13_heure)) {heure<<-format(input$variable_13_heure, format = "%H:%M:%S")} else {rm(heure)}
    if (!is.null(input$variable_13_rq)) {remarque<<-input$variable_13_rq} else {rm(remarque)}
    source("scripts/server_insert_update_variables_observation.R")
    reloadData()
    #       }
  }
  })
  
  #########################cmpt Lacher: observeur variable
  observeEvent(input$variable_14, {
    if (input$variable_14 != "" & exists("obs_id")) {
      updateSelectInput(session,inputId = "variable_14_valeur", selected = fifelse(former_val(input$variable_14) == "false", FALSE, TRUE));
      #updateTimeInput(session,inputId = "variable_14_heure", value = paste(date(Sys.time()),substr(former_val(paste0(input$variable_14,"_heure"),1,8)," CET"));
      updateTextInput(session,inputId = "variable_14_rq", value = former_val(paste0(input$variable_14,"_remarque")));
      if (input$variable_14_valeur != "" & !is.na(input$variable_14_valeur)){
        quoi<<-input$variable_14
        valeur<<-input$variable_14_valeur
        if (!is.null(input$variable_14_heure)) {heure<<-format(input$variable_14_heure, format = "%H:%M:%S")} else {rm(heure)}
        if (!is.null(input$variable_14_rq)) {remarque<<-input$variable_14_rq} else {rm(remarque)}
        source("scripts/server_insert_update_variables_observation.R")
        reloadData()
        #       }
      }}
  })
  #########################observer valeur
  observeEvent(input$variable_14_valeur, {variable <- 3;
  if (input$variable_14 != "" & exists("obs_id") & !is.null(input$variable_14_valeur)){
    #   if (exists("compteur") & compteur == "insert"){
    quoi<<-input$variable_14
    valeur<<-input$variable_14_valeur
    if (!is.null(input$variable_14_heure)) {heure<<-format(input$variable_14_heure, format = "%H:%M:%S")} else {rm(heure)}
    if (!is.null(input$variable_14_rq)) {remarque<<-input$variable_14_rq} else {rm(remarque)}
    source("scripts/server_insert_update_variables_observation.R")
    reloadData()
    #       }
  }
  })
  
  #########################observer heure
  observeEvent(input$variable_14_heure, {variable <- 20;
  if (format(input$variable_14_heure, format = "%H:%M:%S") != "00:00:00" & exists("obs_id") & !is.null(input$variable_14_valeur) & input$variable_14 != ""){
    #   if (exists("compteur") & compteur == "insert"){
    quoi<<-input$variable_14
    valeur<<-input$variable_14_valeur
    if (!is.null(input$variable_14_heure)) {heure<<-format(input$variable_14_heure, format = "%H:%M:%S")} else {rm(heure)}
    if (!is.null(input$variable_14_rq)) {remarque<<-input$variable_14_rq} else {rm(remarque)}
    source("scripts/server_insert_update_variables_observation.R")
    reloadData()
    #       }
  }
  })
  #########################observer remarque
  observeEvent(input$variable_14_rq, {variable <- 21;
  if (input$variable_14 != "" & exists("obs_id") & !is.null(input$variable_14_valeur) & input$variable_14_rq != ""){
    #   if (exists("compteur") & compteur == "insert"){
    quoi<<-input$variable_14
    valeur<<-input$variable_14_valeur
    if (!is.null(input$variable_14_heure)) {heure<<-format(input$variable_14_heure, format = "%H:%M:%S")} else {rm(heure)}
    if (!is.null(input$variable_14_rq)) {remarque<<-input$variable_14_rq} else {rm(remarque)}
    source("scripts/server_insert_update_variables_observation.R")
    reloadData()
    #       }
  }
  })  
  #########################cap_lacher_visibilite
  observeEvent(input$cap_lache_visibilite, { 
  if (input$cap_lache_visibilite != "" & exists("obs_id")){ 
    #   if (exists("compteur") & compteur == "insert"){ 
    quoi<<- "cap_lache_visibilite"
    valeur<<-input$cap_lache_visibilite
    source("scripts/server_insert_update_variables_observation.R")
    reloadData()
    #  }
  }
  })
  
  #########################cap_lache_nbre_stop
  observeEvent(input$cap_lache_nbre_stop, { variable <- 1; 
  if (input$cap_lache_nbre_stop != "" & exists("obs_id")){ 
    #   if (exists("compteur") & compteur == "insert"){ 
    quoi<<- "cap_lache_nbre_stop"
    valeur<<-input$cap_lache_nbre_stop
    source("scripts/server_insert_update_variables_observation.R")
    reloadData()
    #  }
  }
  })
  
  #########################cap_lache_public
  observeEvent(input$cap_lache_public, { variable <- 1; 
  if (input$cap_lache_public != "" & exists("obs_id")){ 
    #   if (exists("compteur") & compteur == "insert"){ 
    quoi<<- "cap_lache_public"
    valeur<<-input$cap_lache_public
    source("scripts/server_insert_update_variables_observation.R")
    reloadData()
    #  }
  }
  })


#########################################
#############Loading functions###########
#########################################  
 
    loadData <- function() {  ######diffère en fonction que l'on est sur l'onglet A, B ou C
      
      if (isolate(input$tabs) == "A"){
      rm(registre, envir =.GlobalEnv);
      registre<<-utf8(as.data.frame(dbGetQuery(con,paste0("SELECT ani_n_inra,ani_nom_registre,ani_transpondeur_id,obs_date, cap_collier,cap_echt_peau,cap_echt_poil_cou,cap_echt_feces,cap_echt_poil_croupe,cap_echt_sang_rouge,cap_echt_sang_violet,cap_echt_sang_bleu,cap_echt_sang_vert,cap_echt_tique,cap_echt_salive_1,cap_echt_salive_2,cap_echt_nasal,cap_echt_vag,cap_cnt_tiques_oreille,cap_cnt_tiques_gorgees,cap_cnt_tiques, cap_tiques_pres,cap_puces_pres,cap_puces_pres_remarque,cap_poux_pres_remarque,cap_poux_pres,cap_poux_pres_remarque,cap_hypobosq_pres,cap_hypobosq_pres_remarque,cap_bois_velour,cap_bois_velour_remarque,cap_bois_dur,cap_bois_dur_remarque,cap_bois_tombe,cap_bois_tombe_remarque,NULL cap_bois_scies,cap_allaitante,cap_allaitante_remarque,cap_diarrhee,cap_diarrhee_remarque,cap_blessure ,cap_traitement, cap_anesthesie,cap_anesthesie_heure, cap_heure_reveil,cap_acepromazine_bol,cap_dose_acepromazine,cap_tranquilisant,ani_date_depart 
                                                     from capture_gardouch, registre_gardouch 
                                                     where capture_gardouch.ind_id = registre_gardouch.ind_id order by ani_nom_registre,obs_date DESC"))))
      registre
      }
      if (isolate(input$tabs) == "B"){
      rm(registre, envir =.GlobalEnv);
      registre<<-utf8(as.data.frame(dbGetQuery(con,paste0("SELECT ani_n_inra,ani_nom_registre,obs_date,cap_boite_pleine,cap_boite_vide,cap_poids, cap_num_sabot, cap_heure_lache,cap_heure_capture,cap_heure_mise_sabot,cap_heure_fin_surv,cap_heure_debut_table,cap_heure_fin_table,cap_heure_lache,cap_heure_second_lache,cap_circ_thorax,cap_longueur_tarse,cap_circ_cou,cap_longueur_machoire,cap_lg_bois_g,cap_lg_bois_d,cap_lg_oreille,cap_cardio_15s_debut,cap_cardio_15s_fin,cap_cardio_20_3_heure,cap_cardio_20_3,cap_cardio_60_3,cap_cardio_20_2_heure,cap_cardio_20_2,cap_cardio_60_2,cap_cardio_20_1_heure,cap_cardio_20_1,cap_cardio_60_1,cap_glycemie_1,cap_glycemie_2,cap_glycemie_3,cap_heure_debut_table,cap_tble_temp_exterieur,cap_tble_temp_animal_moy,cap_respiro_20_1_heure, cap_respiro_20_1,cap_respiro_60_1,cap_respiro_20_2_heure,cap_respiro_20_2,cap_respiro_60_2,cap_respiro_20_3_heure,cap_respiro_20_3,cap_respiro_60_3,cap_temp_ext,cap_tble_temp_animal_moy,cap_temp_rectale_text,cap_temp_rectale_finale,ani_date_depart                                             
                                                      from capture_gardouch, registre_gardouch 
                                                       where capture_gardouch.ind_id = registre_gardouch.ind_id order by ani_nom_registre,obs_date DESC"))))
      registre
      }
      if (isolate(input$tabs) == "C"){
      rm(registre, envir =.GlobalEnv);
      registre<<-utf8(as.data.frame(dbGetQuery(con,paste0("SELECT ani_n_inra,ani_nom_registre,obs_date,cap_arrivee_filet_course,cap_arrivee_filet_pas_vu,cap_filet_panique,cap_filet_lutte,cap_filet_halete,cap_filet_cri,cap_sabot_retournement,cap_sabot_couche,cap_sabot_agitation,cap_tble_lutte,cap_tble_halete,cap_tble_cri_bague,cap_tble_cri_autre,cap_lache_course,cap_lache_bolide,cap_lache_cabriole_saut,cap_lache_gratte_collier,cap_lache_tombe,cap_lache_calme,cap_lache_nbre_stop,cap_lache_cri,cap_lache_titube,cap_lache_couche,cap_lache_visibilite,cap_lache_visibilite, cap_lache_nbre_stop,cap_sabot_observateur, cap_lache_public,cap_lache_remark,ani_date_depart
                                                     from capture_gardouch, registre_gardouch 
                                                     where capture_gardouch.ind_id = registre_gardouch.ind_id order by ani_nom_registre,obs_date DESC"))))
      registre
      }
    }

#########################################
#############RELoading functions#########
#########################################  
#######fonction qui recharge le jeu de données en fonction de l'individu sélectionné
  
   reloadData <- function() {
     loadData()
     if (length(input$obs_date) == 0) {registre<- registre[which(registre[,"ani_nom_registre"] == input$ani_nom_registre),]} else {
     registre<<- registre[which(registre[,"ani_nom_registre"] == input$ani_nom_registre & registre[,"obs_date"] == input$obs_date),]};
     data_table_mesure(registre)
     data_table_comportement(registre)
     data_table_marquage(registre)     
     # output$mesure_long<- DT::renderDataTable({
     #   DT::datatable(registre, options = list(lengthMenu = c(10, 50, 100, 200, 300), pageLength = 250))})
   }


  
  data_table_mesure <- function(registre) {
  output$mesure <- DT::renderDataTable({
    DT::datatable(registre,filter = "top",rownames = F, options = list(lengthMenu = c(10, 50, 100, 200, 300), pageLength = 250))})}

  data_table_comportement <- function(registre) {
  output$comportement <- DT::renderDataTable({
    DT::datatable(registre,filter = "top",rownames = F, options = list(lengthMenu = c(10, 50, 100, 200, 300), pageLength = 250))})}
  
  data_table_marquage <- function(registre) {
  output$marquage <- DT::renderDataTable({
    DT::datatable(registre,filter = "top",rownames = F, options = list(lengthMenu = c(10, 50, 100, 200, 300), pageLength = 250))})}
  
###############################################################################################
############Lance l'enregistrement des données qd submit est cliqué si le controle est ok #####
###############################################################################################
############Stop les mises à jour #############################################################
###############################################################################################  

  # action to take when submit button is pressed
    observeEvent(input$subcol, {
     if (control(formData())){  #####si la fonction controle renvoie TRUE (ie pas d'alerte) alors forme des les données et les enregistre
     saveData(formData())};
    })
  
  observeEvent(input$stop, { ####stop les mises à jours
      reset();
      kill();
   })
  
###############Affichage du table de donnée en fonction de l'onglet sélectionné A, B ou C ##################
###############Action du bouton de trie trie_ani_present suivant que l'on est sur l'onglet A, B ou C   #######
  
observeEvent(input$tabs,{
  if (input$tabs == "A"){
    if (exists("obs_id")){reset_old_val()} ####si une observation est sélectionnée alors on remet les valeurs de l'obs dans les widjets
    if (input$ani_nom_registre != "") {reloadData()} else {
  observeEvent(input$trie_ani_present , {
    if (input$trie_ani_present == TRUE) {
      registre<<- registre[is.na(registre$ani_date_depart),]
      data_table_marquage(registre)
      }
    if (input$trie_ani_present == FALSE) {
      loadData()
      data_table_marquage(registre)    
      }
        })
  }}
  if (input$tabs == "B"){
    if (exists("obs_id")){reset_old_val()}
    if (input$ani_nom_registre != "") {reloadData()} else {
    observeEvent(input$trie_ani_present , {
      if (input$trie_ani_present == TRUE) {
        registre<<- registre[is.na(registre$ani_date_depart),]
        data_table_mesure(registre)      
        }
      if (input$trie_ani_present == FALSE) {
        loadData()
        data_table_mesure(registre)
      }
    })
  }}  
  if (input$tabs == "C"){
    if (exists("obs_id")){reset_old_val()}
    if (input$ani_nom_registre != "") {reloadData()} else {
      observeEvent(input$trie_ani_present , {
        if (input$trie_ani_present == TRUE) {
          registre<<- registre[is.na(registre$ani_date_depart),]
          data_table_comportement(registre)        
          }
        if (input$trie_ani_present == FALSE) {
          loadData()
          data_table_comportement(registre)
        }
      })
    }}
  })
    
#######################################################################################################################################
############ Met les valeurs par défaut des widjets à jour en fonction du n° inra ou du nom de registre sélectionné  ##################
############ Selectionne les données consernées dans le data frame en dessous de la zone de saisie                   ##################
#######################################################################################################################################  

        observeEvent(input$ani_n_inra, {
        if (input$ani_n_inra != 0 & !is.na(input$ani_n_inra)){ print(input$ani_n_inra)
         verif<- dbGetQuery(con,paste0("Select distinct(ind_name) from main.t_individu_ind where ind_obj_id = 1")) ###si on rentre autre chose que des chevreuils à Gardouch à modifier
        if (length(grep(input$ani_n_inra,as.character(verif[,1])))!= 0){
        delay(2000,updateTextInput(session,inputId = "ani_nom_registre", value = utf8(dbGetQuery(con,paste0("SELECT ani_nom_registre from registre_gardouch where ani_n_inra = '",input$ani_n_inra,"' ")))[,1]));
        delay(2000,updateTextInput(session,inputId = "ani_transpondeur_id", value = utf8(dbGetQuery(con,paste0("SELECT ani_transpondeur_id from registre_gardouch where ani_n_inra = '",input$ani_n_inra,"' ")))[,1]));
        registre<<- registre[which(registre[,"ani_n_inra"] == input$ani_n_inra),];
        data_table_marquage(registre)
                  } else {
        updateNumericInput(session,inputId = "ani_n_inra", value = 0)
        updateTextInput(session,inputId = "ani_nom_registre", value = "");  
        updateTextInput(session,inputId = "ani_transpondeur_id", value = "");
                    }}
                   })
  
        observeEvent(input$ani_nom_registre, {
        if (input$ani_nom_registre != ""){ 
        delay(2000,updateNumericInput(session,inputId = "ani_n_inra", value = utf8(dbGetQuery(con,paste0("SELECT ani_n_inra from registre_gardouch where ani_nom_registre = '",input$ani_nom_registre,"' ")))[,1]));
        delay(2000,updateTextInput(session,inputId = "ani_transpondeur_id", value = utf8(dbGetQuery(con,paste0("SELECT ani_transpondeur_id from registre_gardouch where ani_nom_registre  = '",input$ani_nom_registre,"' ")))[,1]));}
        reloadData()
                  })
        
        
##########################################################################################   
############################## entre des valeurs boléennes par défaut. FALSE par défaut ##
##########################################################################################   
        
        set_false <- function() {
        quoi<<- "cap_puces_pres"
        valeur<<-input$cap_puces_pres
        source("scripts/server_insert_update_variables_observation.R")
        quoi<<- "cap_poux_pres"
        valeur<<-input$cap_poux_pres
        source("scripts/server_insert_update_variables_observation.R")
        quoi<<- "cap_hypobosq_pres"
        valeur<<-input$cap_hypobosq_pres
        source("scripts/server_insert_update_variables_observation.R")
        quoi<<- "cap_diarrhee"
        valeur<<-input$cap_diarrhee
        source("scripts/server_insert_update_variables_observation.R")
        quoi<<- "cap_allaitante"
        valeur<<-input$cap_allaitante
        source("scripts/server_insert_update_variables_observation.R")
        quoi<<- "cap_bois_scies"
        valeur<<-input$cap_bois_scies 
        source("scripts/server_insert_update_variables_observation.R")
        quoi<<- "cap_bois_tombe"
        valeur<<-input$cap_bois_tombe
        source("scripts/server_insert_update_variables_observation.R")
        quoi<<- "cap_bois_dur"
        valeur<<-input$cap_bois_dur
        source("scripts/server_insert_update_variables_observation.R")
        quoi<<- "cap_bois_velour"
        valeur<<-input$cap_bois_velour
        source("scripts/server_insert_update_variables_observation.R")
        }
        
        
##########################################################################################   
############################## fonction de réinitialisation des widgets ##################
##########################################################################################   

       reset <- function() {
       show_modal_spinner(spin = sample(c("flower", "pixel", "hollow-dots", "intersecting-circles", "orbit", "radar",
                                          "scaling-squares", "half-circle", "trinity-rings", "fulfilling-square",
                                          "circles-to-rhombuses", "semipolar", "self-building-square", "swapping-squares",
                                          "fulfilling-bouncing-circle", "fingerprint", "spring", "atom", "looping-rhombuses",
                                          "breeding-rhombus"),1),
                          color = "firebrick",text = "Veuillez patientier, je réinitialise les outils de saisie")


       updateNumericInput(session,inputId = "ani_n_inra", value = 0);
       updateSelectInput(session,inputId = "variable_5", selected = "");###########mensurations
       updateNumericInput(session,inputId = "variable_5_valeur", value = NA);
       updateTimeInput(session,inputId = "variable_5_heure", value = NULL);
       updateTextInput(session,inputId = "variable_5_rq", value = "");
       updateSelectInput(session,inputId = "variable_6", selected = "");############mesures ponctuelles
       updateNumericInput(session,inputId = "variable_6_valeur", value =  NA);
       updateTimeInput(session,inputId = "variable_6_heure", value = NULL);
       updateTextInput(session,inputId = "variable_6_rq", value = "");
       updateSelectInput(session,inputId = "variable_7", selected = ""); ######variables répétées
       updateNumericInput(session,inputId = "variable_7_valeur", value =  NA);
       updateTimeInput(session,inputId = "variable_7_heure", value = NULL);
       updateTextInput(session,inputId = "variable_7_rq", value = "");
       updateSelectInput(session,inputId = "variable_8", selected = "");
       updateNumericInput(session,inputId = "variable_8_valeur", value =  NA);
       updateTimeInput(session,inputId = "variable_8_heure", value = NULL);
       updateTextInput(session,inputId = "variable_8_rq", value = "");
       updateSelectInput(session,inputId = "variable_1", label = "Peau/poils/feces", selected = "");
       updateNumericInput(session,inputId = "variable_1_valeur", value =  NA);
       updateTimeInput(session,inputId = "variable_1_heure", value = NULL);
       updateTextInput(session,inputId = "variable_1_rq", value = "");
       updateSelectInput(session,inputId = "variable_2", label = "Sang", selected = "");
       updateNumericInput(session,inputId = "variable_2_valeur", value =  NA);
       updateTimeInput(session,inputId = "variable_2_heure", value = NULL);
       updateTextInput(session,inputId = "variable_2_rq", value = "");
       updateSelectInput(session,inputId = "variable_3", label = "Parasites", selected = "");#####prélèvements
       updateNumericInput(session,inputId = "variable_3_valeur", value =  NA);
       updateTimeInput(session,inputId = "variable_3_heure", value = NULL);
       updateTextInput(session,inputId = "variable_3_rq", value = "");
       updateSelectInput(session,inputId = "variable_4", label = "Sécressions", selected = "");
       updateNumericInput(session,inputId = "variable_4_valeur", value =  NA);
       updateTimeInput(session,inputId = "variable_4_heure", value = NULL);
       updateTextInput(session,inputId = "variable_4_rq", value = "");
       updateTextInput(session,inputId = "cap_collier", value = "");
       updateTextInput(session,inputId = "cap_anesthesie", value = "");
       updateTextInput(session,inputId = "cap_blessure", value = "");
       updateTextInput(session,inputId = "cap_tranquilisant", value = "");
       updateTextInput(session,inputId = "cap_traitement", value = "");
       updateNumericInput(session,inputId = "cap_dose_acepromazine", value =  NA);
       updateTimeInput(session,inputId = "cap_anesthesie_heure", value = NULL);
       updateTimeInput(session,inputId = "cap_heure_reveil", value = NULL);
       updateSelectInput(session,inputId = "variable_10", selected = "");
       updateNumericInput(session,inputId = "variable_10_int", value =  NA);
       updateTimeInput(session,inputId = "variable_10_heure", value = NULL);
       updateTextInput(session,inputId = "variable_10_rq", value = "");
       updateSelectInput(session,inputId = "variable_11", selected = "");
       updateNumericInput(session,inputId = "variable_11_int", value =  NA);
       updateTimeInput(session,inputId = "variable_11_heure", value = NULL);
       updateTextInput(session,inputId = "variable_11_rq", value = "");
       updateSelectInput(session,inputId = "variable_12", selected = "");
       updateNumericInput(session,inputId = "variable_12_int", value =  NA);
       updateTimeInput(session,inputId = "variable_12_heure", value = NULL);
       updateTextInput(session,inputId = "variable_12_rq", value = "");
       updateSelectInput(session,inputId = "variable_13", selected = "");
       updateNumericInput(session,inputId = "variable_13_int", value =  NA);
       updateSelectInput(session,inputId = "variable_9", label = "Parasites", selected = ""); #####comptages
       updateNumericInput(session,inputId = "variable_9_valeur", value =  NA);
       updateTimeInput(session,inputId = "variable_9_heure", value = NULL);
       updateTextInput(session,inputId = "variable_9_rq", value = "");
       updateCheckboxInput(session,inputId ="cap_puces_pres",  label ="Présence de puces", value = FALSE);
       updateCheckboxInput(session,inputId ="cap_poux_pres",  label ="Présence de poux", value =FALSE);
       updateCheckboxInput(session,inputId ="cap_hypobosq_pres",  label ="Présence d'hippobosques", value =FALSE);
       updateCheckboxInput(session,inputId ="cap_bois_velour",  label ="Bois en velour", value =FALSE);
       updateCheckboxInput(session,inputId ="cap_bois_dur",  label ="Bois durs", value =FALSE);
       updateCheckboxInput(session,inputId ="cap_bois_tombe",  label ="Bois tombés", value =FALSE);
       updateCheckboxInput(session,inputId ="cap_bois_scies",  label ="Bois sciés", value =FALSE);
       updateCheckboxInput(session,inputId ="cap_allaitante",  label ="Allaitante", value =FALSE);
       updateCheckboxInput(session,inputId ="cap_diarrhee",  label ="Diarrhée", value =FALSE);
       updateTextInput(session,inputId = "cap_anesthesie_heure_remarque", value = "");
       updateTextInput(session,inputId = "cap_reveil_heure_remarque", value = "");
       updateTextInput(session,inputId = "cap_dose_acepro_remarque", value = "");
       updateTextInput(session,inputId = "cap_lache_visibilite", value = "");
       updateTextInput(session,inputId = "cap_lache_public", value = "");
       updateNumericInput(session,inputId = "cap_lache_nbre_stop", value =  NA);
       updateSelectInput(session,inputId = "cap_num_sabot", selected = "");
       updateTimeInput(session,inputId = "cap_anesthesie_heure", value = NA);
       updateTimeInput(session,inputId = "cap_heure_reveil", value = NA);
      
       # updateNumericInput(session,inputId = "ani_n_inra", value = dbGetQuery(con,"select max(ani_n_inra) from registre_gardouch")[,1]+1);
       # updateTextInput(session,inputId = "ani_nom_registre", value = "");
       # updateTextInput(session,inputId = "ani_transpondeur_id", value = "");
       loadData()
       remove_modal_spinner()
       }

       reset_old_val <- function() { ########permet, lors du rappel d'une capture déjà existante, de remettre les champs de saisie texte et booléen avec les valeurs de la capture (les champs select se remettront à jour dès qu'une variable sera sélectionnée)
           show_modal_spinner(spin = sample(c("flower", "pixel", "hollow-dots", "intersecting-circles", "orbit", "radar",
                                     "scaling-squares", "half-circle", "trinity-rings", "fulfilling-square",
                                     "circles-to-rhombuses", "semipolar", "self-building-square", "swapping-squares",
                                     "fulfilling-bouncing-circle", "fingerprint", "spring", "atom", "looping-rhombuses",
                                     "breeding-rhombus"),1),
                            color = "firebrick",text = "Veuillez patientier, je charge les données de la capture correspondante")
         if (input$tabs == "A"){
         # updateSelectInput(session,inputId = "variable_5", selected = "");###########mensurations
         # updateNumericInput(session,inputId = "variable_5_valeur", value = former_val("variable_5"));
         # updateTimeInput(session,inputId = "variable_5_heure", value = paste(date(Sys.time()),substr(former_val("variable_5"),1,8)," CET"));
         # updateTextInput(session,inputId = "variable_5_rq", value = former_val("variable_5"));
         # updateSelectInput(session,inputId = "variable_6", selected = "");############mesures ponctuelles
         # updateNumericInput(session,inputId = "variable_6_valeur", value =  NA);
         # updateTimeInput(session,inputId = "variable_6_heure", value = NULL);
         # updateTextInput(session,inputId = "variable_6_rq", value = "");
         # updateSelectInput(session,inputId = "variable_7", selected = ""); ######variables répétées
         # updateNumericInput(session,inputId = "variable_7_valeur", value =  NA);
         # updateTimeInput(session,inputId = "variable_7_heure", value = NULL);
         # updateTextInput(session,inputId = "variable_7_rq", value = "");
         # updateSelectInput(session,inputId = "variable_8", selected = "");
         # updateNumericInput(session,inputId = "variable_8_valeur", value =  NA);
         # updateTimeInput(session,inputId = "variable_8_heure", value = NULL);
         # updateTextInput(session,inputId = "variable_8_rq", value = "");
         # updateSelectInput(session,inputId = "variable_1", label = "Peau/poils/feces", selected = "");
         # updateNumericInput(session,inputId = "variable_1_valeur", value =  NA);
         # updateTimeInput(session,inputId = "variable_1_heure", value = NULL);
         # updateTextInput(session,inputId = "variable_1_rq", value = "");
         # updateSelectInput(session,inputId = "variable_2", label = "Sang", selected = "");
         # updateNumericInput(session,inputId = "variable_2_valeur", value =  NA);
         # updateTimeInput(session,inputId = "variable_2_heure", value = NULL);
         # updateTextInput(session,inputId = "variable_2_rq", value = "");
         # updateSelectInput(session,inputId = "variable_3", label = "Parasites", selected = "");#####prélèvements
         # updateNumericInput(session,inputId = "variable_3_valeur", value =  NA);
         # updateTimeInput(session,inputId = "variable_3_heure", value = NULL);
         # updateTextInput(session,inputId = "variable_3_rq", value = "");
         # updateSelectInput(session,inputId = "variable_4", label = "Sécressions", selected = "");
         # updateNumericInput(session,inputId = "variable_4_valeur", value =  NA);
         # updateTimeInput(session,inputId = "variable_4_heure", value = NULL);
         # updateTextInput(session,inputId = "variable_4_rq", value = "");
         updateTextInput(session,inputId = "cap_collier", value = former_val("cap_collier"));
         updateTextInput(session,inputId = "cap_tranquilisant", value = former_val("cap_tranquilisant"));
         updateTextInput(session,inputId = "cap_blessure", value =  former_val("cap_blessure"));
         updateTextInput(session,inputId = "cap_traitement", value = former_val("cap_traitement"));
         updateTextInput(session,inputId = "cap_anesthesie", value = former_val("cap_anesthesie"));
         updateNumericInput(session,inputId = "cap_dose_acepromazine", value =  former_val("cap_dose_acepromazine"));
         updateTimeInput(session,inputId = "cap_anesthesie_heure", value = paste(date(Sys.time()),substr(former_val("cap_anesthesie_heure"),1,8)," CET"));
         updateTimeInput(session,inputId = "cap_heure_reveil", value = paste(date(Sys.time()),substr(former_val("cap_heure_reveil"),1,8)," CET"));
         updateCheckboxInput(session,inputId ="cap_puces_pres",  label ="Présence de puces", value = fifelse(former_val("cap_puces_pres") == "false", FALSE, TRUE));
         updateCheckboxInput(session,inputId ="cap_poux_pres",  label ="Présence de poux", value =fifelse(former_val("cap_poux_pres") == "false", FALSE, TRUE));
         updateCheckboxInput(session,inputId ="cap_hypobosq_pres",  label ="Présence d'hippobosques", value =fifelse(former_val("cap_hypobosq_pres") == "false", FALSE, TRUE));
         updateCheckboxInput(session,inputId ="cap_bois_velour",  label ="Bois en velour", value =fifelse(former_val("cap_bois_velour") == "false", FALSE, TRUE));
         updateCheckboxInput(session,inputId ="cap_bois_dur",  label ="Bois durs", value =fifelse(former_val("cap_bois_dur") == "false", FALSE, TRUE));
         updateCheckboxInput(session,inputId ="cap_bois_tombe",  label ="Bois tombés", value =fifelse(former_val("cap_bois_tombe") == "false", FALSE, TRUE));
         #updateCheckboxInput(session,inputId ="cap_bois_scies",  label ="Bois sciés", value =former_val("cap_bois_scies"));
         updateCheckboxInput(session,inputId ="cap_allaitante",  label ="Allaitante", value =fifelse(former_val("cap_allaitante") == "false", FALSE, TRUE));
         updateCheckboxInput(session,inputId ="cap_diarrhee",  label ="Diarrhée", value =fifelse(former_val("cap_diarrhee") == "false", FALSE, TRUE));
         updateTextInput(session,inputId = "cap_anesthesie_heure_remarque", value = former_val("cap_anesthesie_heure_remarque"));
         updateTextInput(session,inputId = "cap_heure_reveil_remarque", value = former_val("cap_heure_reveil_remarque"));
         updateTextInput(session,inputId = "cap_dose_acepromazine_remarque", value = former_val("cap_dose_acepromazine_remarque")); ####c'est cette dernière varaible qui permute compteur à "insert" à la fin de cette section
         }
         if (input$tabs == "B"){
           
         }
         if (input$tabs == "C"){
         updateNumericInput(session,inputId = "cap_lache_nbre_stop", value =  former_val("cap_lache_nbre_stop"));
         updateSelectInput(session,inputId = "cap_lache_visibilite", choices = list(votre_choix = "","0"="0","0-10"="0-10","10-50"="10-50","50-100"="50-100",">100"=">100"), selected = trimws(former_val("cap_lache_visibilite")));
         updateSelectInput(session,inputId = "cap_lache_public", selected = former_val("cap_lache_public"));
         updateTextInput(session,inputId = "cap_dose_acepromazine_remarque", value = former_val("cap_dose_acepromazine_remarque")); ####c'est cette dernière varaible qui permute compteur à "insert" à la fin de cette section
         updateTextInput(session,inputId = "cap_dose_acepromazine_remarque", value = former_val("cap_dose_acepromazine_remarque")); ####c'est cette dernière varaible qui permute compteur à "insert" à la fin de cette section
         updateTextInput(session,inputId = "variable_12", value = former_val("cap_sabot_observateur"));
         }
         # updateSelectInput(session,inputId = "variable_10", selected = "");
         # updateNumericInput(session,inputId = "variable_10_int", value =  NA);
         # updateTimeInput(session,inputId = "variable_10_heure", value = NULL);
         # updateTextInput(session,inputId = "variable_10_rq", value = "");
         # updateSelectInput(session,inputId = "variable_11", selected = "");
         # updateNumericInput(session,inputId = "variable_11_int", value =  NA);
         # updateTimeInput(session,inputId = "variable_11_heure", value = NULL);
         # updateTextInput(session,inputId = "variable_11_rq", value = "");
         # updateSelectInput(session,inputId = "variable_12", selected = "");
         # updateNumericInput(session,inputId = "variable_12_int", value =  NA);
         # updateTimeInput(session,inputId = "variable_12_heure", value = NULL);
         # updateTextInput(session,inputId = "variable_12_rq", value = "");
         # updateSelectInput(session,inputId = "variable_13", selected = "");
         # updateNumericInput(session,inputId = "variable_13_int", value =  NA);
         # updateSelectInput(session,inputId = "variable_9", label = "Parasites", selected = ""); #####comptages
         # updateSelectInput(session,inputId = "variable_9_valeur", selected = "")
         # updateNumericInput(session,inputId = "variable_9_valeur", value =  NA);
         # updateTimeInput(session,inputId = "variable_9_heure", value = NULL);
         # updateTextInput(session,inputId = "variable_9_rq", value = "");
         #compteur<<- action #####initialise un compteur pour éviter que lors de cette mis à jour l'app considère que les champs ont été maj (car sinon elle les réécrit), le compteur sera incrémenté de 1 à chaque fois que l'utilisateur utilise un widget
          remove_modal_spinner()
       }
  
       
       former_val <- function(varia) {#####fonction demandant le nom de la variable et renvoyant sa valeur pour l'observation considérée
         v<<-utf8(dbGetQuery(con,paste0("SELECT ",varia," FROM public.capture_gardouch where ind_id = '",obs_ind_id,"' and obs_date = '",paste0(responses["obs_date"]," 00:00:00+00"),"' ")))[,1]
         v
       }        
       
       kill <- function() {
       updateDateInput(session,inputId = "obs_date", value = NA);
       updateTextInput(session,inputId = "ani_nom_registre", value ="");
       updateTextInput(session,inputId = "ani_transpondeur_id", value = NA);
       rm(obs_id, envir =.GlobalEnv);
       rm(obs_ind_id, envir =.GlobalEnv);
       rm(registre, envir =.GlobalEnv);
       rm(dat, envir =.GlobalEnv);
       rm(var_id, envir =.GlobalEnv);
       }
       
       
##########################################################################################       
############################### fonction de controle #####################################
##########################################################################################   
#######fonction qui controle les champs et renvoie TRUE si pas d'alerte détectées et FALSE sinon (permet de gérer l'activation ou non de la sauvegarde lors du submit)  
  
      control <- function(nouvelleentree) {
      responses <<- sapply(nouvelleentree,"[",1)
      if (length(ymd(responses["obs_date"])) != 1)
      {shinyalert("Format de l'entrée date de capture erroné", "la date de capture doit être du type yyyy-mm-dd", type = "error");ok <- FALSE} else {ok <- TRUE}
      if (responses["ani_transpondeur_id"] != "" & nchar(responses["ani_transpondeur_id"]) != 10)
      {shinyalert("Format de l'entrée tag RFID (traspondeur) erroné", "le code RFID doit comporté 10 chiffres", type = "error");ok <- append(ok, FALSE)} else {ok <- append(ok, TRUE)}
      ok<-all(ok)
      return(ok)
      }

#######################################  
#########export des données############      
######################################   
       
       export <- function() {#####fonction demandant le nom de la variable et renvoyant sa valeur pour l'observation considérée
         individus_total<<- registre#utf8(as.data.frame(dbGetQuery(con,paste0("SELECT * from individus_total"))))
         individus_total
       }
       

       output$downloadcsv2 <-  downloadHandler(
         filename = function() {
           paste0("Observations_", gsub("-","_",Sys.Date()),".csv")
         },
         content = function(file) {
           write.csv2(export(), file, row.names = FALSE)
         }
       )
       
       output$downloadhtml <-  downloadHandler(
         filename = function() {
           paste0("Observations_", gsub("-","_",Sys.Date()),".html")
         },
         content = function(file) {
          export() %>% 
             kbl() %>%
             kable_styling(bootstrap_options = c("striped", "hover"))  %>%
             save_kable(file = file, self_contained = T)
         }
       )
       output$downloadxlsx <-  downloadHandler(
         filename = function() {
           paste0("Observations_", gsub("-","_",Sys.Date()),".xlsx")
         },
         content = function(file) {
           write.xlsx2(export(), file, sheetName = "Observations", row.names = FALSE)
         }
       )
########################       
       
       
})

                                                                                                                                                    
