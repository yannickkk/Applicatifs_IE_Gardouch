############################Intersect home range and landscape###########################################
#### author: Yannick Chaval, INRAE (French National Institute for Agricultural Research), CEFS (Wildlife, Behaviour and Ecology Research Unit)
#### date: 22-10-2020
#### target db: db_individu
#### objet: permet de visualiser le registre de l'installation expérimentale de Gardouch
#### source file: la vue registre_gardouch permet la visualisation des données existantes
#### output tables: toutes les tables contenant les valeurs des variables individu
#### delete tables: aucune
#### 
#### repository source: C:\Users\ychaval\Documents\BD_tools\Shinyforms\Programmes\Gardouch
#########################################################################################################
source("C:/Users/ychaval/Documents/BD_Gardouch/Programmes/R/structure_actuelle/con_server_db_gardouch.R")
con<-serveur_gardouch

# Define server
shinyServer(function(input, output, session) {
  
  
  session$onSessionEnded(stopApp)
  
  
#####on récupère le nom de l'utilisateur
  observeEvent(input$login, {
    user<<- input$login})
  
###########################################################################
#########observe if mandatory fields are filled or not#####################
###########################################################################
  
  observe({
    # check if all mandatory fields have a value
    #####problème avec la date d'entrée qui doit être mandataire mais il ne reconnait pas le format nulle date print(input$ani_date_arrivee)
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

  

#########################################  
#############Saving function#############
#########################################

#############Saving new individual or update an existing individual ######### 
   
  saveData <- function(nouvelleentree) {
    responses <<- sapply(nouvelleentree,"[",1)

    ########check if eqt_id_usuel already exist inside the db and then give the choice to update existing data or delete entering data 
    obj <<- as.numeric(dbGetQuery(con,paste0("SELECT obj_id FROM list.tr_object_obj WHERE obj_name = '",responses["ani_espece_id"],"'"))[,1])
    verif<<- dbGetQuery(con,paste0("Select distinct(ind_name) from main.t_individu_ind where ind_obj_id = ",obj,""))
    if (length(grep(responses["ani_n_inra"],as.character(verif[,1])))!= 0) {shinyalert("Attention !!!", "Cet animal existe déjà dans le registre de l'installation",showCancelButton = TRUE, confirmButtonText = "Mettre à jour les données de l'animal à partir de la nouvelle entrée",cancelButtonText = "Ne pas tenir compte de la nouvelle entrée", type = "error", callbackR = function (va) {


#shinyalert choice I: update (confirm) or no duplicated entry#
##############################################################
      
        if (va == TRUE) {
          action <<-"update"

        responses <<- sapply(nouvelleentree,"[",1)
        responses["ani_sexe"]<-toupper(responses["ani_sexe"])

        show_modal_progress_line()
        
        source("scripts/server_insert_update_individu.R")
        update_modal_progress(0.1)
        source("scripts/server_insert_update_variables_individu.R")
        update_modal_progress(0.2)
        update_modal_progress(0.4)
        #reloadData()
        # output$registre <- DT::renderDataTable({
        # DT::datatable(, options = list(lengthMenu = c(10, 50, 100, 200, 300), pageLength = 250))
        # update_modal_progress(0.7)
        # })
        reset()
        update_modal_progress(1)
        remove_modal_progress()      
        
        
        } else {reset()}####remise à zero des widjets
    }
    )} else { 
        
########no entry duplicated
###########################
        action <<-"insert"
        
        responses <<- sapply(nouvelleentree,"[",1)
        responses["ani_sexe"]<-toupper(responses["ani_sexe"])
        
        test<<-utf8(as.data.frame(dbGetQuery(con,paste0("SELECT * from registre_gardouch"))))[,"ani_nom_registre"]
        
        if (length(grep(paste0("^",toupper(responses["ani_nom_registre"]),"$"),toupper(as.character(test))))!= 0)
        {shinyalert("Nom déjà utilisé", "En manque d'inspiration ?", type = "error"); ok <- FALSE} else {ok<-TRUE}
        
        if (ok == TRUE){
          show_modal_progress_line()
         source("scripts/server_insert_update_individu.R")
          update_modal_progress(0.5)
         source("scripts/server_insert_update_variables_individu.R")
          update_modal_progress(0.7)
          reset()
          update_modal_progress(0.9)
          remove_modal_progress() 
              ok<-FALSE}

           }

        }

#########################################
#########END OF THE SAVING FUNCTION######
#########################################
  
#########################################
#############Loading function############
#########################################
  
    loadData <- function() {
      registre<<-utf8(as.data.frame(dbGetQuery(con,paste0("SELECT * from registre_gardouch"))))[,2:24]
      registre
    }
  
    reloadData <- function() {
      registre<<-utf8(as.data.frame(dbGetQuery(con,paste0("SELECT * from registre_gardouch where ani_n_inra =",input$ani_n_inra," "))))[,2:24]
      registre
    }
    
###############################################################################################
############Lance l'enregistrement des données qd submit est cliqué si le controle est ok #####
###############################################################################################

  # action to take when submit button is pressed
    observeEvent(input$subcol, {
     if (control(formData())){  #####si la fonction controle renvoie TRUE (ie pas d'alerte) alors forme des les données et les enregistre
     saveData(formData())};
    })

    observeEvent(input$new, {
    reset()
      })
  
#####################################################
############Affichage des données dans l'ui #########
#####################################################
  
  # Show the previous responses
  # (update with current response when Submit is clicked)
     output$registre <- DT::renderDataTable(
      #input$subcol#
       registre, filter = "top",rownames = F,options = list(lengthMenu = c(10, 50, 100, 200, 300), pageLength = 250))
    #DT::datatable()


###############Action du bouton de trie trie_ani_present#######

  
  observeEvent(input$trie_ani_present , {
    if (input$trie_ani_present == TRUE) {
      registre<- registre[is.na(registre$ani_date_depart),]
      output$registre <- DT::renderDataTable({
        DT::datatable(registre, filter = "top",rownames = F, options = list(lengthMenu = c(10, 50, 100, 200, 300), pageLength = 250))
      })
    }
    if (input$trie_ani_present == FALSE) {
      output$registre <- DT::renderDataTable({
        loadData()
        DT::datatable(registre, filter = "top",rownames = F, options = list(lengthMenu = c(10, 50, 100, 200, 300), pageLength = 250))
      })
    }
        })
  
#################################################################################################################
############ Met les valeurs par défaut des widjets à jour en fonction du n° inra sélectionné  ##################
#################################################################################################################    

        observeEvent(input$ani_n_inra, {
        if (input$ani_n_inra != "" & !is.na(input$ani_n_inra)){
        obj <- dbGetQuery(con,paste0("SELECT obj_id FROM list.tr_object_obj WHERE obj_name = '",input$ani_espece_id,"'"))
        verif<- dbGetQuery(con,paste0("Select distinct(ind_name) from main.t_individu_ind where ind_obj_id = ",obj," "))
        if (length(grep(input$ani_n_inra,as.character(verif[,1])))!= 0){
        show_modal_progress_line() # show the modal window
        updateTextInput(session,inputId = "ani_nom_registre", value = utf8(dbGetQuery(con,paste0("SELECT ani_nom_registre from registre_gardouch where ani_n_inra = '",input$ani_n_inra,"' ")))[,1]);
        updateTextInput(session,inputId = "ani_sexe", value = utf8(dbGetQuery(con,paste0("SELECT ani_sexe from registre_gardouch where ani_n_inra = '",input$ani_n_inra,"' ")))[,1]);
        updateTextInput(session,inputId = "ani_naissance_txt", value = utf8(dbGetQuery(con,paste0("SELECT ani_naissance_txt from registre_gardouch where ani_n_inra = '",input$ani_n_inra,"' ")))[,1]);
        updateNumericInput(session,inputId = "ani_naissance_entier", value = dbGetQuery(con,paste0("SELECT ani_naissance_entier from registre_gardouch where ani_n_inra = '",input$ani_n_inra,"' "))[,1]);
        update_modal_progress(0.2) # update progress bar value
        updateDateInput(session,inputId = "ani_naissance_date", value = as.Date(dbGetQuery(con,paste0("SELECT ani_naissance_date from registre_gardouch where ani_n_inra = '",input$ani_n_inra,"' "))[,1]));
        updateTextInput(session,inputId = "ani_vient_de", value = utf8(dbGetQuery(con,paste0("SELECT ani_vient_de from registre_gardouch where ani_n_inra = '",input$ani_n_inra,"' ")))[,1]);
        updateCheckboxInput(session,inputId = "ani_local", value = dbGetQuery(con,paste0("SELECT ani_local from registre_gardouch where ani_n_inra = '",input$ani_n_inra,"' "))[,1]);
        update_modal_progress(0.4) # update progress bar value
        updateSelectInput(session,inputId = "ani_pere", selected = dbGetQuery(con,paste0("SELECT ani_pere from registre_gardouch where ani_n_inra = '",input$ani_n_inra,"' "))[,1]);
        updateSelectInput(session,inputId = "ani_mere", selected = dbGetQuery(con,paste0("SELECT ani_mere from registre_gardouch where ani_n_inra = '",input$ani_n_inra,"' "))[,1]);
        updateNumericInput(session,inputId = "ani_taille_porte", value = dbGetQuery(con,paste0("SELECT ani_taille_porte from registre_gardouch where ani_n_inra = '",input$ani_n_inra,"' "))[,1]);
        updateSelectInput(session,inputId = "ani_espece_id", selected = dbGetQuery(con,paste0("SELECT ani_espece_id from registre_gardouch where ani_n_inra = '",input$ani_n_inra,"' "))[,1]);
        update_modal_progress(0.6) # update progress bar value
        updateDateInput(session,inputId = "ani_date_arrivee", value = as.Date(dbGetQuery(con,paste0("SELECT ani_date_arrivee from registre_gardouch where ani_n_inra = '",input$ani_n_inra,"' "))[,1]));
        updateDateInput(session,inputId = "ani_date_depart", value = as.Date(dbGetQuery(con,paste0("SELECT ani_date_depart from registre_gardouch where ani_n_inra = '",input$ani_n_inra,"' "))[,1]));
        updateTextInput(session,inputId = "ani_code_sortie", value = utf8(dbGetQuery(con,paste0("SELECT ani_code_sortie from registre_gardouch where ani_n_inra = '",input$ani_n_inra,"' ")))[,1]);
        updateTextInput(session,inputId = "ani_raison_sortie", value = utf8(dbGetQuery(con,paste0("SELECT ani_raison_sortie from registre_gardouch where ani_n_inra = '",input$ani_n_inra,"' ")))[,1]);
        update_modal_progress(0.8) # update progress bar value
        updateDateInput(session,inputId = "ani_date_mort", value = as.Date(dbGetQuery(con,paste0("SELECT ani_date_mort from registre_gardouch where ani_n_inra = '",input$ani_n_inra,"' "))[,1]));
        updateTextInput(session,inputId = "ani_echantillon_genet", value = utf8(dbGetQuery(con,paste0("SELECT ani_echantillon_genet from registre_gardouch where ani_n_inra = '",input$ani_n_inra,"' ")))[,1]);
        updateTextInput(session,inputId = "ani_id_genotype", value = utf8(dbGetQuery(con,paste0("SELECT ani_id_genotype from registre_gardouch where ani_n_inra = '",input$ani_n_inra,"' ")))[,1]);
        updateTextInput(session,inputId = "ani_remarque", value = utf8(dbGetQuery(con,paste0("SELECT ani_remarque from registre_gardouch where ani_n_inra = '",input$ani_n_inra,"' ")))[,1]);
        updateTextInput(session,inputId = "ani_transpondeur_id", value = utf8(dbGetQuery(con,paste0("SELECT ani_transpondeur_id from registre_gardouch where ani_n_inra = '",input$ani_n_inra,"' ")))[,1]);
        update_modal_progress(0.9)
        reloadData()
        output$registre <- DT::renderDataTable({
          DT::datatable(registre, filter = "top",rownames = F, options = list(lengthMenu = c(10, 50, 100, 200, 300), pageLength = 250))
        })
        update_modal_progress(1)
        remove_modal_progress()
                }}
                   })
    
        observeEvent(input$ani_nom_registre, {
         if (input$ani_nom_registre == "") {
           output$registre <- DT::renderDataTable({
            DT::datatable(registre, filter = "top",rownames = F, options = list(lengthMenu = c(10, 50, 100, 200, 300), pageLength = 250))})} else {
              if (input$ani_n_inra != as.numeric(dbGetQuery(con,"select max(ani_n_inra) from registre_gardouch")+1)){
              output$registre <- DT::renderDataTable({
              DT::datatable(registre, filter = "top",rownames = F, options = list(lengthMenu = c(10, 50, 100, 200, 300), pageLength = 250))})}}
          })
##########################################################################################   
############################## fonction de réinitialisation des widgets ##################
########################################################################################## 

       reset <- function() {
       show_modal_progress_line() # show the modal window
       update_modal_progress(0.1)
       updateNumericInput(session,inputId = "ani_n_inra", value = dbGetQuery(con,"select max(ani_n_inra) from registre_gardouch")[,1]+1);
       updateTextInput(session,inputId = "ani_nom_registre", value = "");
       updateTextInput(session,inputId = "ani_sexe", value = "");
       update_modal_progress(0.2)
       updateTextInput(session,inputId = "ani_naissance_txt", value = "");
       updateNumericInput(session,inputId = "ani_naissance_entier", value = "");
       updateDateInput(session,inputId = "ani_naissance_date", value = NA);
       update_modal_progress(0.3)
       updateTextInput(session,inputId = "ani_vient_de", value = "");
       updateCheckboxInput(session,inputId = "ani_local", value = "");
       updateSelectInput(session,inputId = "ani_pere", selected = "");
       update_modal_progress(0.4)
       updateSelectInput(session,inputId = "ani_mere", selected = "");
       updateNumericInput(session,inputId = "ani_taille_porte", value = "");
       updateSelectInput(session,inputId = "ani_espece_id", selected = "chevreuil");
       update_modal_progress(0.5)
       updateDateInput(session,inputId = "ani_date_arrivee", value = NA);
       updateDateInput(session,inputId = "ani_date_depart", value = NA);
       updateTextInput(session,inputId = "ani_code_sortie", value = "");
       updateTextInput(session,inputId = "ani_raison_sortie", value = "");
       update_modal_progress(0.6)
       updateDateInput(session,inputId = "ani_date_mort", value = NA);
       updateTextInput(session,inputId = "ani_echantillon_genet", value = "");
       update_modal_progress(0.7)
       updateTextInput(session,inputId = "ani_id_genotype", value = "");
       updateTextInput(session,inputId = "ani_remarque", value = "");
       update_modal_progress(0.8)
       updateTextInput(session,inputId = "ani_transpondeur_id", value = "");
       update_modal_progress(0.9)
       loadData()
       output$registre <- DT::renderDataTable({
         DT::datatable(registre, filter = "top",rownames = F, options = list(lengthMenu = c(10, 50, 100, 200, 300), pageLength = 250))
       })
       update_modal_progress(1)
       remove_modal_progress()
       }

##########################################################################################       
############################### fonction de controle #####################################
##########################################################################################   
#######fonction qui controle les champs et renvoie TRUE si pas d'alerte détectées et FALSE sinon (permet de gérer l'activation ou non de la sauvegarde lors du submit)  
  
      control <- function(nouvelleentree) {
      responses <<- sapply(nouvelleentree,"[",1)
      responses["ani_sexe"] <- toupper(responses["ani_sexe"])
      if (responses["ani_sexe"] != "M" & responses["ani_sexe"] != "F") 
      {shinyalert("Format de l'entrée Sexe erronée", "le sexe de l'animal doit être M ou F", type = "error");ok <- FALSE} else {ok <- TRUE}
      if (!is.na(responses["ani_date_arrivee"]) & !is.na(responses["ani_naissance_date"])){
      if (responses["ani_naissance_date"] >  responses["ani_date_arrivee"])
      {shinyalert("Incohérence de dates", "la date de naissance ne peux pas être postérieure à la date d'entrée", type = "error");ok <- append(ok, FALSE)} else {ok <- append(ok, TRUE)}}
      if (!is.na(responses["ani_naissance_date"]) & !is.na(responses["ani_date_depart"])){
      if (responses["ani_naissance_date"] >  responses["ani_date_depart"])
      {shinyalert("Incohérence de dates", "la date de naissance ne peux pas être postérieure à la date de départ", type = "error");ok <- append(ok, FALSE)} else {ok <- append(ok, TRUE)}}
      if (!is.na(responses["ani_date_arrivee"]) & !is.na(responses["ani_date_depart"])){
      if (responses["ani_date_arrivee"] >  responses["ani_date_depart"])
      {shinyalert("Incohérence de dates", "la date d'arrivée ne peux pas être postérieure à la date de sortie", type = "error");ok <- append(ok, FALSE)} else {ok <- append(ok, TRUE)}}
      if (!is.na(responses["ani_date_mort"]) & !is.na(responses["ani_naissance_date"])){
      if (responses["ani_date_mort"] <  responses["ani_naissance_date"])
      {shinyalert("Incohérence de dates", "la date de mort ne peux pas être antérieure à la date de naissance", type = "error");ok <- append(ok, FALSE)} else {ok <- append(ok, TRUE)}}
      if (!is.na(responses["ani_date_mort"]) & !is.na(responses["ani_date_depart"])){
      if (responses["ani_date_mort"]  <  responses["ani_date_depart"])
      {shinyalert("Incohérence de dates", "la date de mort ne peux pas être antérieure à la date de départ", type = "error");ok <- append(ok, FALSE)} else {ok <- append(ok, TRUE)}}
      if (!is.na(responses["ani_date_mort"]) & !is.na(responses["ani_date_arrivee"])){
      if (responses["ani_date_mort"]  <  responses["ani_date_arrivee"])
      {shinyalert("Incohérence de dates", "la date de mort ne peux pas être antérieure à la date d'arrivée", type = "error");ok <- append(ok, FALSE)} else {ok <- append(ok, TRUE)}}
      if (trimws(responses["ani_transpondeur_id"]) != "" & nchar(responses["ani_transpondeur_id"]) != 10)
      {shinyalert("Format de l'entrée tag RFID (traspondeur) erroné", "le code RFID doit comporté 10 chiffres", type = "error");ok <- append(ok, FALSE)} else {ok <- append(ok, TRUE)}
      ok<-all(ok)
      return(ok)
      }

  #################################################################################################################################################       
  ############################### on rempli automatiquement la provenance si la case né à Gardouch est cochée #####################################
  #################################################################################################################################################   
  
     observeEvent(input$ani_local, {
     if (input$ani_local == TRUE & input$ani_vient_de == "") {updateTextInput(session,inputId = "ani_vient_de", value = "Gardouch")}
     if (input$ani_local == FALSE) {updateTextInput(session,inputId = "ani_vient_de", value = "")}
       })
  
  #########export des données      
        
          output$downloadcsv2 <-  downloadHandler(
            filename = function() {
              paste0("registre_", gsub("-","_",Sys.Date()),".csv")
            },
            content = function(file) {
              write.csv2(registre, file, row.names = FALSE)
            }
          )

          output$downloadhtml <-  downloadHandler(
            filename = function() {
              paste0("registre_", gsub("-","_",Sys.Date()),".html")
            },
            content = function(file) {
              registre %>% 
                  kbl() %>%
                  kable_styling(bootstrap_options = c("striped", "hover"))  %>%
                  save_kable(file = file, self_contained = T)
            }
          )
          output$downloadxlsx <-  downloadHandler(
            filename = function() {
              paste0("registre_", gsub("-","_",Sys.Date()),".xlsx")
            },
            content = function(file) {
              write.xlsx2(registre, file, sheetName = "Registre", row.names = FALSE)
            }
          )
          
})

                                                                                                                                                   