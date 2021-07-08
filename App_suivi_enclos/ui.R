ui <- navbarPage("IE Gardouch: ",
                 tabPanel(title = "Animaux", value = "A",
                          fluidRow(
                            # shinyjs::useShinyjs(),
                            # shinyjs::inlineCSS(appCSS),
                            # shinyalert::useShinyalert(),
                            column(
                              3,
                              div(id = "interactiveActionsi",
                                  class = "optionsSection",
                                  uiOutput("selectuser", inline = TRUE)
                              )
                            ),
                            column(
                              3,
                              div(id = "interactiveActionsi",
                                  class = "optionsSection",
                                  tags$h4("Actions:"),
                                  actionButton("fiti", "afficher tout"),
                                  # actionButton("setWindowAnimi", "Afficher une fenetre entre 2016-01-07 et 2016-01-25"),
                                  # actionButton("setWindowNoAnimi", "Set window without animation"),
                                  # actionButton("centeri", "centrer autour du 2016-01-23"),
                                  # actionButton("focus2i", "Focus item 4"),
                                  actionButton("focusSelectioni", "centrer sur la selection")
                                  #actionButton("addTime", "Add a draggable vertical bar 2016-01-17")
                              )
                            )
                          ),
                          fluidRow(
                            column(
                              3,
                              div(class = "optionsSection",
                                  uiOutput("selectIdsOutputi", inline = TRUE),
                                  actionButton("selectItemsi", "Selectionner des animaux"),
                                  #checkboxInput("selectFocusi", "Focus on selection", FALSE),
                                  checkboxInput("selectpresi", "Afficher seulement les animaux present aujourd'hui", TRUE)
                              )
                            ),
                            column(
                              3,
                              div(class = "optionsSection",
                                  uiOutput("begDateOutputi", inline = TRUE),
                                  uiOutput("endDateOutputi", inline = TRUE)
                              )
                              # div(class = "optionsSection",
                              #     textInput("addTexti", tags$h4("Add item:"), "New item"),
                              #     dateInput("addDatei", NULL, "2016-01-15"),
                              #     actionButton("addBtni", "Add")
                              # )
                            ),
                            column(
                              3,
                              div(class = "optionsSection",
                                  uiOutput("selectIdsOutputee", inline = TRUE),
                                  uiOutput("remark", inline = TRUE)
                                 # uiOutput("removeIdsOutputi", inline = TRUE),
                                #  actionButton("removeItemi", "Remove")
                              )
                            ),
                            column(
                              3,
                              div(class = "optionsSection",
                                  uiOutput("enterItemiOutput", inline = TRUE), style="margin-top:150px"
                            )
                          )),
                          fluidRow(
                            column(2,p(class = 'text-center', downloadButton('downloadcsv2', 'Télécharger csv2')),style = "margin-top:5px;"),
                            #bsTooltip("downloadcsv2", "Le format csv est un format texte dans lequel les séparateur de colonnes sont des ; et les séparteurs de décimale des ,","bottom", options = list(container = "body")),
                            #bsTooltip("downloadxlsx", "Cela peut prendre un peut de temps","bottom", options = list(container = "body")),
                            column(2,p(class = 'text-center', downloadButton('downloadhtml', 'Télécharger html')),style = "margin-top:5px;")),
                            #bsTooltip("downloadhtml", "Attention: Cela peut prendre du temps","bottom", options = list(container = "body"))),
                          
                          column(12),
                          fluidRow(
                            column(12, timevisOutput("timelineInteractivei")))
                 ),
                 # tabPanel(title = "data individus", value = "B",
                 #          fluidRow(
                 #            div("Selected items:", textOutput("selectedi", inline = TRUE)),
                 #            div("Visible window:", textOutput("windowi", inline = TRUE)),
                 #            tableOutput("tablei")
                 #          )),
                 tabPanel(title = "Enclos", value = "C",
                          fluidRow(
                            # shinyjs::useShinyjs(),
                            # shinyjs::inlineCSS(appCSS),
                            # shinyalert::useShinyalert(),
                            column(
                              12,
                              div(id = "interactiveActionse",
                                  class = "optionsSection",
                                  tags$h4("Actions:"),
                                  actionButton("fite", "afficher tout"),
                                  actionButton("focusSelectione", "centrer sur la selection")
                              )
                            )
                          ),
                          fluidRow(
                            column(
                              4,
                              div(class = "optionsSection",
                                  uiOutput("selectIdsOutpute", inline = TRUE),
                                  actionButton("selectItemse", "Selectionner enclos"),
                                  #checkboxInput("selectpresi", "Afficher seulement les animaux présent aujourd'hui", FALSE)
                              )
                            ),
                          fluidRow(
                          column(2,p(class = 'text-center', downloadButton('downloadcsv2e', 'Télécharger csv2')),style = "margin-top:5px;"),
                          #bsTooltip("downloadcsv2", "Le format csv est un format texte dans lequel les séparateur de colonnes sont des ; et les séparteurs de décimale des ,","bottom", options = list(container = "body")),
                          #bsTooltip("downloadxlsx", "Cela peut prendre un peut de temps","bottom", options = list(container = "body")),
                          column(2,p(class = 'text-center', downloadButton('downloadhtmle', 'Télécharger html')),style = "margin-top:5px;")),
                          #bsTooltip("downloadhtml", "Attention: Cela peut prendre du temps","bottom", options = list(container = "body"))),
                            
                          column(12),
                          fluidRow(
                            column(12, timevisOutput("timelineInteractivee")))
                 ))
                 # tabPanel(title = "data enclos", value = "D",
                 #          fluidRow(
                 #            div("Selected items:", textOutput("selectede", inline = TRUE)),
                 #            div("Visible window:", textOutput("windowe", inline = TRUE)),
                 #            tableOutput("tablee")
                 #          ))
)
