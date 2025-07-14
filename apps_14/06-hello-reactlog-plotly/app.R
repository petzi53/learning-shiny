library(shiny)

reactlog::reactlog_enable()

ui <- fluidPage(
    selectInput(
        "var",
        "Choose a variable",
        choices = names(ggplot2::diamonds)
    ),
    plotly::plotlyOutput("plot")
)

server <- function(input, output, session) {
    p <- reactive({
        plotly::plot_ly(x = ggplot2::diamonds[[input$var]],
                type = "histogram")
    })

    output$plot <- plotly::renderPlotly({
        p()
    })
}

shinyApp(ui, server)
