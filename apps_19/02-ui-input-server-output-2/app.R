## path: apps_19/02-ui-input-server-output-2/app.R
## MS book: 19.3.1 "Getting started: UI input + server output"
## modeled from the MS section 19.3 Inputs $ Outputs
## This time the filter is not as a single additional argument
## but generated from user input: EXTENDED VERSION
## with an additional simplification for the module server:
## extracting the filter , which  in my case is reactive
## idea comes from 19.3.2 Case study: selecting a numeric variable
## PROBLEM: At first I designed the filter argument to be static


library(shiny)

filter_choice = c("no filter", "is.data.frame", "is.matrix", "is.list",
                  "is.table", "is.ts", "is.numeric")

# data_choice <- data(package = "datasets")$results[, "Item"]

find_datasets <- function(my_filter) {
  names <- ls("package:datasets")
  if (my_filter != "no filter") {
    data <- lapply(names, get, "package:datasets")
    names <- names[vapply(data, my_filter, logical(1))]
  }
  names
}

datasetUI <- function(id) {
  tagList(
    selectInput(NS(id, "filter"), "Choose a filter", filter_choice),
    selectInput(NS(id, "dataset"), "Choose dataset", names <- ls("package:datasets")),
    tableOutput(NS(id, "data"))
  )
}

datasetServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    observe({
      updateSelectInput(session, "dataset", "Choose dataset", choices = find_datasets(input$filter))
    })
    reactive(get(input$dataset, "package:datasets"))
  })
}


datasetApp <- function() {
  ui <- fluidPage(
    datasetUI("dataset"),
    tableOutput("data")
  )
  server <- function(input, output, session) {
    data <- datasetServer("dataset")
    output$data <- renderTable(head(data()))
  }
  shinyApp(ui, server)
}

datasetApp()
