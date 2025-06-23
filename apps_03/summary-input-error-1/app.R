library(shiny)

ui <- fluidPage(
    textInput("msg",
              "front end interface"
    )
)


server <- function(input, output, server) {
    input$msg <- "back end logic"
}

shinyApp(ui, server)
