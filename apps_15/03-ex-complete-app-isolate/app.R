library(shiny)

ui <- fluidPage(
    numericInput("x", "x", value = 50, min = 0, max = 100),
    actionButton("capture", "capture"),
    textOutput("out")
)

server <- function(input, output, session) {
    output$out <- renderText({
        req(input$capture)
        isolate(input$x)
    })
}

shinyApp(ui, server)
