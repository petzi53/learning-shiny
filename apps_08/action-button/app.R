library(shiny)

ui <- fluidPage(
    titlePanel("actionButton example"),
    fluidRow(
        column(4, wellPanel(
            sliderInput("n", "N:", min = 10, max = 1000, value = 200,
                        step = 10),
            actionButton("goButton", "Go!"),
            br(),
            p("The plot won't update until the button is clicked.",
              " Without the use of ", code("isolate()"),
              " in server.R, the plot would update whenever the slider",
              " changes.")
        )),
        column(8,
               plotOutput("plot1")
        )
    )
)

server <- function(input, output, session) {
    output$plot1 <- renderPlot({
        # Simply accessing input$goButton here makes this reactive
        # object take a dependency on it. That means when
        # input$goButton changes, this code will re-execute.
        input$goButton

        # Use isolate() to avoid dependency on input$n
        isolate({
            hist(rnorm(input$n))
        })
    })
}

shinyApp(ui, server)



