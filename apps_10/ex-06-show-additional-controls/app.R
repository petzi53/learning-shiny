library(shiny)

ui <- fluidPage(
    sidebarLayout(
        sidebarPanel(
            checkboxInput("status", "Advanced", FALSE),
            tabsetPanel(
                id = "switcher",
                type = "hidden",
                tabPanel("standard",
                    numericInput("n1", "Number", value = 1)
                ),
                tabPanel("advanced",
                    numericInput("n2", "Number", value = 1),
                    numericInput("min", "Minimum", value = 0),
                    numericInput("max", "Maximum", value = 100)

                )
            )
        ),
        mainPanel(
        )
    )
)

server <- function(input, output, session) {

    observeEvent(input$status,{

        if (input$status) {
            updateNumericInput(inputId = "n2", value = input$n1)
            updateTabsetPanel(inputId = "switcher", selected = "advanced")
        } else {
            updateNumericInput(inputId = "n1", value = input$n2)
            updateTabsetPanel(inputId = "switcher", selected = "standard")
        }
    })
}

shinyApp(ui, server)
