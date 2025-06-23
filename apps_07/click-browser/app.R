library(shiny)
library(ggplot2)
ggplot2::theme_set(ggplot2::theme_bw())

ui <- fluidPage(
    plotOutput("plot", click = "plot_click"),
    tableOutput("data")
)
server <- function(input, output, session) {
    output$plot <- renderPlot({
        ggplot(mtcars, aes(wt, mpg)) + geom_point()
    }, res = 96)

    output$data <- renderTable({
        req(input$plot_click)
        nearPoints(mtcars, input$plot_click)
    })
}

shinyApp(ui, server)
