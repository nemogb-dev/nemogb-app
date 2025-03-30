#load libraries
library(bs4Dash)
library(shiny)
library(DT)
library(shinyWidgets)
library(tidyverse)
library(nemogb)
library(yaml)

#load ui and server
source("ui.R")
source("server.R")

shinyApp(ui, server)