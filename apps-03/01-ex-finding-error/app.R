library(shiny)

ui <- fluidPage(
    textInput("name", "What's your name?"),
    textOutput("greeting")
)


server <- function(input, output, server) {
    output$greeting <- renderText(paste0("Hello", input$name))
}

shinyApp(ui, server)
