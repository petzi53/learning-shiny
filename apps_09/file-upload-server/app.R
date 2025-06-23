library(shiny)

ui <- fluidPage(
    fileInput("upload", NULL, buttonLabel = "Upload...", multiple = TRUE),
    tableOutput("files")
)
server <- function(input, output, session) {
    output$files <- renderTable(input$upload)
}

shinyApp(ui, server)
