library(shiny)

randomUI <- function(id) {
    tagList(
        textOutput(NS(id, "val")),
        actionButton(NS(id, "go"), "Go!")
    )
}
randomServer <- function(id) {
    moduleServer(id, function(input, output, session) {
        rand <- eventReactive(input$go, sample(100, 1))
        output$val <- renderText(rand())
    })
}

randomApp <- function() {
    ui <- fluidPage(
        randomUI("num1")
    )
    server <- function(input, output, session) {
        randomServer("num1")
    }
    shinyApp(ui, server)
}


randomApp()
