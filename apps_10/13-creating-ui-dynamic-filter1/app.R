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
            make_ui(iris$Sepal.Length, "Sepal.Length"),
            make_ui(iris$Sepal.Width, "Sepal.Width"),
            make_ui(iris$Species, "Species")
        ),
        mainPanel(
            tableOutput("data")
        )
    )
)

server <- function(input, output, session) {
    selected <- reactive({
        filter_var(iris$Sepal.Length, input$Sepal.Length) &
            filter_var(iris$Sepal.Width, input$Sepal.Width) &
            filter_var(iris$Species, input$Species)
    })

    output$data <- renderTable(head(iris[selected(), ], 12))
}

shinyApp(ui, server)
