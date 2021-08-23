#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

shinyUI(
  navbarPage(windowTitle = "IE Gardouch: ", title=div(tags$a(href="https://github.com/yannickkk/Applicatifs_IE_Gardouch/blob/main/App_captures/Readme.md","Documentation", target ="_blank")), id = "tabs",
             #tabsetPanel(id = "tabs",
             tabPanel(title = "Marquage/prelevement/traitement", value = "A",
                      tags$head( ##########definition de class de css pour séparer les blocs de saisie avec des lignes grises
                        tags$style(HTML("
              .bottom {
              border-bottom-color: #efefef;
              border-bottom-width: 1px;
              border-bottom-style: solid;
              }
              .top {
              border-top-color: #efefef;
              border-top-width: 1px;
              border-top-style: solid;
              }
              .left {
              border-left-color: #efefef;
              border-left-width: 1px;
              border-left-style: solid;
              }
              ") # end HTML
                        ) # end tags$style
                      ), # end tags$head
                        fluidRow(#class = 'bottom',
                        shinyjs::useShinyjs(),
                        shinyjs::inlineCSS(appCSS),
                        shinyalert::useShinyalert(),
                        column(width= 1,HTML(paste0(h3("Identifiants"),'<br/>',"")),style="background-color:#efefef;"),
                        column(12),
                        column(2,selectInput(inputId ="login", label =labelMandatory("Utilisateur"), choices =c("","Nicolas Cebe","Arnaud Bonnet","Jean-Luc Rames","Marie-Line Maublanc","Hélène Verheyden"))),
                        bsTooltip("login", "Sélectionnez la personne qui saisie les données (champ obligatoire)","top", options = list(container = "body")),
                        #column(width= 1,HTML(paste0(h3("Identifiants"),'<br/>',"")),style="background-color:#efefef;"),
                        column(width= 2,numericInput(inputId = "ani_n_inra", label = labelMandatory("N°invariant animal"), value = 0, min =0, max = 99999, step = 1)),
                        bsTooltip("ani_n_inra", "Sélectionnez l\\'animal observé en entrant son numéro Inrae (champ obligatoire)","bottom", options = list(container = "body")),
                        column(width= 2,selectInput(inputId = "ani_nom_registre", label = labelMandatory("Nom"),choices =c("",utf8(as.data.frame(dbGetQuery(con,paste0("SELECT distinct(ani_nom_registre) from registre_gardouch"))))), selected ="")),
                        bsTooltip("ani_nom_registre", "Sélectionnez l\\'animal observé en entrant son nom (champ obligatoire)","top", options = list(container = "body")),
                        column(width= 2,textInput(inputId = "ani_transpondeur_id", label = "Code RFID")),
                        bsTooltip("ani_transpondeur_id", "Code RFID de l\\'annimal lors de la dernière capture","bottom", options = list(container = "body")),
                        column(width= 2,dateInput(inputId = "obs_date", label = labelMandatory("Date de capture"), value = "", format = "yyyy-mm-dd")),
                        bsTooltip("obs_date", "Date de l\\'observation de l\\'animal (champ obligatoire)","top", options = list(container = "body")),
                        column(width= 1,actionButton("subcol", "Créer capture", class = "btn-primary", cellArgs = list(style = "vertical-align: center"))),
                        bsTooltip("subcol", "Une fois les champs obligatoires remplis, cliquez sur ce bouton pour créer ou mettre à jour une observation","bottom", options = list(container = "body")),
                        tags$style(type='text/css', "#subcol {  margin-top: 25px;}"),
                        column(width= 1,actionButton("stop", "Stopper la mise à jour", class = "btn-primary", cellArgs = list(style = "vertical-align: center"))),
                        bsTooltip("stop", "Cliquez sur ce bouton pour stopper la mise à jour d\\'une observation","bottom", options = list(container = "body")),
                        tags$style(type='text/css', "#stop {  margin-top: 25px;}"),#width:100%;
                        column(class ='top', width= 12),#class ='top',
                        column(width= 1,HTML(paste0(h3("Marquage"),'<br/>',"")),style="background-color:#efefef;"),
                        column(width= 8,textInput(inputId = "cap_collier", label = "Collier"))),
                        bsTooltip("cap_collier", "Description du marquage qui permet l\\'identification visuelle de l\\'animal sur le terrain","bottom", options = list(container = "body")),
                        splitLayout( #cellArgs = list(style = "padding: 6px"), #style = "border: 1px solid silver;",
                        fluidRow(
                        column(width= 3,class = 'text-center', HTML(paste0(h3("Prélèvements"),'<br/>',"")),style="margin-left:250px;background-color:#efefef"),
                        column(width= 12),
                        column(width= 4,selectInput(inputId = "variable_1", label = "Peau/poils/feces", choices = list(votre_choix = "", Biopsie_peau= "cap_echt_peau",Poil_au_cou="cap_echt_poil_cou", Feces= "cap_echt_feces", Poil_croupe= "cap_echt_poil_croupe"))),
                        #bsTooltip("variable_1", "Sélectionnez quel échantillon a été prélevé sur l\\'animal","bottom", options = list(container = "body")),
                        #column(width= 3,timeInput(inputId = "variable_1_heure", label = "Heure prélèvement")),
                        column(width= 2,numericInput(inputId = "variable_1_valeur", label = "Nombre", value = NULL, min =0, max = 3, step = 1)),
                        #bsTooltip("variable_1_valeur", "Indiquez combien d\\'échantillons ont été prélevés sur l\\'animal","bottom", options = list(container = "body")),
                        column(width= 3,textInput(inputId = "variable_1_rq", label = "remarque")),
                        #bsTooltip("variable_1_rq", "faire une remarque sur l\\'échantillon concerné","bottom", options = list(container = "body")),
                        column(width= 12),
                        column(width= 4,selectInput(inputId = "variable_2", label = "Sang", choices = list(votre_choix = "",Tube_rouge ="cap_echt_sang_rouge", Tube_violet ="cap_echt_sang_violet", Tube_bleu ="cap_echt_sang_bleu"), selected = "")),
                        #bsTooltip("variable_2", "Sélectionnez quel échantillon a été prélevé sur l\\'animal","bottom", options = list(container = "body")),
                        #column(width= 3,timeInput(inputId = "variable_2_heure", label = "Heure prélèvement")),
                        column(width= 2,numericInput(inputId = "variable_2_valeur", label = "Nombre", value = NULL, min =0, max = 3, step = 1)),
                        #bsTooltip("variable_2_valeur", "Indiquez combien d\\'échantillons ont été prélevés sur l\\'animal","bottom", options = list(container = "body")),
                        column(width= 3,textInput(inputId = "variable_2_rq", label = "remarque")),
                        #bsTooltip("variable_2_rq", "faire une remarque sur l\\'échantillon concerné","bottom", options = list(container = "body")),
                        column(width= 12),
                        column(width= 4,selectInput(inputId = "variable_3", label = "Parasites", choices = list(votre_choix = "",prelevements_tiques ="cap_echt_tique"), selected = "")),
                        #bsTooltip("variable_3", "Sélectionnez quel échantillon a été prélevé sur l\\'animal","bottom", options = list(container = "body")),
                        #column(width= 3,timeInput(inputId = "variable_3_heure", label = "Heure prélèvement")),
                        column(width= 2,numericInput(inputId = "variable_3_valeur", label = "Nombre", value = NULL, min =0, max = 50, step = 1)),
                        #bsTooltip("variable_3_valeur", "Indiquez combien d\\'échantillons ont été prélevés sur l\\'animal","bottom", options = list(container = "body")),
                        column(width= 3,textInput(inputId = "variable_3_rq", label = "remarque")),
                        #bsTooltip("variable_3_rq", "faire une remarque sur l\\'échantillon concerné","bottom", options = list(container = "body")),
                        column(width= 12),
                        column(width= 4,selectInput(inputId = "variable_4", label = "Sécressions", choices = list(votre_choix = "",salive_1= "cap_echt_salive_1", salive_2= "cap_echt_salive_2", nasal= "cap_echt_nasal"), selected = "")),
                        #bsTooltip("variable_4", "Sélectionnez quel échantillon a été prélevé sur l\\'animal","bottom", options = list(container = "body")),
                        #column(width= 3,timeInput(inputId = "variable_4_heure", label = "Heure prélèvement")),
                        column(width= 2,numericInput(inputId = "variable_4_valeur", label = "Nombre", value = NULL, min =0, max = 3, step = 1)),
                        #bsTooltip("variable_4_valeur", "Indiquez combien d\\'échantillons ont été prélevés sur l\\'animal","bottom", options = list(container = "body")),
                        column(width= 3,textInput(inputId = "variable_4_rq", label = "remarque"))),
                        #bsTooltip("variable_4_rq", "faire une remarque sur l\\'échantillon concerné","bottom", options = list(container = "body")),
                        fluidRow(
                        column(width= 2, HTML(paste0(h3("Comptages"),'<br/>',"")),style="margin-left:290px;background-color:#efefef;"),
                        column(width= 12),
                        column(width= 4,selectInput(inputId = "variable_9", label = "Parasites", choices = list(votre_choix = "",comptage_tiques_oreilles= "cap_cnt_tiques_oreille", comptage_nbre_tiques_corps="cap_cnt_tiques",comptage_tiques_gorgees="cap_cnt_tiques_gorgees"))),
                        #bsTooltip("variable_9", "Sélectionnez quel parasite a été COMPTE sur l\\'animal","bottom", options = list(container = "body")),
                        #column(width= 3,timeInput(inputId = "variable_9_heure", label = "Heure prélèvement")),
                        column(width= 2,selectInput(inputId = "variable_9_valeur", label = "Nombre", choices = list(votre_choix = "","0","1","2","3","4","5","6","7","8","9","10","11-20","21-30",">30"))),
                        #bsTooltip("variable_9_valeur", "Indiquez combien parasites ont été COMPTES sur l\\'animal","bottom", options = list(container = "body")),
                        column(width= 3,textInput(inputId = "variable_9_rq", label = "remarque")),
                        #bsTooltip("variable_9_rq", "faire une remarque sur le COMPTAGE concerné","bottom", options = list(container = "body")),
                        column(width= 12),
                        column(width= 3,checkboxInput(inputId ="cap_puces_pres",  label ="Présence de puces"),style = "margin-left:5px;"),
                        column(width= 3,checkboxInput(inputId ="cap_poux_pres",  label ="Présence de poux"),style = "margin-left:5px;"),
                        column(width= 3,checkboxInput(inputId ="cap_hypobosq_pres",  label ="Présence d'hippobosques"),style = "margin-left:5px;"),
                        column(width= 12,style = "margin-left:5px;"),
                        column(width= 2,checkboxInput(inputId ="cap_bois_velour",  label ="Bois en velour"),style = "margin-left:5px;"),
                        column(width= 2,checkboxInput(inputId ="cap_bois_dur",  label ="Bois durs"),style = "margin-left:5px;"),
                        column(width= 2,checkboxInput(inputId ="cap_bois_tombe",  label ="Bois tombés"),style = "margin-left:5px;"),
                        column(width= 2,checkboxInput(inputId ="cap_bois_scies",  label ="Bois sciés"),style = "margin-left:5px;"),
                        column(width= 12),
                        column(width= 2,checkboxInput(inputId ="cap_allaitante",  label ="Allaitante"),style = "margin-left:5px;"),
                        column(width= 2,checkboxInput(inputId ="cap_diarrhee",  label ="Diarrhée"),style = "margin-left:5px;"),
                        column(width= 12),
                        column(width= 6,textInput(inputId = "cap_blessure", label = "Blessure"),style = "margin-top:25px;"),
                        column(width= 6,textInput(inputId = "cap_traitement", label = "Traitement"),style = "margin-top:25px;"))),
                        fluidRow(#class = 'top',
                        column(width= 1,class = 'text-center',HTML(paste0(h3("Anesthésie"),'<br/>',"")),style="background-color:#efefef;"),
                        column(width= 2,textInput(inputId = "cap_anesthesie", label = "Anesthésie produits")),
                        column(width= 2,timeInput(inputId = "cap_anesthesie_heure", label = "Heure anesthésie", seconds = FALSE)),
                        column(width= 2,timeInput(inputId = "cap_heure_reveil", label = "Heure de réveil", seconds = FALSE)),
                        #column(width= 1,numericInput(inputId = "cap_dose_acepromazine", label = "Dose acépro", value = NULL, min =0, max = 3, step = 0.1)),
                        #column(width= 3,textInput(inputId = "cap_tranquilisant", label = "Tranquilisant"))
                        ),
                        fluidRow(
                        column(width= 2,offset = 3,textInput(inputId = "cap_anesthesie_heure_remarque", label = "heure anesthésie rq")),
                        column(width= 2,textInput(inputId = "cap_heure_reveil_remarque", label = "heure rev rq", value = "")),
                        #column(width= 2,textInput(inputId = "cap_dose_acepromazine_remarque", label = "acepro rq", value = "")),
                        column(width= 12)),#class = 'top',
                        fluidRow(
                        column(2,checkboxInput(inputId ="trie_ani_present",  label ="Ne conserver que les animaux présents actuellement dans l'installation."),style = "margin-top:0px;"),
                        column(2,p(class = 'text-center', downloadButton('downloadcsv2', 'Télécharger csv2')),style = "margin-top:5px;"),
                        bsTooltip("downloadcsv2", "Le format csv est un format texte dans lequel les séparateur de colonnes sont des ; et les séparteurs de décimale des ,","bottom", options = list(container = "body")),
                        column(2,p(class = 'text-center', downloadButton('downloadxlsx', 'Télécharger xlsx')),style = "margin-top:5px;"),
                        bsTooltip("downloadxlsx", "Cela peut prendre un peut de temps","bottom", options = list(container = "body")),
                        column(2,p(class = 'text-center', downloadButton('downloadhtml', 'Télécharger html')),style = "margin-top:5px;"),
                        bsTooltip("downloadhtml", "Attention: Cela peut prendre du temps","bottom", options = list(container = "body"))),
                      
                      
                        DT::dataTableOutput("marquage", width = 300)  %>% withSpinner(color="#0dc5c1"), tags$hr()
                                              ),#)
             tabPanel(title = "Mesures", value = "B",
                      splitLayout(#class = 'bottom',
                      fluidRow(
                        column(width= 2,class = 'text-center',HTML(paste0(h3("Poids"),'<br/>',"")),style="margin-left:250px;background-color:#efefef;"),
                        column(12),
                        column(width= 2,selectInput(inputId = "cap_num_sabot", label = "N°Sabot", choices = c("",seq(1:25)), selected = "")),
                        column(width= 3,selectInput(inputId = "variable_8", label = "Poids du", choices = list("",sabot_plein="cap_boite_pleine",sabot_vide="cap_boite_vide", poids_animal ="cap_poids"), selected = "")),
                        column(width= 2,numericInput(inputId = "variable_8_valeur", label = "Poids", value = NULL, min =0, max = 60, step = 0.1)),
                        column(width= 2,textInput(inputId = "variable_8_rq", label = "remarque", value = "")),
                        column(12),style = "margin-bottom:200px;"),
                      fluidRow(
                        column(width= 3,class = 'text-center',HTML(paste0(h3("Heures et durée"),'<br/>',"")),style="margin-left:200px;background-color:#efefef;"),
                        column(12),
                        column(width= 3,selectInput(inputId = "variable_15", label = "quoi", choices = list("",heure_capture ="cap_heure_capture", mise_en_sabot="cap_heure_mise_sabot", fin_surv_sabot= "cap_heure_fin_surv", début_table="cap_heure_debut_table", fin_table ="cap_heure_fin_table",heure_lache = "cap_heure_lache" ,heure_second_lache = "cap_heure_second_lache"), selected = "")),
                        column(width= 3,timeInput(inputId = "variable_15_valeur", label = "heure/duree", seconds = FALSE)),
                        column(width= 2,textInput(inputId = "variable_15_rq", label = "remarque", value = "")),
                        column(12),style = "margin-bottom:200px;")),
                      fluidRow(
                        column(width= 2,class = 'text-center',HTML(paste0(h3("Mensurations"),'<br/>',"")),style="margin-left:180px;background-color:#efefef;"),
                        column(12),
                        column(width= 3,selectInput(inputId = "variable_5", label = "Quoi", choices = list(votre_choix = "",tarse = "cap_longueur_tarse",cou="cap_circ_cou",thorax="cap_circ_thorax",machoire="cap_longueur_machoire",bois_gauche="cap_lg_bois_g",bois_droit="cap_lg_bois_d",oreille="cap_lg_oreille"), selected = "")),
                        column(width= 1,numericInput(inputId = "variable_5_valeur", label = "Valeur", value = NULL, min =0, max = 3, step = 1)),
                        column(width= 1,textInput(inputId = "variable_5_rq", label = "remarque", value = "")),
                        column(12)),#class = 'bottom',
                      splitLayout(#class = 'bottom',
                      fluidRow(  
                        column(width= 4,class = 'text-center',HTML(paste0(h3("Mesures ponctuelles"),'<br/>',"")),style="margin-left:180px;background-color:#efefef;"),
                        column(12),
                        column(width= 3,selectInput(inputId = "variable_6", label = "Quoi", choices = list(votre_choix = "",cardio_20sec_1="cap_cardio_20_1",cardio_20sec_2="cap_cardio_20_2",cardio_20sec_3="cap_cardio_20_3", respiro_20sec_1="cap_respiro_20_1", respiro_20sec_2="cap_respiro_20_2", respiro_20sec_3="cap_respiro_20_3",glycemie_1="cap_glycemie_1",glycemie_2="cap_glycemie_2",glycemie_3="cap_glycemie_3"), selected = "")),
                        column(width= 2,numericInput(inputId = "variable_6_valeur", label = "Valeur", value = NULL, min =0, max = 3, step = 1)),
                        column(width= 4,timeInput(inputId = "variable_6_heure", label = "Heure de mesures", seconds = FALSE)),
                        column(width= 2,textInput(inputId = "variable_6_rq", label = "remarque", value = ""),style = "margin-bottom:200px;")),
                      fluidRow( 
                        column(width= 4,class = 'text-center',HTML(paste0(h3("Mesures répétées (suivi)"),'<br/>',"")),style="margin-left:160px;background-color:#efefef;"),
                        column(12),
                        column(width= 3,selectInput(inputId = "variable_7", label = "Quoi", choices = list(votre_choix = "",temp_ext="cap_suivi_temp_ext",temp_rectale="cap_suivi_temp_anale",rythme_cardiaque="cap_suivi_rythme_cardiaque",respiration="cap_suivi_rythme_respiration"), selected = "")),
                        column(width= 2,numericInput(inputId = "variable_7_valeur", label = "Valeur", value = NULL, min =0, max = 3, step = 1)),
                        column(width= 3,timeInput(inputId = "variable_7_heure", label = "Heure de mesures", seconds = TRUE)),
                        column(width= 2,textInput(inputId = "variable_7_rq", label = "remarque", value = "")),
                        column(width= 1,actionButton("valid", "Valider l'entrée", class = "btn-primary", cellArgs = list(style = "vertical-align: center")),style = "margin-top:25px;"),style = "margin-bottom:200px;")),
                      
                        
                         DT::dataTableOutput("mesure", width = 300) %>% withSpinner(color="#0dc5c1") , tags$hr()#,
                         #DT::dataTableOutput("mesure_long", width = 300) %>% withSpinner(color="#0dc5c1")
                      ),
             tabPanel(title = "Comportement", value = "C",
                      splitLayout(#class = 'bottom',
                      fluidRow(
                        column(width= 2,class = 'text-center',HTML(paste0(h3("Filet"),'<br/>',"")),style="margin-left:60px;background-color:#efefef;"),
                        column(width= 12),
                        column(width= 4,selectInput(inputId = "variable_10", label = "Quoi", choices = list(votre_choix = "", arrivee_course= "cap_arrivee_filet_course",arrivee_invisible="cap_arrivee_filet_pas_vu", arrivee_panique= "cap_filet_panique",lutte= "cap_filet_lutte", halete= "cap_filet_halete", cri="cap_filet_cri")),style = "margin-bottom:150px;"),
                        #column(width= 3,timeInput(inputId = "variable_10_heure", label = "Heure prélèvement")),
                        column(width= 2,selectInput(inputId = "variable_10_valeur", label = "Valeur", choices = list(votre_choix = "",oui = TRUE,non = FALSE))),
                        column(width= 3,textInput(inputId = "variable_10_rq", label = "remarque", value = ""))),
                      fluidRow(class = 'left',
                        column(width= 2,class = 'text-center',HTML(paste0(h3("Sabot"),'<br/>',"")),style="margin-left:60px;background-color:#efefef;"),
                        column(width= 12),
                        column(width= 4,selectInput(inputId = "variable_11", label = "Quoi", choices = list(votre_choix = "", retournement = "cap_sabot_retournement", couche= "cap_sabot_couche", agiation ="cap_sabot_agitation")),style = "margin-bottom:150px;"),
                        #column(width= 3,timeInput(inputId = "variable_11_heure", label = "Heure prélèvement")),
                        column(width= 2,selectInput(inputId = "variable_11_valeur", label = "Valeur", choices = list(votre_choix = "",oui = TRUE,non = FALSE))),
                        column(width= 3,textInput(inputId = "variable_11_rq", label = "remarque", value = "")),
                        #column(width= 12),
                        column(width= 2,textInput(inputId = "variable_12", label = "Observateurs sabot")))),
                        column(width= 12),
                      fluidRow(column(width= 12)),
                      splitLayout(#class = 'left',
                      fluidRow(
                        column(width= 2,class = 'text-center',HTML(paste0(h3("Table"),'<br/>',"")),style="margin-left:60px;background-color:#efefef;"),
                        column(width= 12),
                        column(width= 4,selectInput(inputId = "variable_13", label = "Quoi", choices = list(votre_choix = "", lutte= "cap_tble_lutte",halete="cap_tble_halete", cri_bague= "cap_tble_cri_bague",cri_autre= "cap_tble_cri_autre")),style = "margin-bottom:150px;"),
                        #column(width= 3,timeInput(inputId = "variable_13_heure", label = "Heure prélèvement")),
                        column(width= 2,selectInput(inputId = "variable_13_valeur", label = "Valeur", choices =  list(votre_choix = "",oui = TRUE,non = FALSE))),
                        column(width= 3,textInput(inputId = "variable_13_rq", label = "remarque", value = ""))),
                      fluidRow(class = 'left',
                        column(width= 2,class = 'text-center',HTML(paste0(h3("Lacher"),'<br/>',"")),style="margin-left:60px;background-color:#efefef;"),
                        column(width= 12),
                        column(width= 4,selectInput(inputId = "variable_14", label = "Quoi", choices = list(votre_choix = "",course = "cap_lache_course",bolide = "cap_lache_bolide",cabriole_saut = "cap_lache_cabriole_saut",gratte_collier="cap_lache_gratte_collier",tombe="cap_lache_tombe",calme = "cap_lache_calme",cri ="cap_lache_cri",titube="cap_lache_titube",couche = "cap_lache_couche")),style = "margin-bottom:150px;"),
                        #column(width= 3,timeInput(inputId = "variable_14_heure", label = "Heure prélèvement")),
                        column(width= 2,selectInput(inputId = "variable_14_valeur", label = "Valeur", choices = list(votre_choix = "",oui = TRUE,non = FALSE))),
                        column(width= 3,textInput(inputId = "variable_14_rq", label = "remarque", value = "")),
                        column(width= 12),
                        column(width= 2,selectInput(inputId = "cap_lache_visibilite", label = "visibilité", choices = list(votre_choix = "","0","0-10","10-50","50-100",">100"), selected ="")),
                        column(width= 2,numericInput(inputId = "cap_lache_nbre_stop", label = "Nombre de stops", value = NULL, min = 1, max = 20, step = 1),style = "margin-bottom:150px;"),
                        column(width= 2,selectInput(inputId = "cap_lache_public", label = "Nombre de personnes", choices = list(votre_choix = "","0","0-10","10-20","20-50",">50")),style = "margin-left:10px;"))),
                        
                         DT::dataTableOutput("comportement", width = 300)  %>% withSpinner(color="#0dc5c1"), tags$hr()
                      ),              
                      tags$head(
                        tags$style(HTML('.shiny-split-layout>div {overflow-x: hidden;}'))
                      ))
             )

dbDisconnect(con)