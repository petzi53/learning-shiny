library(shiny)

reactlog::reactlog_enable()

ui <- fluidPage(
    selectInput("choice", "A or B?", c("a", "b")),
    numericInput("a", "a", 0),
    numericInput("b", "b", 10),
    textOutput("out")
)

server <- function(input, output, session) {
    output$out <- renderText({
        if (input$choice == "a") {
            input$a
        } else {
            input$b
        }
    })
}

shinyApp(ui, server)
