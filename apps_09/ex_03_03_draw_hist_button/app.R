library(shiny)
library(bslib)

ui <- page_sidebar(

    titlePanel("Draw & download a histogram"),
    sidebar = sidebar(
        fileInput("upload", NULL, accept = c(".csv", ".tsv")),
        selectInput("my_variable", "Choose variable", NULL),
        actionButton("draw", "Draw Histogram", disabled = TRUE),
        selectInput("format", "Download as",
                    c("PNG" = ".png",
                      "PDF" = ".pdf",
                      "SVG" = ".svg")
                    ),
        downloadButton("download")
    ),
    plotOutput("hist", width = '600px', height = '400px')
)

server <- function(input, output, session) {

    data <- reactive({
        req(input$upload)

        ext <- tools::file_ext(input$upload$name)
        switch(ext,
               csv = vroom::vroom(
                   input$upload$datapath,
                   delim = ",",
                   show_col_types = FALSE),
               tsv = vroom::vroom(
                   input$upload$datapath,
                   delim = "\t",
                   show_col_types = FALSE),
               validate("Invalid file;
                        Please upload a .csv or .tsv file")
        )
    })

    observe({
        req(data())
        df <- data() |>
            dplyr::select(tidyselect::where(is.numeric))
        updateSelectInput(
            inputId = "my_variable",
            choices = names(df)
        )
        updateActionButton(session, "draw", disabled = FALSE)

    })


    output$hist <-  renderPlot({
        input$draw


        ## version base::hist
        ## to get the column you need `[[`: `$` does not work
        # my_hist <- hist(data()[[isolate(req(input$my_variable))]])
        # my_hist


        # version tidy eval tools (dplyr, ggplot and rlang)
        # .data retrieves data-variables for the data frame
        my_hist <-
            data() |>
                ggplot2::ggplot(ggplot2::aes(.data[[isolate(req(input$my_variable))]])) +
                ggplot2::geom_histogram(bins = 30)
        my_hist
    }, res = 96)

    output$download <- downloadHandler(
        filename = function() {
            paste0("histogram", input$format)
        },
        content = function(file) {
            my_hist <- data() |>
                ggplot2::ggplot(ggplot2::aes(.data[[isolate(req(input$my_variable))]])) +
                ggplot2::geom_histogram(bins = 30)
            ggplot2::ggsave(file, plot = my_hist)
            # hist(data()[[input$my_variable]])
        }
    )



}

shinyApp(ui, server)


