library(shiny)
library(gapminder)

continents <- unique(gapminder$continent)

ui <- fluidPage(
    selectInput("continent", "Continent", choices = continents),
    selectInput("country", "Country", choices = NULL),
    tableOutput("data")
)

server <- function(input, output, session) {
    countries <- eventReactive( input$continent, {
        countries <- gapminder |>
            dplyr::select(continent, country) |>
            dplyr::filter(continent == input$continent) |>
            unique()
        updateSelectInput(inputId = "country", choices = countries$country)
        countries
    })

    output$data <- renderTable({
        countries()
    })

}

shinyApp(ui, server)
