library(shiny)
library(dplyr)
library(tidyr)
library(stringr)
library(leaflet)

#load the ui and server
source("hike_ui.R")
source("hike_server.R")

shinyApp(ui = ui, server = server)
