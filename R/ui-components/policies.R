Policies <- bs4TabItem(tabName = "policies",
  h2("Create Policy File", class = "text-center"),
  
  ### COURSE NAME ###
  fluidRow(
    bs4Card(
      width = 12,
      solidHeader = FALSE,
      headerBorder = FALSE,
      collapsible = FALSE,
      fluidRow(
        column(
          width = 12,
          div(
            class = "d-flex align-items-center",
            div(
              textOutput("course_name_display"),
              class = "h3 mr-2"
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
