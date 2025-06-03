# # source .R file with the two functions didn't work
# freqpoly <- function(x1, x2, binwidth = 0.1, xlim = c(-3, 3)) {
#     df <- base::data.frame(
#         x = base::c(x1, x2),
#         g = base::c(base::rep("x1", base::length(x1)),
#                     base::rep("x2", base::length(x2)))
#     )
#
#     ggplot2::ggplot(df, ggplot2::aes(x, colour = g)) +
#         ggplot2::geom_freqpoly(binwidth = binwidth, linewidth = 1) +
#         ggplot2::coord_cartesian(xlim = xlim)
# }
#
# t_test <- function(x1, x2) {
#     test <- stats::t.test(x1, x2)
#
#     # use sprintf() to format t.test() results compactly
#     base::sprintf(
#         "p value: %0.3f\n[%0.2f, %0.2f]",
#         test$p.value, test$conf.int[1], test$conf.int[2]
#     )
# }

source(
    paste0(here::here(), "/R/shiny-03-V2.R"),
    local = TRUE,
    chdir = TRUE,
    encoding = "utf-8"
    )

library(shiny)
library(ggplot2)
library(munsell)

ui <- fluidPage(
    fluidRow(
        column(4,
               "Distribution 1",
               numericInput("n1", label = "n", value = 1000, min = 1),
               numericInput("mean1", label = "µ", value = 0, step = 0.1),
               numericInput("sd1", label = "σ", value = 0.5, min = 0.1, step = 0.1)
        ),
        column(4,
               "Distribution 2",
               numericInput("n2", label = "n", value = 1000, min = 1),
               numericInput("mean2", label = "µ", value = 0, step = 0.1),
               numericInput("sd2", label = "σ", value = 0.5, min = 0.1, step = 0.1)
        ),
        column(4,
               "Frequency polygon",
               numericInput("binwidth", label = "Bin width", value = 0.1, step = 0.1),
               sliderInput("range", label = "range", value = c(-3, 3), min = -5, max = 5)
        )
    ),
    fluidRow(
        column(9, plotOutput("hist")),
        column(3, verbatimTextOutput("ttest"))
    )
)

server <- function(input, output, session) {
    output$hist <- renderPlot({
        x1 <- rnorm(input$n1, input$mean1, input$sd1)
        x2 <- rnorm(input$n2, input$mean2, input$sd2)

        freqpoly(x1, x2, binwidth = input$binwidth, xlim = input$range)
    }, res = 96)

    output$ttest <- renderText({
        x1 <- rnorm(input$n1, input$mean1, input$sd1)
        x2 <- rnorm(input$n2, input$mean2, input$sd2)

        t_test(x1, x2)
    })
}

shinyApp(ui, server)
