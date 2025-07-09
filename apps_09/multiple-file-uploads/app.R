library(shiny)

ui <- fluidPage(
    fileInput("upload", NULL, buttonLabel = "Upload...", multiple = TRUE),
    tableOutput("files")
)
server <- function(input, output, session) {
    data <-  reactiveVal()

    observeEvent(input$upload, {
        data(dplyr::bind_rows(data(), input$upload))
    })

    output$files <- renderTable({data()})
}

shinyApp(ui, server)
