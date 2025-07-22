library(shiny)

randomUI <- function(id) {
    tagList(
        textOutput(NS(id, "val0")),
        textOutput(NS(id, "val1")),
        textOutput(NS(id, "val2")),
        textOutput(NS(id, "val3")),
        actionButton(NS(id, "go0"), "Go-0!"),
        actionButton(NS(id, "go1"), "Go-1!"),
        actionButton(NS(id, "go2"), "Go-2!"),
        actionButton(NS(id, "go3"), "Go-3!")
    )
}
randomServer <- function(id) {
    moduleServer(id, function(input, output, session) {
        rand0 <- eventReactive(input$go0, sample(1000, 1))
        rand1 <- eventReactive(input$go1, sample(100, 1))
        rand2 <- eventReactive(input$go2, sample(1000, 1))
        rand3 <- eventReactive(input$go3, sample(100, 1))
        output$val0 <- renderText(rand0())
        output$val1 <- renderText(rand1())
        output$val2 <- renderText(rand2())
        output$val3 <- renderText(rand3())
    })
}



randomApp <- function() {
    ui <- fluidPage(
        randomUI("num")
    )
    server <- function(input, output, session) {
        randomServer("num")
    }
    shinyApp(ui, server)
}


randomApp()

