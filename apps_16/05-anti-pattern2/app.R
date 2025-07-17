library(shiny)

ui <- fluidPage(
    numericInput("nrows", "How many rows to show?", value = 6),
    plotOutput("plot"),
    tableOutput("table")
)

server <- function(input, output, session) {
    df <- reactive(head(datasets::cars, input$nrows))

    output$plot <- renderPlot(plot(df()))
    output$table <- renderTable(df())
}

shinyApp(ui, server)
