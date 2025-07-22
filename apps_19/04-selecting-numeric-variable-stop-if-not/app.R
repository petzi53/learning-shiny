library(shiny)

## helper function
find_vars <- function(data, filter) {
    stopifnot(is.data.frame(data))
    stopifnot(is.function(filter))
    names(data)[vapply(data, filter, logical(1))]
}

## ui
datasetInput <- function(id, filter = NULL) {
    names <- ls("package:datasets")
    if (!is.null(filter)) {
        data <- lapply(names, get, "package:datasets")
        names <- names[vapply(data, filter, logical(1))]
    }

    selectInput(NS(id, "dataset"), "Pick a dataset", choices = names)
}

selectVarInput <- function(id) {
    selectInput(NS(id, "var"), "Variable", choices = NULL)
}

## server
datasetServer <- function(id) {
    moduleServer(id, function(input, output, session) {
        reactive(get(input$dataset, "package:datasets"))
    })
}


selectVarServer <- function(id, data, filter = is.numeric) {
    stopifnot(is.reactive(data))
    stopifnot(!is.reactive(filter))

    moduleServer(id, function(input, output, session) {
        observeEvent(data(), {
            updateSelectInput(
                session,
                "var",
                choices = find_vars(data(), filter))
        })

        reactive(data()[[input$var]])
    })
}

## app
selectVarApp <- function(filter = is.numeric) {
    ui <- fluidPage(
        datasetInput("data", is.data.frame),
        selectVarInput("var"),
        verbatimTextOutput("out")
    )
    server <- function(input, output, session) {
        data <- datasetServer("data")
        var <- selectVarServer("var", data, filter = filter)
        output$out <- renderPrint(var())
    }

    shinyApp(ui, server)
}

## invoke app
selectVarApp()
