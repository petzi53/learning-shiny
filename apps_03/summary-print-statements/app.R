library(shiny)

ui <- fluidPage(
    print("front end interface")
)

server <- function(input, output, session) {
    print("back end logic")

}

shinyApp(ui, server)
