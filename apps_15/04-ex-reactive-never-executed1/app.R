library(shiny)

reactlog::reactlog_enable()

ui <- fluidPage(
)

server <- function(input, output, session) {
    x <- reactive({
        invalidateLater(500)
        rnorm(10)
    })

}

shinyApp(ui, server)
