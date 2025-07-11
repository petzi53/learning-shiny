## path: apps_12/08-tidy-selection/2app.R
## MS book: 12.3.2 tidy-selection & data-masking
## my book: lst-12-tidy-selection2
## tidy-selection with two arguments using dplyr::across()

library(shiny)

ui <- fluidPage(
    selectInput("vars_g", "Group by", names(mtcars), multiple = TRUE),
    selectInput("vars_s", "Summarise", names(mtcars), multiple = TRUE),
    tableOutput("data")
)

server <- function(input, output, session) {
    output$data <- renderTable({
        mtcars |>
            dplyr::group_by(
                dplyr::across(tidyselect::all_of(input$vars_g))) |>
            dplyr::summarise(
                dplyr::across(tidyselect::all_of(input$vars_s), mean),
                n = dplyr::n())
    })
}

shinyApp(ui, server)
