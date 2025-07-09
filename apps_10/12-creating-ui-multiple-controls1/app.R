library(shiny)

ui <- fluidPage(
    numericInput("n", "Number of colours", value = 5, min = 1),
    uiOutput("col"),
    textOutput("palette")
)

server <- function(input, output, session) {
    col_names <- reactive(paste0("col", seq_len(input$n)))

    output$col <- renderUI({
        purrr::map(col_names(), ~ textInput(.x, NULL))
    })

    output$palette <- renderText({
        purrr::map_chr(col_names(), ~ input[[.x]] %||% "")
    })
}

shinyApp(ui, server)
