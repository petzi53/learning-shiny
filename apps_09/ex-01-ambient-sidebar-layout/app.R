library(shiny)
library(bslib)
library(ambient)

ui <- fluidPage(
    titlePanel("Generate Worley Noise"),
    sidebarLayout(
        sidebarPanel(
            numericInput("height", "Height (1-20)",
                         min = 1, max = 20, value = 10),
            numericInput("width", "Width (1-20)",
                         min = 1, max = 20, value = 10)
        ),
        mainPanel(
          plotOutput("plot")
        )
    )
)

server <- function(input, output) {
    grid1 <-  reactive({
        long_grid(seq(1, input$height, length.out = 1000),
                  seq(1, input$width, length.out = 1000)
                  )
    })

    grid2 <-  reactive({
        grid1() |>
            dplyr::mutate(noise = gen_worley(grid1()$x, grid1()$y, value = 'distance'))
    })

    output$plot <- renderPlot({
        plot(grid2(), noise)
    })

}

shinyApp(ui, server)
