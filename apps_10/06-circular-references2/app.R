library(shiny)

ui <- fluidPage(
    titlePanel("Demo of circular references"),
    actionButton("start", "Start"),
    actionButton("stop", "Stop"),
    numericInput("n", "n", 0)
)

server <- function(input, output){
    v <- reactiveValues(run = NULL)

    observeEvent(input$n, {
         if (req(v$run)) {
            updateNumericInput(inputId = "n", value = input$n + 1)
         } else {
            v$run <- NULL
         }
    })

    observeEvent(input$start, {
        v$run <- TRUE
        updateNumericInput(inputId = "n", value = input$n + 1)
    })

    observeEvent(input$stop, {
        v$run <- FALSE
        updateNumericInput(inputId = "n", value = 0)
    })
}

shinyApp(ui, server)
