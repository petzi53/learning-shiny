library(shiny)

url = "https://raw.githubusercontent.com/petzi53/learning-shiny/refs/heads/master/data/sales.csv"
sales <- vroom::vroom(url, col_types = list(), na = "")

ui <- fluidPage(
    selectInput("territory", "Territory", choices = unique(sales$TERRITORY)),
    selectInput("customername", "Customer", choices = NULL),
    selectInput("ordernumber", "Order number", choices = NULL),
    tableOutput("data")
)

server <- function(input, output, session) {
    territory <- reactive({
        dplyr::filter(sales, TERRITORY == input$territory)
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
