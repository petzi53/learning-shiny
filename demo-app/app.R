library(shiny)

ui <- fluidPage(
    textInput("name",  msg1),
    textOutput("greeting"),
)

server <- function(input, output, session) {
    output$greeting <- renderText({
        paste0(msg2, input$name)
    })
}

shinyApp(ui, server)
