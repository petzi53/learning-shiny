library(shiny)
library(bslib)

ui <- page_sidebar(
    titlePanel("Draw & download a histogram"),
    sidebar = sidebar(
        fileInput("upload", NULL, accept = c(".csv", ".tsv")),
        selectInput("my_column", "Choose variable", NULL),
        radioButtons("my_plot", label = NULL, choices =
                      c("ggplot2" = "ggplot2",
                     "Base" = "base"),
                     inline = TRUE),
        selectInput("format", "Download as",
                    c("PNG" = ".png",
                      "PDF" = ".pdf",
                      "SVG" = ".svg")
                    ),
        downloadButton("my_download", "Download")
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
        df <- data() |> dplyr::select(tidyselect::where(is.numeric))
        updateSelectInput(inputId = "my_column", choices = names(df))
    })

    my_hist <- reactive({
        req(input$my_column)
        hist(data()[[input$my_column]])
        }
    )

    my_ggplot <-  reactive({
        req(input$my_column)
        data() |>
            ggplot2::ggplot(ggplot2::aes(.data[[input$my_column]])) +
            ggplot2::geom_histogram(bins = 30)
    })

    output$hist <-  renderPlot({
        hist_plot  <- switch(input$my_plot,
                          ggplot2 = my_ggplot(),
                          base = plot(my_hist())
                          )
       hist_plot
    }, res = 96)

    output$my_download <- downloadHandler(
        filename  = reactive({paste0(
            "histogram-",
            basename(tools::file_path_sans_ext(input$upload)),
            "-", input$my_column, "-", Sys.Date(), input$format)}),
        content = function(file) {
            switch(input$my_plot,
                       ggplot2 = {ggplot2::ggsave(file, plot = hist_plot())},
                       base =  {switch(input$format,
                                      ".png" = png(file),
                                      ".pdf" = pdf(file),
                                      ".svg" = svg(file)
                                    )
                                hist_plot()
                                dev.off()
                                }
            )
        }
    )
}

shinyApp(ui, server)


