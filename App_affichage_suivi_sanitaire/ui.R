# App to define new GPS device and annual configuration
shinyUI(
  navbarPage(windowTitle = "IE Gardouch: ", title=div(tags$a(href="https://github.com/yannickkk/Applicatifs_IE_Gardouch/blob/main/App_affichage_suivi_sanitaire/readme.md","Documentation", target ="_blank")),
             tabPanel("Suivi sanitaire",  
                      fluidRow(
                        shinyjs::useShinyjs(),
                        shinyalert::useShinyalert(),
                        column(width= 1,selectInput(inputId = "numero_inrae", label = "N° de l'animal", choices = dbGetQuery(con,"select distinct(numero_inrae) FROM public.suivi_sanitaire")[,1], selected = NULL, multiple = TRUE),style = "margin-top:25px;"), #
                        bsTooltip("numero_inrae", "Sélectionner un ou des animaux pas son, leur n°Inrae","top", options = list(container = "body")),
                        column(width= 1,selectInput(inputId = "nom_registre", label = "Nom", choices = dbGetQuery(con,"select distinct (nom_registre) FROM public.suivi_sanitaire")[,1], selected =NULL, multiple = TRUE),style = "margin-top:25px;"), #
                        bsTooltip("nom_registre", "Sélectionner un ou des animaux pas son, leur nom(s)","top", options = list(container = "body")),
                        column(width= 4,dateRangeInput(inputId = "dates",label = "choisissez une plage de dates",start = dbGetQuery(con,"select min(obs_date) FROM public.suivi_sanitaire")[,1],end = dbGetQuery(con,"select max(obs_date) FROM public.suivi_sanitaire")[,1],format = "dd/mm/yyyy",startview = "month",weekstart = 0,language = "fr",separator = " à ",width = NULL,autoclose = TRUE),style = "margin-top:25px;"),
                        #column(width= 1,selectInput(inputId = "blessure", label = "Blessure", choices = dbGetQuery(con,"select distinct (sui_blessure) FROM public.suivi_sanitaire")[,1], selected =NULL, multiple = TRUE),style =list("color: blue;","margin-top:25px;")), #
                        #bsTooltip("blessure", "Sélectionner un ou des animaux pas son, leur blessure(s)","top", options = list(container = "body")),
                        column(12),
                        column(2,p(class = 'text-center', downloadButton('downloadcsv2', 'Télécharger csv2'))),
                        column(12),
                        DT::dataTableOutput("sanitaire", width = 300)
                      ))
  ))