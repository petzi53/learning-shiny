library(shiny)
library(ggplot2)

set.seed(1014)
df <- data.frame(x = rnorm(100), y = rnorm(100))

ui <- fluidPage(
    plotOutput("plot", click = "plot_click", )
)
server <- function(input, output, session) {
    dist <- reactiveVal(rep(1, nrow(df)))
    observeEvent(input$plot_click,
                 dist(nearPoints(df, input$plot_click, allRows = TRUE, addDist = TRUE)$dist_)
    )

    output$plot <- renderPlot({
        df$dist <- dist()
        ggplot(df, aes(x, y, size = dist)) +
            geom_point() +
            scale_size_area(limits = c(0, 1000), max_size = 10, guide = NULL)
    }, res = 96)
}

shinyApp(ui, server)
