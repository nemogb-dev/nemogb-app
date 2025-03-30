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
    id = "sidebarMenu", 
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
    # Wrap extra controls in a div
    tags$div(class = "sidebar-extra-content",
      # Upload controls
      fileInput("upload_gs", "Upload Student Data", accept = c(".csv")),
      fileInput("upload_policy", "Upload Policy File", accept = c(".yml")),
      # Download controls
      downloadButton("download_grades", "Grades"),
      downloadButton("download_policy_file", "Policy File")
    )
  )
)

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

body <- bs4DashBody(
  tags$head(
    tags$style(HTML("
      /* Custom CSS rules */
      .vh-30 {
        height: 30vh;
      }
      .vh-60 {
        height: 60vh;
      }

      /* Hide sidebar-extra-content when sidebar is collapsed */
      body.sidebar-collapse .sidebar-extra-content {
        display: none;
      }

      /* Styling for extra content when sidebar is EXPANDED */
      .sidebar-extra-content {
        padding-left: 8px;  /* Match typical sidebar padding */
        padding-right: 8px;
        margin-top: 10px; /* Add some space above */
      }

      .sidebar-extra-content .form-group label {
         margin-left: 2px; /* Align label slightly */
      }

      /* Style file inputs and download buttons */
      .sidebar-extra-content .form-group,
      .sidebar-extra-content .btn {
          width: 100%;          /* Make them fill available width */
          margin-left: 0;       /* Remove previous margin */
          margin-right: 0;      /* Remove previous margin */
          margin-bottom: 10px;
          box-sizing: border-box; /* Include padding/border in width */
      }

      /* Ensure buttons don't change size on hover/focus */
      .sidebar-extra-content .btn:hover,
      .sidebar-extra-content .btn:focus {
          /* Add specific styles if needed, but often just ensuring width: 100% is enough */
      }
    "))
  ),
  bs4TabItems(
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
  dark = NULL,
  help = NULL,
  header = dashboardHeader(
    title = dashboardBrand(
      title = "Nemo Gradebook",
      image = 'https://m.media-amazon.com/images/I/71giHMMMxpL.jpg', 
    ),
    controlbarIcon = NULL,
    fixed = TRUE
  ),
  sidebar = sidebar,
  controlbar = controlbar,
  footer = footer,
  body = body
)