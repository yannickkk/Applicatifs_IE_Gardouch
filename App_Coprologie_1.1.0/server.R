
# Define server
shinyServer(function(input, output, session) {

  # close_session <- function() {
  #   #mortauxcons()
  #   stopApp()
  # }
  # session$onSessionEnded(close_session)

  #####on récupère le nom de l'utilisateur
  observeEvent(input$login, {
    observateur_copro<<- input$login})
  
  
  ###########################################################################
  #########observe if mandatory fields are filled or not#####################
  ###########################################################################
  
  observe({
    # check if all mandatory fields have a value
    #####problème avec la date d'entrée qui doit être mandataire mais il ne reconnait pas le format nulle date print(input$ani_date_arrivee)
    mandatoryFilled <-
      vapply(fieldsMandatory,
             function(x) { 
               !is.null(as.character(input[[x]])) && as.character(input[[x]]) != "" && isTruthy(as.character(input[[x]]))
             },
             logical(1))
    
    # enable/disable the submit button
    shinyjs::toggleState(id = "save", condition = all(mandatoryFilled)) ###if ref and frequence of a collar are integrated then allow submission of a new collar
  })
  
  #########################################
  #############Loading function############
  #########################################
  
  loadData <- function() {
    coprologie<<-utf8(as.data.frame(dbGetQuery(con,paste0("SELECT numero_inrae, nom_registre, obs_date as date_observation, observateur_copro experimentateur, 
    strongles_gastro_intestinaux,strongles_gastro_intestinaux_remarque,nematodirus, nematodirus_remarque,strongyloidess_papillosus, strongyloidess_papillosus_remarque,
    trichuris_ovis, trichuris_ovis_remarque,capillaria, capillaria_remarque,coccidies, coccidies_remarque,echinostomida, echinostomida_remarque, 
    dictyocaules, dictyocaules_remarque,  oxyures, oxyures_remarque,
    haemonchus_contortus, haemonchus_contortus_remarque, moniezia, moniezia_remarque
    FROM public.coprologie order by obs_date desc;"))))
    coprologie
  }
  
  #####################################################
  ############Affichage des données dans l'ui #########
  #####################################################

  output$coprologie <- DT::renderDataTable({
    loadData()
    DT::datatable(coprologie, filter = "top",rownames = F,options = list(lengthMenu = c(10, 50, 100, 200, 300), pageLength = 250))
 })
  #######################################  
  #########action des boutons############      
  #######################################
  
  observeEvent(input$save, {
    saveData()
  })
  observeEvent(input$clean, {
    reset()
  })
#######################################  
#########export des données############      
######################################   

export <- function() {
  coprologie
}

output$downloadcsv2 <-  downloadHandler(
  filename = function() {
    paste0("coprologie_", gsub("-","_",Sys.Date()),".csv")
  },
  content = function(file) {
    write.csv2(export(), file, row.names = FALSE, na ="")
  }
)

reset <- function() {
  show_modal_spinner(spin = sample(c("flower", "pixel", "hollow-dots", "intersecting-circles", "orbit", "radar",
                                     "scaling-squares", "half-circle", "trinity-rings", "fulfilling-square",
                                     "circles-to-rhombuses", "semipolar", "self-building-square", "swapping-squares",
                                     "fulfilling-bouncing-circle", "fingerprint", "spring", "atom", "looping-rhombuses",
                                     "breeding-rhombus"),1),
                     color = "firebrick",text = "Veuillez patientier, je réinitialise les outils de saisie")
  updateSelectInput(session,inputId ="nom_registre",selected ="")
  #updateDateInput(session,inputId ="obs_date", value = NA)
  updateNumericInput(session,inputId = "strongles_gastro_intestinaux", value = 0);
  updateNumericInput(session,inputId = "coccidies", value = 0);
  updateNumericInput(session,inputId = "nematodirus", value = 0);
  updateNumericInput(session,inputId = "capillaria", value = 0);
  updateNumericInput(session,inputId = "trichuris_ovis", value = 0);
  updateNumericInput(session,inputId = "echinostomida", value = 0);
  updateNumericInput(session,inputId = "dictyocaules", value = 0);
  updateNumericInput(session,inputId = "oxyures", value = 0);
  updateNumericInput(session,inputId = "haemonchus_contortus", value = 0);
  updateNumericInput(session,inputId = "strongyloidess_papillosus", value = 0);
  updateNumericInput(session,inputId = "moniezia", value = 0);
  updateNumericInput(session,inputId = "Paramphistomum", value = 0);
  updateTextInput(session,inputId = "strongles_gastro_intestinaux_remarque", value = "");
  updateTextInput(session,inputId = "coccidies_remarque", value = "");
  updateTextInput(session,inputId = "nematodirus_remarque", value = "");
  updateTextInput(session,inputId = "capillaria_remarque", value = "");
  updateTextInput(session,inputId = "trichuris_ovis_remarque_remarque", value = "");
  updateTextInput(session,inputId = "echinostomida_remarque", value = "");
  updateTextInput(session,inputId = "dictyocaules_remarque_remarque", value = "");
  updateTextInput(session,inputId = "oxyures_remarque", value = "");
  updateTextInput(session,inputId = "haemonchus_contortus_remarque_remarque", value = "");
  updateTextInput(session,inputId = "strongyloidess_papillosus_remarque", value = "");
  updateTextInput(session,inputId = "moniezia_remarque", value = "");
  updateTextInput(session,inputId = "Paramphistomum_remarque", value = "");
  updateTextInput(inputId = "obs_remarque", value = "");
  loadData()
  output$coprologie <- DT::renderDataTable({
    DT::datatable(coprologie, filter = "top",rownames = F, options = list(lengthMenu = c(10, 50, 100, 200, 300), pageLength = 250))
  })
  remove_modal_spinner()
}

saveData <- function() {
  dat<<-c(nom_registre=input$nom_registre, obs_date = as.character(input$obs_date), observateur_copro = input$login,
          obs_remarque=input$obs_remarque,
          capillaria=input$capillaria,
          capillaria_remarque=input$capillaria_remarque,
          coccidies=input$coccidies, 
          coccidies_remarque=input$coccidies_remarque,
          dictyocaules=input$dictyocaules, 
          dictyocaules_remarque=input$dictyocaules_remarque,
          echinostomida=input$echinostomida, 
          echinostomida_remarque=input$echinostomida_remarque,
          haemonchus_contortus=input$haemonchus_contortus,
          haemonchus_contortus_remarque=input$haemonchus_contortus_remarque,
          moniezia=input$moniezia, 
          moniezia_remarque=input$moniezia_remarque,
          nematodirus=input$nematodirus, 
          nematodirus_remarque=input$nematodirus_remarque,
          oxyures=input$oxyures, 
          oxyures_remarque=input$oxyures_remarque,
          strongles_gastro_intestinaux=input$strongles_gastro_intestinaux, 
          strongles_gastro_intestinaux_remarque=input$strongles_gastro_intestinaux_remarque,
          strongyloidess_papillosus=input$strongyloidess_papillosus, 
          strongyloidess_papillosus_remarque=input$strongyloidess_papillosus_remarque,
          trichuris_ovis=input$trichuris_ovis,
          trichuris_ovis_remarque=input$trichuris_ovis_remarque,
          paramphistomum=input$paramphistomum,
          paramphistomum_remarque=input$paramphistomum_remarque
          )
  #source("scripts/server_insert_update_observation.R")
  show_modal_spinner(spin = sample(c("flower", "pixel", "hollow-dots", "intersecting-circles", "orbit", "radar",
                                     "scaling-squares", "half-circle", "trinity-rings", "fulfilling-square",
                                     "circles-to-rhombuses", "semipolar", "self-building-square", "swapping-squares",
                                     "fulfilling-bouncing-circle", "fingerprint", "spring", "atom", "looping-rhombuses",
                                     "breeding-rhombus"),1),
                     color = "firebrick",text = "Veuillez patientier, je réinitialise les outils de saisie")
  #source("scripts/server_insert_update_variables_observation.R")
  remove_modal_spinner()
  reset()
}


########################       
})