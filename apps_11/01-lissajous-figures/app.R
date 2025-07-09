## Lissajous' figures (https://en.wikipedia.org/wiki/Lissajous_curve)
## replicating the motion of a pendulum
## Taken from: "Mastering Shiny", chap.11, section 1: Basic idea
## learning-shiny/apps_11/01-lissajous-figures
## app WITHOUT bookmarking addition


library(shiny)

ui <- fluidPage(
    sidebarLayout(
        sidebarPanel(
            sliderInput("omega", "omega", value = 1, min = -2, max = 2, step = 0.01),
            sliderInput("delta", "delta", value = 1, min = 0, max = 2, step = 0.01),
            sliderInput("damping", "damping", value = 1, min = 0.9, max = 1, step = 0.001),
            numericInput("length", "length", value = 100)
        ),
        mainPanel(
            plotOutput("fig")
        )
    )
)
server <- function(input, output, session) {
    t <- reactive(seq(0, input$length, length.out = input$length * 100))
    x <- reactive(sin(input$omega * t() + input$delta) * input$damping ^ t())
    y <- reactive(sin(t()) * input$damping ^ t())

    output$fig <- renderPlot({
        plot(x(), y(), axes = FALSE, xlab = "", ylab = "", type = "l", lwd = 2)
    }, res = 96)
}

shinyApp(ui, server)
