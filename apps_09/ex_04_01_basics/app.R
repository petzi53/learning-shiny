library(shiny)
library(bslib)
library(base64enc)
library(brickr)

ui <- page_sidebar(
    titlePanel("Emulate LEGO Bricks"),
    sidebar = sidebar(
        fileInput("upload", "Load PNG image", accept = c(".png", ".PNG"))
        ),
    uiOutput("image"),
    plotOutput("plot", width = "600px", height = "400px")
    )

server <- function(input, output, session) {
    base64 <- reactive({
        req(input$upload)
        dataURI(file = input$upload$datapath, mime = "image/png")
    })

    output$plot <- renderPlot({
        req(base64())
        mosaic1 <- png::readPNG(input$upload$datapath) |>
            image_to_mosaic(img_size = c(72, 48), color_palette = "generic") |>
            build_mosaic()
        mosaic1
    }
    )

    output$image <- renderUI({
        req(base64())
        tags$div(
            tags$img(src = base64(), width = "100%"),
            style = "width: 400px;"
        )


    })
}


shinyApp(ui, server)


