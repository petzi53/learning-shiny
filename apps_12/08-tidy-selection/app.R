## path: apps_12/08-tidy-selection/app.R
## MS book: 12.3.2 tidy-selection & data-masking
## my book: lst-12-tidy-selection
## tidy-selection with one argument using dplyr::across()


library(shiny)

ui <- fluidPage(
    selectInput("vars", "Variables", names(mtcars), multiple = TRUE),
    tableOutput("count")
)

server <- function(input, output, session) {
    output$count <- renderTable({
        req(input$vars)

        mtcars |>
            dplyr::group_by(dplyr::across(tidyselect::all_of(input$vars))) |>
            dplyr::summarise(n = dplyr::n(), .groups = "drop")
    })
}

shinyApp(ui, server)
