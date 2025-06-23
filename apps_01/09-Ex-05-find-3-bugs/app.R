library(shiny)
library(ggplot2)

datasets <- c("economics", "faithfuld", "seals")
ui <- fluidPage(
    selectInput("dataset", label = "Dataset", choices = datasets),
    verbatimTextOutput("summary"),
    plotOutput("plot")
)

server <- function(input, output, session) {
    dataset <- reactive({
        get(input$dataset)
    })
    output$summary <- renderPrint({
        summary(dataset())
    })
    output$plot <- renderPlot({
        plot(dataset())
    }, res = 96)
}

shinyApp(ui, server)
