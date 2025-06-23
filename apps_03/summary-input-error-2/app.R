library(shiny)

ui <- fluidPage(
    textInput("msg",
              "back end logic"
    )
)


server <- function(input, output, server) {
    message("This is the ", input$msg)
}

shinyApp(ui, server)
