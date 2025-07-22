library(shiny)

## helper function
find_vars <- function(data, filter) {
    stopifnot(is.data.frame(data))
    stopifnot(is.function(filter))
    names(data)[vapply(data, filter, logical(1))]
}


## ui
histogram2Output <- function(id) {
    tagList(
        numericInput(NS(id, "bins"), "bins", 10, min = 1, step = 1),
        plotOutput(NS(id, "hist"))
    )
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

        reactive(data()[[input$var]])
    })
}

histogram2Server <- function(id, x, title = reactive("Histogram")) {
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

histogram2App <- function() {
    ui <- fluidPage(
        sidebarLayout(
            sidebarPanel(
                datasetInput("data", is.data.frame),
                selectVarInput("var"),
            ),
            mainPanel(
                histogram2Output("hist")
            )
        )
    )

    server <- function(input, output, session) {
        data <- datasetServer("data")
        x <- selectVarServer("var", data)
        histogram2Server("hist", x)
    }
    shinyApp(ui, server)
}

histogram2App()
