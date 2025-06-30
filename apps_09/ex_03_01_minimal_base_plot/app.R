library(shiny)
library(bslib)

ui <- page_sidebar(
    titlePanel("Draw & download a histogram"),
    sidebar = sidebar(
        fileInput("upload", NULL, accept = c(".csv", ".tsv")),
        selectInput("my_column", "Choose variable", NULL),
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

    output$hist <-  renderPlot(my_hist(), res = 96)

    output$my_download <- downloadHandler(
        filename  = reactive({paste0(
            "histogram-",
            basename(tools::file_path_sans_ext(input$upload)),
            "-", input$my_column, "-", Sys.Date(), input$format)}),
        content = function(file) {
            switch(input$format,
                ".png" = png(file),
                ".pdf" = pdf(file),
                ".svg" = svg(file)
            )
            plot(my_hist())
            dev.off()
        }
    )
}

shinyApp(ui, server)


