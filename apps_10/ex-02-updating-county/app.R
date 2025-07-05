library(openintro, warn.conflicts = FALSE)
library(shiny)

states <- unique(county$state)

ui <- fluidPage(
    selectInput("state", "State", choices = states),
    selectInput("county", "County", choices = NULL)
)

server <- function(input, output, session) {
    observeEvent( input$state, {
        counties <- county |>
            dplyr::select(name, state) |>
            dplyr::filter(state == input$state)
        updateSelectInput(inputId = "county", choices = counties)
    })

}

shinyApp(ui, server)
