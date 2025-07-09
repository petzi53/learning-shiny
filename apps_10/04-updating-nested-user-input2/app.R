library(shiny)

ui <- fluidPage(
    titlePanel("Sales Dashboard"),
    sidebarLayout(
        sidebarPanel(
            fileInput("upload", "Upload File", accept = ".csv"),
            selectInput("territory", "Territory", choices = NULL),
            selectInput("customername", "Customer", choices = NULL),
            selectInput("ordernumber", "Order number", choices = NULL, size = 5, selectize = FALSE),
        ),
        mainPanel(
            uiOutput("customer"),
            tableOutput("data")
        )
    )
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
    customer <- reactive({
        req(input$customername)
        dplyr::filter(territory(), CUSTOMERNAME == input$customername)
    })

    output$customer <- renderUI({
        row <- customer()[1, ]
        tags$div(
            class = "well",
            tags$p(tags$strong("Name: "), row$CUSTOMERNAME),
            tags$p(tags$strong("Phone: "), row$PHONE),
            tags$p(tags$strong("Contact: "), row$CONTACTFIRSTNAME, " ", row$CONTACTLASTNAME)
        )
    })

    order <- reactive({
        req(input$ordernumber)
        customer() |>
            dplyr::filter(ORDERNUMBER == input$ordernumber)  |>
            dplyr::arrange(ORDERLINENUMBER)  |>
            dplyr::select(PRODUCTLINE, QUANTITYORDERED, PRICEEACH, SALES, STATUS)
    })

    output$data <- renderTable(order())

    observeEvent(territory(), {
        updateSelectInput(session, "customername", choices = unique(territory()$CUSTOMERNAME), selected = character())
    })
    observeEvent(customer(), {
        updateSelectInput(session, "ordernumber", choices = unique(customer()$ORDERNUMBER))
    })

}
shinyApp(ui, server)
