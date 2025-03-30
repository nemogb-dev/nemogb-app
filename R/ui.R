library(bs4Dash)
library(shiny)

# Define UI component directory and source files
UICompDirectory <- "ui-components/"

source(paste0(UICompDirectory, "files.R"), local = TRUE)
source(paste0(UICompDirectory, "policies.R"), local = TRUE)
source(paste0(UICompDirectory, "dashboard.R"), local = TRUE)

# Define basic UI components
sidebar <- bs4DashSidebar(
  skin = "light",
  bs4SidebarMenu(
    bs4SidebarMenuItem(
      text = "Dashboard",
      tabName = "dashboard",
      icon = icon("chart-line")
    ),
    bs4SidebarMenuItem(
      text = "Policies",
      tabName = "policies",
      icon = icon("file-pen")
    ),
    # Upload controls
    fileInput("upload_gs", "Upload Student Data", accept = c(".csv")),
    fileInput("upload_policy", "Upload Policy File", accept = c(".yml")),
    # Download controls
    downloadButton("download_grades", "Grades"),
    downloadButton("download_policy_file", "Policy File")
  )
)

# Empty controlbar for now
controlbar <- bs4DashControlbar(
  id = "controlbar",
  skin = "light",
  title = "Options",
  collapsed = TRUE
)

# Simple footer
footer <- bs4DashFooter(
  fixed = FALSE,
  right = "Nemo Gradebook"
)

# Main body with tabsets - using the sourced components
body <- bs4DashBody(
  # # Add CSS to override white backgrounds
  # tags$head(
  #   tags$style(HTML("
  #     /* Override white backgrounds in components */
  #     .card, .tab-content, .box, .tab-pane, .card-body {
  #       background-color: transparent !important;
  #     }
  #     /* Remove borders that might make white backgrounds stand out */
  #     .card, .box {
  #       border: none !important;
  #       box-shadow: none !important;
  #     }
  #     /* Override any inline styles with !important */
  #     [style*='background-color: #ffffff'] {
  #       background-color: transparent !important;
  #     }
  #     /* Make sure text is visible against the page background */
  #     body {
  #       color: #333;
  #     }
  #   "))
  # ),
  bs4TabItems(
    # Convert the sourced tabItems to bs4TabItems
    bs4TabItem(
      tabName = "dashboard",
      Dashboard$children
    ),
    bs4TabItem(
      tabName = "policies",
      Policies$children
    )
  )
)

ui <- bs4DashPage(
  title = "Nemo Gradebook",
  skin = "light",
  header = dashboardHeader(
    title = "Nemo Gradebook",
    controlbarIcon = NULL,  # Remove the question mark toggle
    fixed = TRUE
  ),
  sidebar = sidebar,
  controlbar = controlbar,
  footer = footer,
  body = body
)