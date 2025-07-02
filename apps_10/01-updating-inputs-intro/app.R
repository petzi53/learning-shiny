library(shiny)

ui <- fluidPage(
    numericInput("min", "Minimum", 0),
    numericInput("max", "Maximum", 3),
    sliderInput("n", "n", min = 0, max = 3, value = 1)
)
server <- function(input, output, session) {
    observeEvent(input$min, {
        updateSliderInput(inputId = "n", min = input$min)
    })
    observeEvent(input$max, {
        updateSliderInput(inputId = "n", max = input$max)
    })
}

shinyApp(ui, server)
