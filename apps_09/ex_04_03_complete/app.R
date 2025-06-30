library(shiny)
library(bslib)
library(base64enc)
library(brickr)
library(waiter)


waiting_screen <- tagList(
    spin_flower(),
    h4("Emulating picture with Lego bricks...")
)

ui <- page_sidebar(
    useWaiter(),
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
    # create a waiter
    w <- Waiter$new()

    base64 <- reactive({
        req(input$upload)
        updateActionButton(
            session, "process",
            disabled = FALSE)
        dataURI(file = input$upload$datapath, mime = "image/png")
    })

    output$plot <- renderPlot({
        req(input$process > 0)
        # w$show()
        waiter_show(html = waiting_screen, color = "black")
        my_mosaic <-

                png::readPNG(input$upload$datapath) |>
                image_to_mosaic(img_size =
                        c(isolate(input$width), isolate(input$height)),
                        color_palette = isolate(input$pal)) |>
                build_mosaic()
        # w$hide()
        waiter_hide()
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


