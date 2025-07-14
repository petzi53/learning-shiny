library(shiny)
library(reactlog)

reactlog_enable()

freqpoly <- function(x1, x2, binwidth = 0.1, xlim = c(-3, 3)) {
    df <- data.frame(
        x = c(x1, x2),
        g = c(rep("x1", length(x1)), rep("x2", length(x2)))
    )

    ggplot2::ggplot(df, ggplot2::aes(x, colour = g)) +
        ggplot2::geom_freqpoly(binwidth = binwidth, linewidth = 1) +
        ggplot2::coord_cartesian(xlim = xlim)
}

ggplot2::theme_set(ggplot2::theme_bw())

ui <- fluidPage(
    fluidRow(
        column(3,
               numericInput("lambda1", label = "lambda1", value = 3),
               numericInput("lambda2", label = "lambda2", value = 5),
               numericInput("n", label = "n", value = 1e4, min = 0)
        ),
        column(9, plotOutput("hist"))
    )
)
server <- function(input, output, session) {
    x1 <- reactive(rpois(input$n, input$lambda1), label = "x1")
    x2 <- reactive(rpois(input$n, input$lambda2), label = "x2")
    output$hist <- renderPlot({
        freqpoly(x1(), x2(), binwidth = 1, xlim = c(0, 40))
    }, res = 96)
}

shinyApp(ui, server)
