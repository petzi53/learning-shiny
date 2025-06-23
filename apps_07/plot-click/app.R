library(shiny)

ui <- fluidPage(
    plotOutput("plot", click = "plot_click"),
    verbatimTextOutput("coord")
)

server <- function(input, output, session) {
    output$plot <- renderPlot({
        plot(mtcars$mpg, mtcars$wt)
    }, res = 96)

    output$coord <- renderText({
        req(input$plot_click)
        x <- round(input$plot_click$x, 2)
        y <- round(input$plot_click$y, 2)
        cat("[", x, " ,", y, "]", sep = "")
    })

}

shinyApp(ui, server)
