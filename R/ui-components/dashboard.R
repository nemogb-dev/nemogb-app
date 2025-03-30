Dashboard <- bs4TabItem(tabName = "dashboard",
  fluidRow(
    bs4Card(
      title = "Dashboard",
      width = 12,
      uiOutput("dashboard")
    )
  )
)