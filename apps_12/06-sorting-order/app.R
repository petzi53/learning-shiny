## path: apps_12/06-sorting-order/app.R
## MS book: 12.2.3 Example: dplyr
## my book: @lst-12-example-dplyr
## indirection example with {**dplyr**}: choosing sorting order
################################################################

library(shiny)

ui <- fluidPage(
    selectInput("var", "Sort by", choices = names(mtcars)),
    checkboxInput("desc", "Descending order?"),
    tableOutput("data")
)
server <- function(input, output, session) {
    sorted <- reactive({
        if (input$desc) {
            dplyr::arrange(mtcars, desc(.data[[input$var]]))
        } else {
            dplyr::arrange(mtcars, .data[[input$var]])
        }
    })
    output$data <- renderTable(sorted())
}

shinyApp(ui, server)
