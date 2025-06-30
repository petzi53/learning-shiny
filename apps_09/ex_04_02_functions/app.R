library(shiny)
library(bslib)
library(base64enc)
library(brickr)

ui <- page_sidebar(
    titlePanel("Emulate LEGO Bricks"),
    sidebar = sidebar(
        fileInput("upload", "Load PNG image", accept = c(".png", ".PNG")),
        numericInput("width", "Width", 36),
        numericInput("height", "Height", 36),
        selectInput("pal", "Color Palette:",
                    c("Generic" = "generic",
                      "Universal" = "universal")),
        actionButton("process", "Process",
                     icon = icon("cog", lib = "glyphicon"),
                     disabled = TRUE)
        ),
    uiOutput("image"),
    plotOutput("plot", width = "600px", height = "400px")
    )

server <- function(input, output, session) {
    base64 <- reactive({
        req(input$upload)
        updateActionButton(
            session, "process",
            disabled = FALSE)
        dataURI(file = input$upload$datapath, mime = "image/png")
    })

    output$plot <- renderPlot({
        req(input$process > 0)
        my_mosaic <-

                png::readPNG(input$upload$datapath) |>
                image_to_mosaic(img_size =
                        c(isolate(input$width), isolate(input$height)),
                        color_palette = isolate(input$pal)) |>
                build_mosaic()
        my_mosaic
    })

    output$image <- renderUI({
        input$upload
        tags$div(
            tags$img(src = base64(), width = "100%"),
            style = "width: 400px;"
        )
    })

}


shinyApp(ui, server)


