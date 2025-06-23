library(shiny)

ui <- fluidPage(
    textOutput("msg")
)

server <- function(input, output, server) {
    output$msg <-  "back end logic"
}

shinyApp(ui, server)
