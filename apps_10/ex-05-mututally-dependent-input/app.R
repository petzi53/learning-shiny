library(shiny)
u <- shinyUI(fluidPage(
    titlePanel("Mutually Dependent Input Values"),
    sidebarLayout(
        sidebarPanel(
            numericInput("A", "A",.333),
            numericInput("B", "B",.333),
            numericInput("C", "C",.333)
        ),
        mainPanel(
            verbatimTextOutput("result")
        )
    )
))
s <- shinyServer(function(input, output,session) {

    observeEvent(input$A,{
        newB <- 1 - input$A - input$C
        updateNumericInput(session, "B", value = newB)
        newC <- 1 - input$A - input$B
        updateNumericInput(session, "C", value = newC)
    })
    observeEvent(input$B,{
        newC <- 1 - input$B - input$A
        updateNumericInput(session, "C", value = newC)
        newA <- 1 - input$B - input$C
        updateNumericInput(session, "A", value = newA)
    })
    observeEvent(input$C,{
        newA <- 1 - input$C - input$B
        updateNumericInput(session, "A", value = newA)
        newB <- 1 - input$C - input$C
        updateNumericInput(session, "B", value = newB)
    })


})
shinyApp(u,s)
