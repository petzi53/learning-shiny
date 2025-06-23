library(shiny)
library(lubridate)

ui <- fluidPage(
    sliderInput(
        "deliver",
        "When should we deliver?",
        timeFormat = "%F",
        min = as_date("2020-09-16"),
        max = as_date("2020-09-23"),
        value = as_date("2020-09-17")
    )
)

server <- function(input, output, session) {

}

shinyApp(ui, server)
