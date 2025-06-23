library(shiny)

ui <- fluidPage(
    waiter::use_waitress(),
    numericInput("steps", "How many steps?", 10),
    radioButtons(
        inputId = "area",
        label = "Area for progress bar" ,
        choices = list(
            "Screen" = 1,
            "Input area" = "#steps"
        )
    ),
    radioButtons(
        inputId = "type",
        label = "Type of progress bar",
        choices = list(
            "Line at the top" = "line",
            "Black " = "overlay",
            "Black with percent" = "overlay-percent",
            "Translucent" = "overlay-opacity"
    )
  ),
  actionButton("go", "go"),
  textOutput("result")
)

server <- function(input, output, session) {

  data <- eventReactive(input$go, {
   waitress <- waiter::Waitress$new(
            if (input$area == 1) {
                selector = NULL
            } else {
                selector = input$area
            },
            theme = input$type,
            max = input$steps
        )
        on.exit(waitress$close())

        for (i in seq_len(input$steps)) {
            Sys.sleep(0.5)
            waitress$inc(1)
        }

        runif(1)
        })

    output$result <- renderText(
        paste("Random number computed:", round(data(), 2))
    )
    }

shinyApp(ui = ui, server = server)
