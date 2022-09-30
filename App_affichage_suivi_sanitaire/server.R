
# Define server
shinyServer(function(input, output, session) {

  close_session <- function() {
    mortauxcons()
    stopApp()
  }
  session$onSessionEnded(close_session)

  #########################################
  #############Loading function############
  #########################################
  
  loadData <- function() {
    sanitaire<<-utf8(as.data.frame(dbGetQuery(con,paste0("SELECT numero_inrae, nom_registre, obs_date as date_observation, nom_experimentateur, sui_blessure as blessure, sui_comportement as comportement ,sui_condition_physique as condition_physique, sui_localisation_blessure as localisation_blessure, sui_mouche_eternue mouche_eternue, sui_observations_complementaires observations_complementaires, sui_photos photos, sui_posture posture, sui_remarque_generale remarque_generale, sui_salissure_arriere_train salissure_arriere_train, sui_secoue_oreillle secoue_oreillle, sui_secoue_oreillle_droite secoue_oreillle_droite, sui_secoue_oreillle_gauche secoue_oreillle_gauche, sui_texture_feces texture_feces, sui_videos videos
    FROM public.suivi_sanitaire order by obs_date desc;"))))
    sanitaire
  }
  
  selData <- function() {
    # n<<-input$numero_inrae
    # no<<-input$nom_registre
    # da<<-input$dates
    
    if (is.null(input$numero_inrae) & is.null(input$nom_registre)){print("rien")
      loadData()
    } else  if (is.null(input$numero_inrae) & (!is.null(input$dates [1])&!is.null(input$dates [2])) & is.null(input$dates [2])){print("dates")
    sanitaire<<-utf8(as.data.frame(dbGetQuery(con,paste0("SELECT numero_inrae, nom_registre, obs_date as date_observation, nom_experimentateur, sui_blessure as blessure, sui_comportement as comportement ,sui_condition_physique as condition_physique, sui_localisation_blessure as localisation_blessure, sui_mouche_eternue mouche_eternue, sui_observations_complementaires observations_complementaires, sui_photos photos, sui_posture posture, sui_remarque_generale remarque_generale, sui_salissure_arriere_train salissure_arriere_train, sui_secoue_oreillle secoue_oreillle, sui_secoue_oreillle_droite secoue_oreillle_droite, sui_secoue_oreillle_gauche secoue_oreillle_gauche, sui_texture_feces texture_feces, sui_videos videos
    FROM public.suivi_sanitaire where obs_date between '",input$dates [1],"' and '",input$dates [2],"'  order by obs_date desc;")))) #[,2:24]
    } else if (!is.null(input$numero_inrae) & (!is.null(input$dates [1])&!is.null(input$dates [2])) & is.null(input$nom_registre)) {print("num et date")
      sanitaire<<-utf8(as.data.frame(dbGetQuery(con,paste0("SELECT numero_inrae, nom_registre, obs_date as date_observation, nom_experimentateur, sui_blessure as blessure, sui_comportement as comportement ,sui_condition_physique as condition_physique, sui_localisation_blessure as localisation_blessure, sui_mouche_eternue mouche_eternue, sui_observations_complementaires observations_complementaires, sui_photos photos, sui_posture posture, sui_remarque_generale remarque_generale, sui_salissure_arriere_train salissure_arriere_train, sui_secoue_oreillle secoue_oreillle, sui_secoue_oreillle_droite secoue_oreillle_droite, sui_secoue_oreillle_gauche secoue_oreillle_gauche, sui_texture_feces texture_feces, sui_videos videos
    FROM public.suivi_sanitaire where obs_date between '",input$dates [1],"' and '",input$dates [2],"' and numero_inrae IN ",v2db(input$numero_inrae)," order by obs_date desc;")))) #[,2:24]
    } else if (!is.null(input$numero_inrae) & (is.null(input$dates [1])&is.null(input$dates [2])) & is.null(input$nom_registre)) { print("num")
      sanitaire<<-utf8(as.data.frame(dbGetQuery(con,paste0("SELECT numero_inrae, nom_registre, obs_date as date_observation, nom_experimentateur, sui_blessure as blessure, sui_comportement as comportement ,sui_condition_physique as condition_physique, sui_localisation_blessure as localisation_blessure, sui_mouche_eternue mouche_eternue, sui_observations_complementaires observations_complementaires, sui_photos photos, sui_posture posture, sui_remarque_generale remarque_generale, sui_salissure_arriere_train salissure_arriere_train, sui_secoue_oreillle secoue_oreillle, sui_secoue_oreillle_droite secoue_oreillle_droite, sui_secoue_oreillle_gauche secoue_oreillle_gauche, sui_texture_feces texture_feces, sui_videos videos
    FROM public.suivi_sanitaire where numero_inrae IN ",v2db(input$numero_inrae)," order by obs_date desc;"))))
    } else if (is.null(input$numero_inrae) & (!is.null(input$dates [1])&!is.null(input$dates [2])) & !is.null(input$nom_registre)) { print("nom et date")
      sanitaire<<-utf8(as.data.frame(dbGetQuery(con,paste0("SELECT numero_inrae, nom_registre, obs_date as date_observation, nom_experimentateur, sui_blessure as blessure, sui_comportement as comportement ,sui_condition_physique as condition_physique, sui_localisation_blessure as localisation_blessure, sui_mouche_eternue mouche_eternue, sui_observations_complementaires observations_complementaires, sui_photos photos, sui_posture posture, sui_remarque_generale remarque_generale, sui_salissure_arriere_train salissure_arriere_train, sui_secoue_oreillle secoue_oreillle, sui_secoue_oreillle_droite secoue_oreillle_droite, sui_secoue_oreillle_gauche secoue_oreillle_gauche, sui_texture_feces texture_feces, sui_videos videos
    FROM public.suivi_sanitaire where obs_date between '",input$dates [1],"' and '",input$dates [2],"' and nom_registre in ",v2db(input$nom_registre)," order by obs_date desc;"))))
    } else if (is.null(input$numero_inrae) & (is.null(input$dates [1])|is.null(input$dates [2])) & !is.null(input$nom_registre)) { print("nom")
      sanitaire<<-utf8(as.data.frame(dbGetQuery(con,paste0("SELECT numero_inrae, nom_registre, obs_date as date_observation, nom_experimentateur, sui_blessure as blessure, sui_comportement as comportement ,sui_condition_physique as condition_physique, sui_localisation_blessure as localisation_blessure, sui_mouche_eternue mouche_eternue, sui_observations_complementaires observations_complementaires, sui_photos photos, sui_posture posture, sui_remarque_generale remarque_generale, sui_salissure_arriere_train salissure_arriere_train, sui_secoue_oreillle secoue_oreillle, sui_secoue_oreillle_droite secoue_oreillle_droite, sui_secoue_oreillle_gauche secoue_oreillle_gauche, sui_texture_feces texture_feces, sui_videos videos
    FROM public.suivi_sanitaire where nom_registre in ",v2db(input$nom_registre)," order by obs_date desc;"))))
    } else if (!is.null(input$numero_inrae) & (!is.null(input$dates [1])&!is.null(input$dates [2])) & !is.null(input$nom_registre)) { print("tous");
      sanitaire<<-utf8(as.data.frame(dbGetQuery(con,paste0("SELECT numero_inrae, nom_registre, obs_date as date_observation, nom_experimentateur, sui_blessure as blessure, sui_comportement as comportement ,sui_condition_physique as condition_physique, sui_localisation_blessure as localisation_blessure, sui_mouche_eternue mouche_eternue, sui_observations_complementaires observations_complementaires, sui_photos photos, sui_posture posture, sui_remarque_generale remarque_generale, sui_salissure_arriere_train salissure_arriere_train, sui_secoue_oreillle secoue_oreillle, sui_secoue_oreillle_droite secoue_oreillle_droite, sui_secoue_oreillle_gauche secoue_oreillle_gauche, sui_texture_feces texture_feces, sui_videos videos
    FROM public.suivi_sanitaire where nom_registre in ",v2db(input$nom_registre)," and obs_date between '",input$dates [1],"' and '",input$dates [2],"' or numero_inrae IN ",v2db(input$numero_inrae)," and obs_date between '",input$dates [1],"' and '",input$dates [2],"' order by obs_date desc;"))))
    }
    sanitaire
  }
  
  #####################################################
  ############Affichage des données dans l'ui #########
  #####################################################


  output$sanitaire <- DT::renderDataTable({
    selData()
    DT::datatable(sanitaire, filter = "top",rownames = F,options = list(lengthMenu = c(10, 50, 100, 200, 300), pageLength = 250))
 })



#######################################  
#########export des données############      
######################################   

export <- function() {
  sanitaire
}

output$downloadcsv2 <-  downloadHandler(
  filename = function() {
    paste0("Suivi_sanitaire_", gsub("-","_",Sys.Date()),".csv")
  },
  content = function(file) {
    write.csv2(export(), file, row.names = FALSE, na ="")
  }
)

########################       
})