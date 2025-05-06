Policies <- bs4TabItem(tabName = "policies",
                       #h2("Create Policy File", class = "text-center"),
                       
                       ### COURSE NAME ###
                       fluidRow(
                           bs4Card(
                               tags$head(
                                   tags$style(HTML("
                .buttons {
                  display: flex;
                  align-items: baseline;
                  flex-wrap: nowrap;
                  justify-content: space-between;
           
                }
                .title {
                  margin-right: 4rem;       /* space between title and uploads */
                }
              
                .buttons .form-group.shiny-input-container {
                  flex: 0 0 auto;
                  margin: 0 0.75rem 0 0; 
                }
              
                  .card-header .buttons .button-group {
                    display: flex;
                    align-items: center;
                 
                  }

                .buttons .download-buttons {
                  display: flex;
                }
                .download-button {
                width: 8rem;
                }
             
                            "))),
                               
                               width = 12,
                               solidHeader = TRUE,
                               title = tags$div(
                                   class = "buttons",
                                   
                                   # 1) the title
                                   tags$span("Create Policy File", class = "title"),
                                   
                                   # 2) two uploads (each fileInput lives in a .form-group)
                                   fileInput("upload_gs",     label = NULL,
                                             buttonLabel = "Upload Student Grades",
                                             accept      = ".csv"
                                   ),
                                   fileInput("upload_policy", label = NULL,
                                             buttonLabel = "Upload Policy File",
                                             accept      = ".yml"
                                   ),
                                   
                                   # 3) downloads—wrapped in a container for margin-left:auto
                                   tags$div(
                                       class = "download-buttons",
                                       downloadButton("download_grades",      "Grades",
                                                      class = "btn btn-outline-primary download-button"),
                                       downloadButton("download_policy_file","Policy File",
                                                      class = "btn btn-outline-primary download-button")
                                   )
                               ),
                               
                               headerBorder = TRUE,
                               collapsible = FALSE,
                               fluidRow(
                                   column(
                                       width = 12,
                                       div(
                                           class = "d-flex align-items-center",
                                           div(
                                               textOutput("course_name_display"),
                                               class = "h4 mr-3"
                                           ),
                                           actionButton("edit_policy_name", label = NULL, icon = icon("pen-to-square"))
                                       ),
                                       div(
                                           textOutput("course_description_display"),
                                           class = "mt-3"
                                       )
                                   )
                               )
                           )
                       ),
                       
                       ### CATEGORIES, LATENESS, SLIP DAYS TABS ###
                       bs4TabCard(
                           id = "policiesTabs",
                           width = 12,
                           side = "left",
                           status = "primary",
                           type = "tabs",
                           
                           ### TAB CATEGORIES ###
                           shiny::tabPanel(
                               title = "Categories",
                               icon = icon("list"),
                               fluidRow(
                                   column(
                                       width = 8,
                                       uiOutput("categoriesUI")
                                   ),
                                   column(
                                       width = 4,
                                       h4("New Assignments:"),
                                       uiOutput("unassigned")
                                   )
                               )
                           ),
                           
                           ### TAB LATENESS POLICY ###
                           shiny::tabPanel(
                               title = "Lateness Policy",
                               icon = icon("clock"),
                               fluidRow(
                                   column(
                                       width = 12,
                                       div(
                                           class = "d-flex align-items-center mb-2",
                                           h4("Add New Lateness Policy", class = "mr-2"),
                                           actionButton("new_lateness", label = NULL, icon = icon("plus"))
                                       ),
                                       hr()
                                   )
                               ),
                               fluidRow(
                                   column(
                                       width = 12,
                                       uiOutput("latenessUI")
                                   )
                               )
                           ),
                           
                           ### TAB SLIP DAYS ###
                           shiny::tabPanel(
                               title = "Slip Days",
                               icon = icon("calendar-days"),
                               fluidRow(
                                   column(
                                       width = 12,
                                       div(
                                           class = "d-flex align-items-center mb-2",
                                           h4("Add New Slip Days Policy", class = "mr-2"),
                                           actionButton("new_slip_days", label = NULL, icon = icon("plus"))
                                       ),
                                       hr()
                                   )
                               ),
                               fluidRow(
                                   column(
                                       width = 12,
                                       uiOutput("slip_days_ui")
                                   )
                               )
                           )
                       )
)
