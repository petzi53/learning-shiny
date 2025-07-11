library(shiny)

ui <- fluidPage(
    selectInput("var", "Select variable", choices = names(mtcars)),
    sliderInput("min", "Minimum value", 0, min = 0, max = 100),
    selectInput("sort", "Sort by", choices = names(mtcars)),
    tableOutput("data")
)
server <- function(input, output, session) {
    observeEvent(input$var, {
        rng <- range(mtcars[[input$var]])
        updateSliderInput(
            session, "min",
            value = rng[[1]],
            min = rng[[1]],
            max = rng[[2]]
        )
    })

    output$data <- renderTable({
        mtcars |>
            dplyr::filter(.data[[input$var]] > input$min) %>%
            dplyr::arrange(.data[[input$sort]])
    })
}

shinyApp(ui, server)
