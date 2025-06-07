library(shiny)
library(glue)

ui <- fluidPage(
    sliderInput("x", "x", value = 1, min = 0, max = 10),
    sliderInput("y", "y", value = 2, min = 0, max = 10),
    sliderInput("z", "z", value = 3, min = 0, max = 10),
    textOutput("total")
)
server <- function(input, output, session) {
    observeEvent(input$x, {
        updateSliderInput(session, "y", value = input$x * 2)
    })

    total <- reactive({
        total <- input$x + input$y + input$z
        message(glue("New total is x+y+z = {input$x} + {input$y} + {input$z} = {total}"))
        total
    })

    output$total <- renderText({
        total()
    })
}

shinyApp(ui, server)
