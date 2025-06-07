library(shiny)

ui <- fluidPage(
    sliderInput("slider",
                "Select Range:",
                min   = min(datetime),
                max   = max(datetime),
                value = c(min, max)
    ),
    verbatimTextOutput("breaks")
)


server <- function(input, output, session) {

}

shinyApp(ui, server)
