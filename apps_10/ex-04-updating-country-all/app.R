library(shiny)
library(gapminder)

gapminder2 <- gapminder |>
    tibble::add_row(continent = "All")

continents2 <- unique(factor(gapminder2$continent))


ui <- fluidPage(
    selectInput("continent", "Continent", choices = continents2),
    selectInput("country", "Country", choices = NULL),
    tableOutput("data")
)

server <- function(input, output, session) {
    countries <- eventReactive( input$continent, {
        if (input$continent == "All") {
            return(unique(na.omit(gapminder2$country)))
        }
        countries <- gapminder2 |>
            dplyr::select(continent, country) |>
            dplyr::filter(continent == input$continent) |>
            dplyr::select(country) |>
            unique()
        updateSelectInput(inputId = "country", choices = countries$country)
        countries
    })

    output$data <- renderTable({
        countries()
    })

}

shinyApp(ui, server)
