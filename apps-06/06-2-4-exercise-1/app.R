
library(shiny)

ui <- fluidPage(
    titlePanel("Page division 1:2"),
    fluidRow(
        column(
            width = 4,
            "place for the controls: 4 columns"
        ),
        column(
            width = 8,
            "place for the output: 8 columns"
        )
    )
)

    server <- function(input, output, session) {

    }

    shinyApp(ui, server)
