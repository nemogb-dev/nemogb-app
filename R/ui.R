library(bs4Dash)
library(shiny)

# Define UI component directory and source files
UICompDirectory <- "ui-components/"

# Get app version from git tag
app_version <- tryCatch({
  system("git describe --tags --abbrev=0", intern = TRUE)
}, error = function(e) {
  "dev"
})

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
      tags$div(class = "download-buttons-container",
        downloadButton("download_grades", "Grades"),
        downloadButton("download_policy_file", "Policy File")
      )
    )
  )
)

controlbar <- bs4DashControlbar(
  id = "controlbar",
  skin = "light",
  title = "Options",
  collapsed = TRUE
)

# Simple footer with version tooltip
footer <- bs4DashFooter(
  fixed = FALSE,
  left = tags$div(class = "version-tooltip",
    icon("question-circle"),
    tags$div(class = "tooltiptext", paste0("NemoGB Version: ", app_version))
  ),
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
      
      /* Container for download buttons to ensure vertical stacking */
      .download-buttons-container {
          display: flex;
          flex-direction: column;
          width: 100%;
      }
      
      /* Ensure each button in the container takes full width */
      .download-buttons-container .btn {
          display: block;
          width: 100%;
          margin-bottom: 10px;
          white-space: normal; /* Allow text to wrap */
          word-wrap: break-word;
      }

      /* Ensure buttons don't change size on hover/focus */
      .sidebar-extra-content .btn:hover,
      .sidebar-extra-content .btn:focus {
          /* Add specific styles if needed, but often just ensuring width: 100% is enough */
      }
      
      /* Version tooltip styles */
      .version-tooltip {
        cursor: pointer;
        display: inline-block;
        position: relative;
      }
      .tooltiptext {
        visibility: hidden;
        font-size: .8em;
        background-color: #555;
        color: #fff;
        text-align: center;
        border-radius: 6px;
        padding: 5px;
        position: absolute;
        z-index: 1;
        left: 105%;
        bottom: 0;
        margin-left: 5px;
        opacity: 0;
        transition: opacity 0.3s;
      }
      .version-tooltip:hover .tooltiptext {
        visibility: visible;
        opacity: 1;
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