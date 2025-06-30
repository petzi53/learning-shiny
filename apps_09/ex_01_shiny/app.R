library(shiny)
library(ambient)

# shinylive Workaround Start ######
downloadButton <- function(...) {
    tag <- shiny::downloadButton(...)
    tag$attribs$download <- NULL
    tag
}
### End of workaround ####

ui <- fluidPage(
    titlePanel("Generate Worley Noise"),
    sidebarLayout(
        sidebarPanel(width = 4,
             fluidRow(
                 column(12, offset = 6,
                        downloadButton("download")
                 )
             ),
            fluidRow(
                column(12,
                    numericInput("height", "Dimension-X",
                                value = 10),
                   )
            ),
            fluidRow(
                column(12,
                   numericInput("width", "Dimension-Y",
                                value = 10),
                )
            ),
            fluidRow(
                column(12,
                    selectInput("distance", "Select distance",
                                list("Euclidean" = "euclidean",
                                     "Manhattan" = "manhattan",
                                     "Natural" = "natural"
                                     )
                                ),
                       )
            ),
            fluidRow(
                column(12,
            selectInput("value", "Select noise value",
                        list("Distance" = "distance",
                             "Distance2" = "distance2",
                             "Distance2add" = "distance2add",
                             "Distance2sub" = "distance2sub",
                             "Distance2mul" = "distance2mul",
                             "Distance2div" = "distance2div",
                             "Cell" = "cell"
                            )
                       )
                )
            ),
            fluidRow(
                column(12,
            sliderInput("seed", "Seed for replication",
                        min = 1000,
                        max = 1100,
                        value = 1042
                        )
                    )
            )
        ),
        mainPanel(width = 8,
          plotOutput("plot")
        )
    )
)

server <- function(input, output) {

    grid1 <-  reactive({
        ambient::long_grid(seq(1, input$height, length.out = 1000),
                  seq(1, input$width, length.out = 1000)
                  )
    })

    grid2 <-  reactive({
        grid1() |>
            dplyr::mutate(noise = ambient::gen_worley(
                grid1()$x, grid1()$y,
                value = input$value,
                distance = input$distance,
                seed = input$seed)
            )
    })

    output$plot <- renderPlot({
        req(grid2())
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
