library(shiny)

ui <- fluidPage(
    title = "Central limit theorem",
    fluidRow(
        column(width = 6,
               plotOutput("hist1")
        ),
        column(width = 6,
               plotOutput("hist2")
        ),
    ),
    fluidRow(
        column(width = 6,
               numericInput("m1", "Number of samples: (1-100)", 2, min = 1, max = 100)
        ),
        column(width = 6,
               numericInput("m2", "Number of samples: (1-100)", 2, min = 1, max = 100)
        )
    )
)


server <- function(input, output, session) {
    output$hist1 <- renderPlot({
        means <- replicate(1e4, mean(runif(input$m1)))
        hist(means, breaks = 20)
    }, res = 96)

    output$hist2 <- renderPlot({
        means <- replicate(1e4, mean(runif(input$m2)))
        hist(means, breaks = 20)
    }, res = 96)
}

shinyApp(ui, server)
