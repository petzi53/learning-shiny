library(shiny)

make_ui <- function(x, var) {
    if (is.numeric(x)) {
        rng <- range(x, na.rm = TRUE)
        sliderInput(var, var, min = rng[1], max = rng[2], value = rng)
    } else if (is.factor(x)) {
        levs <- levels(x)
        selectInput(var, var, choices = levs, selected = levs, multiple = TRUE)
    } else {
        # Not supported
        NULL
    }
}

filter_var <- function(x, val) {
    if (is.numeric(x)) {
        !is.na(x) & x >= val[1] & x <= val[2]
    } else if (is.factor(x)) {
        x %in% val
    } else {
        # No control, so don't filter
        TRUE
    }
}

ui <- fluidPage(
    sidebarLayout(
        sidebarPanel(
            purrr::map(names(iris), ~ make_ui(iris[[.x]], .x))
        ),
        mainPanel(
            tableOutput("data")
        )
    )
)
server <- function(input, output, session) {
    selected <- reactive({
        each_var <- purrr::map(names(iris), ~ filter_var(iris[[.x]], input[[.x]]))
        purrr::reduce(each_var, ~ .x & .y)
    })

    output$data <- renderTable(head(iris[selected(), ], 12))
}

shinyApp(ui, server)
