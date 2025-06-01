library(shiny)

ui <- fluidPage(
    reactable::reactableOutput("table")
)

server <- function(input, output, session) {
    output$table <- reactable::renderReactable({
        reactable::reactable(mtcars)
    })
}

shinyApp(ui, server)
