library(shiny)
library(ggplot2)


ui <- fluidPage(
    fluidRow(
        column(3,
               "Controls",
               numericInput("mean", label = "x", value = 0, step = 0.1),
               numericInput("sd", label = "σ", value = 1,
                            min = -5, max = 5, step = 0.1),
               numericInput("bins", label = "Number of bins",
                            value = 30, step = 1,
                            min = 5, max = 200
                            )
        ),
        column(9, plotOutput("hist"))
    ),
)

server <- function(input, output, session) {

    x <- reactive(round(rnorm(10000, input$mean, input$sd), 2))
    y <- reactive(round(runif(10000, 1, 100), 0))
    df <- reactive(data.frame(x(), y()))

    output$hist <- renderPlot({
        ggplot(df(), aes(x())) +
            geom_histogram(bins = input$bins)
        }, res = 96)
}

shinyApp(ui, server)







