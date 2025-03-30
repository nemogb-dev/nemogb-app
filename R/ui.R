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
  minified = TRUE,
  expandOnHover = FALSE,
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
  # Add responsive CSS
  tags$head(
    tags$style(HTML("
      /* Make plots responsive */
      .responsive-plot .plotly {
        width: 100% !important;
        height: 300px !important;
      }
      
      /* Adjust plot height based on screen size */
      @media (max-width: 768px) {
        .responsive-plot .plotly {
          height: 250px !important;
        }
      }
      
      /* Ensure cards resize properly */
      .card {
        transition: width 0.3s, height 0.3s;
        overflow: auto;
      }
      
      /* Ensure content adjusts when sidebar is toggled */
      .content-wrapper {
        transition: margin-left 0.3s;
      }
      
      /* Make sure DataTables are responsive */
      .dataTables_wrapper {
        width: 100%;
        overflow-x: auto;
      }
      
      /* Ensure statistics container is responsive */
      .stats-container {
        width: 100%;
        margin-top: 1rem;
      }
      
      /* Add some spacing for better readability */
      .py-1 {
        padding-top: 0.25rem;
        padding-bottom: 0.25rem;
      }
      
      /* Create a custom class for vertical height */
      .vh-60 {
        height: 60vh;
      }
    "))
  ),
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