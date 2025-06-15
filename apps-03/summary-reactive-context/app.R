library(shiny)

ui <- fluidPage(
    print("front end interface"),
    textOutput("my_msg")
)

server <- function(input, output, session) {
    output$my_msg <-  renderText(
        "back and logic"
    )
}

shinyApp(ui, server)
