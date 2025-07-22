library(shiny)

source("histogramUI.R")
source("histogramServer.R")

histogramApp <- function() {
    ui <- fluidPage(
        histogramUI("hist1")
    )
    server <- function(input, output, session) {
        histogramServer("hist1")
    }
    shinyApp(ui, server)
}
