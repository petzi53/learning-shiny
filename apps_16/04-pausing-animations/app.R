library(shiny)

ui <- fluidPage(
    actionButton("start", "start"),
    actionButton("stop", "stop"),
    textOutput("n")
)
server <- function(input, output, session) {
    r <- reactiveValues(running = FALSE, n = 0)

    observeEvent(input$start, {
        r$running <- TRUE
    })
    observeEvent(input$stop, {
        r$running <- FALSE
    })

    observe({
        if (r$running) {
            r$n <- isolate(r$n) + 1
            invalidateLater(250)
        }
    })
    output$n <- renderText(r$n)
}

shinyApp(ui, server)
