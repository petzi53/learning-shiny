## path: apps_19/02-ui-input-server-output-0/app.R
## MS book: 19.3.1 "Getting started: UI input + server output"
## Shiny app with two inputs and one output
## modeled from the MS section 19.3 Inputs $ Outputs
## EXTENDED VERSION: filter as user input
## the "trick" was to create an observer with updateSelectInput()

library(shiny)

filter_choice = c("no filter", "is.data.frame", "is.matrix", "is.list",
                  "is.table", "is.ts", "is.numeric")

# data_choice <- data(package = "datasets")$results[, "Item"]

ui <- fluidPage(
  selectInput(
      inputId = "filter",
      label = "Choose a filter",
      choices = filter_choice
  ),
  selectInput(
      inputId = "dataset",
      label = "Choose dataset",
      choices = names <- ls("package:datasets")
  ),
  tableOutput("data")
)

server <- function(input, output, session) {

    observe({
      names <- ls("package:datasets")
      if (input$filter != "no filter") {
        data <- lapply(names, get, "package:datasets")
        names <- names[vapply(data, input$filter, logical(1))]
      }
      updateSelectInput(session, "dataset", "Choose dataset", choices = names)
    })

    my_data <-  reactive(get(input$dataset, "package:datasets"))
    output$data <- renderTable(head(my_data()))

}

shinyApp(ui, server)
