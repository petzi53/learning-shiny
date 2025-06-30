library(shiny)

# Uploading and parsing the file

ui_upload <- sidebarLayout(
    sidebarPanel(
        fileInput("file", "Data", buttonLabel = "Upload..."),
        textInput("delim", "Delimiter (leave blank to guess)", ""),
        numericInput("skip", "Rows to skip", 0, min = 0),
        numericInput("rows", "Rows to preview", 10, min = 1)
    ),
    mainPanel(
        h3("Raw data"),
        tableOutput("preview1")
    )
)

# Cleaning the file
ui_clean <- sidebarLayout(
    sidebarPanel(
        checkboxInput("snake", "Rename columns to snake case?"),
        checkboxInput("constant", "Remove constant columns?"),
        checkboxInput("empty", "Remove empty cols?")
    ),
    mainPanel(
        h3("Cleaner data"),
        tableOutput("preview2")
    )
)

# Downloading the file.

ui_download <- fluidRow(
    column(width = 12, downloadButton("download", class = "btn-block"))
)

# which get assembled into a single fluidPage():

ui <- fluidPage(
    ui_upload,
    ui_clean,
    ui_download
)

server <- function(input, output, session) {
    # Upload ---------------------------------------------------------
    raw <- reactive({
        req(input$file)
        delim <- if (input$delim == "") NULL else input$delim
        vroom::vroom(input$file$datapath, delim = delim, skip = input$skip)
    })
    output$preview1 <- renderTable(head(raw(), input$rows))

    # Clean step ---------------------------------------------------------
    # Breaking one large reactive up into multiple pieces
    cleaned_names <- reactive({
        out <- raw()

        if (input$snake) {
            names(out) <- janitor::make_clean_names(names(out))
        }
        out
    })

    removed_empty <- reactive({
        out <- cleaned_names()

        if (input$empty) {
            out <- janitor::remove_empty(out, "cols")
        }
        out
    })

    removed_constant <- reactive({
        out <- removed_empty()

        if (input$constant) {
            out <- janitor::remove_constant(out)
        }
        out
    })

    output$preview2 <- renderTable(head(removed_constant(), input$rows))

    # Download -------------------------------------------------------
    output$download <- downloadHandler(
        filename = function() {
            paste0(tools::file_path_sans_ext(input$file$name), ".tsv")
        },
        content = function(file) {
            vroom::vroom_write(removed_constant(), file)
        }
    )
}

shinyApp(ui, server)
