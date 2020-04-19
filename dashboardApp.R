
library(shiny)
library("plotly")
library("leaflet")
library(shinydashboard)
library(highcharter)

ui <- source(file.path(".", "ui.R"), local = TRUE)$value

#server <- function(input, output) { }
server <- source(file.path(".", "server.R"), local = TRUE)$value

shinyApp(ui, server)