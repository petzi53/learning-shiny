library(shiny)

ui <- fluidPage(
    tabsetPanel(
        id = "wizard",
        type = "hidden",
        tabPanel("page_1",
                 "Welcome!",
                 actionButton("page_12", "next")
        ),
        tabPanel("page_2",
                 "Only one page to go",
                 actionButton("page_21", "prev"),
                 actionButton("page_23", "next")
        ),
        tabPanel("page_3",
                 "You're done!",
                 actionButton("page_32", "prev")
        )
    )
)

server <- function(input, output, session) {
    switch_page <- function(i) {
        updateTabsetPanel(inputId = "wizard", selected = paste0("page_", i))
    }

    observeEvent(input$page_12, switch_page(2))
    observeEvent(input$page_21, switch_page(1))
    observeEvent(input$page_23, switch_page(3))
    observeEvent(input$page_32, switch_page(2))
}

shinyApp(ui, server)
