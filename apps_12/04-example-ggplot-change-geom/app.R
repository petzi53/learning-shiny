library(shiny)

ui <- fluidPage(
    selectInput("x", "X variable", choices = names(iris)),
    selectInput("y", "Y variable", choices = names(iris)),
    selectInput("geom", "geom", c("point", "smooth", "jitter")),
    plotOutput("plot")
)
server <- function(input, output, session) {
    plot_geom <- reactive({
        switch(input$geom,
               point = ggplot2::geom_point(),
               smooth = ggplot2::geom_smooth(
                   se = FALSE,
                   method = "loess",
                   formula = y ~ x ),
               jitter = ggplot2::geom_jitter()
        )
    })

    output$plot <- renderPlot({
        ggplot2::ggplot(iris, ggplot2::aes(.data[[input$x]], .data[[input$y]])) +
            plot_geom()
    }, res = 96)
}

shinyApp(ui, server)
