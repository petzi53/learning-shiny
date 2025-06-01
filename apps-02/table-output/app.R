library(shiny)

ui <- fluidPage(
    tableOutput("static"),
    DT::DTOutput("dynamic")
)

server <- function(input, output, session) {
    output$static <- renderTable(head(mtcars))
    output$dynamic <- DT::renderDT(mtcars, options = list(pageLength = 5))
}

shinyApp(ui, server)
