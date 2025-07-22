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

selectDataVarUI <- function(id) {
    tagList(
        datasetInput(NS(id, "data"), filter = is.data.frame),
        selectVarInput(NS(id, "var"))
    )
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

selectDataVarServer <- function(id, filter = is.numeric) {
    moduleServer(id, function(input, output, session) {
        data <- datasetServer("data")
        var <- selectVarServer("var", data, filter = filter)
        var
    })
}

## app
selectDataVarApp <- function(filter = is.numeric) {
    ui <- fluidPage(
        sidebarLayout(
            sidebarPanel(selectDataVarUI("var")),
            mainPanel(verbatimTextOutput("out"))
        )
    )
    server <- function(input, output, session) {
        var <- selectDataVarServer("var", filter)
        output$out <- renderPrint(var(), width = 40)
    }
    shinyApp(ui, server)
}

## invoke app
selectDataVarApp()
