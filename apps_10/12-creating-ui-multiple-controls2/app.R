library(shiny)

ui <- fluidPage(
    sidebarLayout(
        sidebarPanel(
            numericInput("n", "Number of colours", value = 5, min = 1),
            uiOutput("col"),
        ),
        mainPanel(
            plotOutput("plot")
        )
    )
)

server <- function(input, output, session) {
    col_names <- reactive(paste0("col", seq_len(input$n)))

    output$col <- renderUI({
        purrr::map(col_names(), ~ textInput(.x, NULL, value = isolate(input[[.x]])))
    })

    output$plot <- renderPlot({
        cols <- purrr::map_chr(col_names(), ~ input[[.x]] %||% "")
        # convert empty inputs to transparent
        cols[cols == ""] <- NA

        barplot(
            rep(1, length(cols)),
            col = cols,
            space = 0,
            axes = FALSE
        )
    }, res = 96)
}

shinyApp(ui, server)
