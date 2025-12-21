library(shiny)

ui <- fluidPage(
    textInput("label", "label"),
    selectInput("type", "type", c("slider", "numeric")),
    uiOutput("numeric")
)


server <- function(input, output, session) {
    output$numeric <- renderUI({
        if (input$type == "slider") {
            sliderInput("dynamic",
                        input$label,
                        value = 0,
                        min = 0,
                        max = 10)
        } else {
            numericInput("dynamic",
                         input$label,
                         value = 0,
                         min = 0,
                         max = 10)
        }
    })
}

shinyApp(ui, server)
