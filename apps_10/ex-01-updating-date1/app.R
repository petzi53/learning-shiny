library(shiny)

ui <- fluidPage(
    numericInput("year", "year", value = 2020),
    dateInput("date", "date")
)

## user changes year (input$year)
## update input$date
server <- function(input, output, session) {
    observe({
        date <- as.Date(paste0(
            input$year, "-",
            format(Sys.Date(), "%m"), "-",
            format(Sys.Date(), "%d")
        ))
        updateDateInput(session,
            inputId = "date",
            value = date,
            min = as.Date(paste0(
                input$year, "-", "01-01"
            )),
            max = as.Date(paste0(
                input$year, "-", "12-31"
            ))
        )
        })
}

shinyApp(ui, server)
