library(shiny)

ui <- fluidPage(
    fileInput("upload", "Upload File", accept = ".csv"),
    selectInput("territory", "Territory", choices = NULL),
    selectInput("customername", "Customer", choices = NULL),
    selectInput("ordernumber", "Order number", choices = NULL),
    tableOutput("data")
)

server <- function(input, output, session) {

    sales <- reactiveVal()

    observeEvent(input$upload, {
        df <- vroom::vroom(input$upload$datapath, delim = ",", col_types = list(), na = "")
        sales(df)
        updateSelectInput(inputId = "territory", choices = unique(sales()$TERRITORY))
         })

    territory <- reactive({
        req(input$upload)
        dplyr::filter(sales(), TERRITORY == input$territory)
    })

    observeEvent(territory(), {
        choices <- unique(territory()$CUSTOMERNAME)
        updateSelectInput(inputId = "customername", choices = choices)
    })

    customer <- reactive({
        req(input$customername)
        dplyr::filter(territory(), CUSTOMERNAME == input$customername)
    })
    observeEvent(customer(), {
        choices <- unique(customer()$ORDERNUMBER)
        updateSelectInput(inputId = "ordernumber", choices = choices)
    })

    output$data <- renderTable({
        req(input$ordernumber)
        customer()  |>
            dplyr::filter(ORDERNUMBER == input$ordernumber)  |>
            dplyr::select(QUANTITYORDERED, PRICEEACH, PRODUCTCODE)
    })
}

shinyApp(ui, server)
