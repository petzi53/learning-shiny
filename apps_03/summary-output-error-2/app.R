library(shiny)

ui <- fluidPage(
    textOutput("msg")
)

server <- function(input, output, server) {
    message("This is the ", output$msg)
}

shinyApp(ui, server)
