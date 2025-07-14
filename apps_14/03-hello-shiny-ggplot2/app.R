library(shiny)

ggplot2::theme_set(ggplot2::theme_bw())

ui <- fluidPage(
    selectInput(
        "var",
        "Choose a variable",
        choices = names(ggplot2::diamonds)
    ),
    plotOutput("plot")
)

server <- function(input, output, session) {
    output$plot <- renderPlot({
        ggplot2::ggplot(
            ggplot2::diamonds,
            ggplot2::aes(.data[[input$var]])
        ) +
        ggplot2::geom_bar()
    })
}

shinyApp(ui, server)
