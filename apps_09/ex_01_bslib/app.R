library(shiny)
library(bslib)
library(ambient)

ui <- page_sidebar(
    titlePanel("Generate Worley Noise"),
    sidebar = sidebar(
        downloadButton("download"),
        numericInput("height", "Dimension-X", value = 10),
        numericInput("width", "Dimension-Y", value = 10),
        selectInput("distance", "Select distance",
                list("Euclidean" = "euclidean",
                     "Manhattan" = "manhattan",
                     "Natural" = "natural"
                    )
                ),

        selectInput("value", "Select noise value",
                list("Distance" = "distance",
                     "Distance2" = "distance2",
                     "Distance2add" = "distance2add",
                     "Distance2sub" = "distance2sub",
                     "Distance2mul" = "distance2mul",
                     "Distance2div" = "distance2div",
                     "Cell" = "cell"
                    )
                ),
        sliderInput("seed", "Seed for replication",
                        min = 1000,
                        max = 1100,
                        value = 1042
                    )
        ),
        plotOutput("plot")
)

server <- function(input, output) {

    grid1 <-  reactive({
        long_grid(seq(1, input$height, length.out = 1000),
                  seq(1, input$width, length.out = 1000)
        )
    })

    grid2 <-  reactive({
        grid1() |>
            dplyr::mutate(noise = gen_worley(
                grid1()$x, grid1()$y,
                value = input$value,
                distance = input$distance,
                seed = input$seed)
            )
    })

    output$plot <- renderPlot({
        plot(grid2(), noise)
    })


    output$download <- downloadHandler(
        filename  = reactive({paste0(
            "worley_x-", input$height,
            "_y-", input$width,
            "_distance-", input$distance,
            "_noise-", input$value,
            "_seed-", input$seed, ".png"
        )
        }),
        content = function(file) {
            png(file)
            plot(grid2(), noise)
            dev.off()
        }
    )


}

shinyApp(ui, server)
