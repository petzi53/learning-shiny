library(shiny)

ui <- fluidPage(
    numericInput("nrows", "How many rows to show?", value = 6),
    plotOutput("plot"),
    tableOutput("table")
)

server <- function(input, output, session) {
    r <- reactiveValues(df = datasets::cars)
    observe({
        r$df <- head(datasets::cars, input$nrows)
    })

    output$plot <- renderPlot(plot(r$df))
    output$table <- renderTable(r$df)
}

shinyApp(ui, server)
