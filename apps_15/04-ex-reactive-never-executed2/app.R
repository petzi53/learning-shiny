library(shiny)

reactlog::reactlog_enable()

ui <- fluidPage(
    actionButton("start", "Start"),
    actionButton("stop", "Stop"),
    textOutput("x")
)

server <- function(input, output, session) {
    r  <-  reactiveVal(FALSE)

    observeEvent(input$stop, {
        r(FALSE)
    })

    observeEvent(input$start, {
        r(TRUE)
    })

    x <- reactive({
        req(r())
        invalidateLater(500)
        rnorm(10)
    })

    output$x <- renderText({
        x()
    })
}

shinyApp(ui, server)
