library(shiny)
library(bslib)

ui <- page_sidebar(
    titlePanel("One Sample t Test"),
    sidebar = sidebar(
        fileInput("upload", NULL, accept = c(".csv", ".tsv")),
        selectInput("my_var", "Choose variable", NULL),
        numericInput("num", "Hypothesized mean", 0),
        actionButton("go", "T Test", disabled = TRUE)
    ),
    verbatimTextOutput("ttest")
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
            inputId = "my_var",
              choices = names(df)
            )
        updateActionButton(session, "go", disabled = FALSE)
    })


    output$ttest <-  renderPrint({
        req(input$my_var)
        input$go
        value <-  dplyr::select(data(), input$my_var)
        isolate(t.test(value, mu = input$num))
    })

}

shinyApp(ui, server)


