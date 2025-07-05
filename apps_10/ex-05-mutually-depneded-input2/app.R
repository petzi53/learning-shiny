ui <- fluidPage(
    column(6,
           tags$h2("Set parameters"),
           numericInput("valueA", "Value1", value = .333, min = 0, max = 1, step = .1),
           numericInput("valueB", "Value2", value = .333, min = 0, max = 1, step = .1),
           numericInput("valueC", "Value3", value = .333, min = 0, max = 1, step = .1)
    ),
    column(6,
           uiOutput("ui")
    )
)

server <- function(input, output, session) {
    output$ui <- renderUI( {
        tagList(
            tags$h2("Display in %"),
            numericInput("obs1", "Label1", value = 100 * (input$valueA / (input$valueA + input$valueB + input$valueC))),
            numericInput("obs2", "Label2", value = 100 * (input$valueB / (input$valueA + input$valueB + input$valueC))),
            numericInput("obs2", "Label2", value = 100 * (input$valueC / (input$valueA + input$valueB + input$valueC)))
        )
    })
}

shinyApp(ui, server)
