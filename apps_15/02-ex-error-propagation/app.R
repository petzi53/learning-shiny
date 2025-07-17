library(shiny)

reactlog::reactlog_enable()

ui <- fluidPage(
    checkboxInput("error", "error?"),
    textOutput("result")
)
server <- function(input, output, session) {
    a <- reactive({
        if (req(input$error, cancelOutput = TRUE)) {
            stop("Error")
        } else {
            1
        }
    })
    b <- reactive(a() + 1)
    c <- reactive(b() + 1)
    output$result <- renderText(c())
}

shinyApp(ui, server)
