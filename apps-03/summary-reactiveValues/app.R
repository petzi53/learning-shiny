library(shiny)
library(ggplot2)


x <- round(rnorm(10000, mean = 0, sd = 1), 2)
y <- round(runif(10000, min = 1, max = 100), 0)

df <- tibble::tibble(x, y)

ui <- fluidPage(
    fluidRow(
        column(4,
               "x-Variable (rnorm)",
               numericInput("mean", label = "x", value = 0, step = 0.1),
               numericInput("sd", label = "σ", value = 1,
                            min = -5, max = 5, step = 0.1)
        ),
        column(4,
               "y-Variable (runif)",
               numericInput("n_max", label = "max value", value = 100,
                            min = 1, max = 1000, step = 1),
        ),
        column(4,
               "Controls",
               numericInput("bins", label = "Number of bins",
                            value = 30, step = 1,
                            min = 5, max = 200
                            )
        )
    ),
    fluidRow(
        column(12, plotOutput("hist"))
    )
)

server <- function(input, output, session) {

    # x <- reactive(round(rnorm(10000, input$mean, input$sd), 2))
    # y <- reactive(round(runif(10000, 1, input$n_max), 0))
    # df <- reactive(tibble::tibble(c(x(), y())))

    values <-  reactiveValues()
    values$tib <- df

    output$hist <- renderPlot({
        ggplot(values$tib, aes(values$tib$x)) +
            geom_histogram(bins = input$bins)
        }, res = 96)
}

shinyApp(ui, server)







