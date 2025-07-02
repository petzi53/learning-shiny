
ui <- fluidPage(
    sliderInput("x1", "x1", 0, min = -10, max = 10),
    sliderInput("x2", "x2", 0, min = -10, max = 10),
    sliderInput("x3", "x3", 0, min = -10, max = 10),
    actionButton("reset", "Reset")
)

server <- function(input, output, session) {
    observeEvent(input$reset, {
        updateSliderInput(inputId = "x1", value = 0)
        updateSliderInput(inputId = "x2", value = 0)
        updateSliderInput(inputId = "x3", value = 0)
    })
}

shinyApp(ui, server)
