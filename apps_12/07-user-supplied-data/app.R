## path: apps_12/07-user-supplied-data/app.R
## MS book: 12.2.4 User supplied data
## my book: @lst-12-user-supplied-data
## user uploads a tsv file, then select a variable and filter by it


library(shiny)

ui <- fluidPage(
    fileInput("data", "dataset", accept = ".tsv"),
    selectInput("var", "var", character()),
    numericInput("min", "min", 1, min = 0, step = 1),
    tableOutput("output")
)
server <- function(input, output, session) {
    data <- reactive({
        req(input$data)
        vroom::vroom(input$data$datapath)
    })
    observeEvent(data(), {
        updateSelectInput(session, "var", choices = names(data()))
    })
    observeEvent(input$var, {
        val <- data()[[input$var]]
        updateNumericInput(session, "min", value = min(val))
    })

    output$output <- renderTable({
        req(input$var)

        data()  |>
            dplyr::filter(.data[[input$var]] > input$min)  |>
            dplyr::arrange(.data[[input$var]])  |>
            head(10)
    })
}

shinyApp(ui, server)
