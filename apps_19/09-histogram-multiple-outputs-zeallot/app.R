library(shiny)
library(zeallot)

## helper function
find_vars <- function(data, filter) {
    stopifnot(is.data.frame(data))
    stopifnot(is.function(filter))
    names(data)[vapply(data, filter, logical(1))]
}


## ui
histogramOutputBins <- function(id) {
    numericInput(NS(id, "bins"), "bins", 10, min = 1, step = 1)
}
histogramOutputPlot <- function(id) {
    plotOutput(NS(id, "hist"))
}


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

        list(
            name = reactive(input$var),
            value = reactive(data()[[input$var]])
        )
    })
}



histogramServer <- function(id, x, title = reactive("Histogram")) {
    stopifnot(is.reactive(x))
    stopifnot(is.reactive(title))

    moduleServer(id, function(input, output, session) {
        output$hist <- renderPlot({
            req(is.numeric(x()))
            main <- paste0(title(), " [", input$bins, "]")
            hist(x(), breaks = input$bins, main = main)
        }, res = 96)
    })
}

histogramApp <- function() {
    ui <- fluidPage(
        sidebarLayout(
            sidebarPanel(
                datasetInput("data", is.data.frame),
                selectVarInput("var"),
                histogramOutputBins("hist"),
            ),
            mainPanel(
                histogramOutputPlot("hist")
            )
        )
    )

    server <- function(input, output, session) {
        data <- datasetServer("data")
        c(value, name) %<-% selectVarServer("var", data) # zeallot
        ## book has wrong order: "value, name "instead of "name, value"
        histogramServer("hist", name, value)             # zeallot
    }

    shinyApp(ui, server)
}

histogramApp()
