library(shiny)

ui <- fluidPage(
    selectInput("dataset", "Choose a dataset", c("pressure", "cars")),
    selectInput("column", "Choose column", character(0)),
    verbatimTextOutput("summary")
)

server <- function(input, output, session) {
    dataset <- reactive(get(input$dataset, "package:datasets"))

    observeEvent(input$dataset, {
        updateSelectInput(inputId = "column", choices = names(dataset()))
    })

    output$summary <- renderPrint({
        summary(dataset()[[input$column]])
    })
}

shinyApp(ui, server)
