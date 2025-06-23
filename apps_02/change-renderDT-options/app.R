library(shiny)

ui <- fluidPage(
    DT::DTOutput("table")
)

server <- function(input, output, session) {
    output$table <- DT::renderDT(
        mtcars,
        options = list(
            pageLength = 5,
            searching = FALSE,
            ordering = FALSE,
            lengthChange = FALSE
        )
    )
}

shinyApp(ui, server)
