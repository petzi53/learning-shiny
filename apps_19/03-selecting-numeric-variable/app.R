## path: apps_19/03-selecting-numeric-variable/app.R
## MS book: 19.3.2 "Case study: selecting a numeric variable"
## This time the filter is not as a single additional argument
## as in apps_19/02-ui-input-server-output/app.R
## but provided as a static variable inside the code
## the app can now be invoked without passing an argument


library(shiny)

## helper function
find_vars <- function(data, filter) {
    names(data)[vapply(data, filter, logical(1))]
}

## ui ##########################################################
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

## server ######################################################
datasetServer <- function(id) {
    moduleServer(id, function(input, output, session) {
        reactive(get(input$dataset, "package:datasets"))
    })
}


selectVarServer <- function(id, data, filter = is.numeric) {
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
