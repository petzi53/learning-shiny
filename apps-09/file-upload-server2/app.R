library(shiny)

ui <- fluidPage(
    fileInput("upload", NULL, buttonLabel = "Upload...", multiple = TRUE),
    tableOutput("files")
)

server <- function(input, output, session) {
#    req(input$upload)
    my_files <- reactive({
        rbind(input$upload, my_files())
    })
    output$files <- renderTable(my_files())

}


shinyApp(ui, server)
