library(shiny)

f <- function(x) g(x)
g <- function(x) h(x)
h <- function(x) x * 2

ui <- fluidPage(
    selectInput("n", "N", 1:10),
    plotOutput("plot")
)
server <- function(input, output, session) {
    output$plot <- renderPlot({
        n <- f(input$n)
        plot(head(cars, n))
    }, res = 96)
}
shinyApp(ui, server)
