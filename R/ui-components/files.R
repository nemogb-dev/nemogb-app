Files <- bs4TabItem(tabName = "files",
  h2("Files"),
  fluidRow(
    bs4TabCard(
      id = "filesTabs",
      width = 12,
      status = "primary",
      type = "tabs",
      shiny::tabPanel(
        title = "Original Gradescope Data",
        dataTableOutput("original_gs")
      ),
      shiny::tabPanel(
        title = "Assignments Table",
        dataTableOutput("assigns_table")
      ),
      shiny::tabPanel(
        title = "Flat Policy File",
        verbatimTextOutput("flat_policy_list")
      ),
      shiny::tabPanel(
        title = "Final Grades",
        dataTableOutput("grades")
      )
    )
  )
)