library(shiny)
library(data.table)

ui <- fluidPage(
    fileInput("upload", NULL, buttonLabel = "Upload...", multiple = TRUE),
    textOutput("files")
)

server <- function(input, output) {
    my_files <- reactive({
        rbindlist(lapply(input$upload$datapath, fread),
                  use.names = TRUE, fill = TRUE)
    })
    output$files <- renderText(nrow(my_files()))
}

shinyApp(ui, server)

# library(shiny)
# library(data.table)
#
# ui <- fluidPage(
#     titlePanel("Multiple file uploads"),
#     sidebarLayout(
#         sidebarPanel(
#             fileInput("csvs",
#                       label = "Upload CSVs here",
#                       multiple = TRUE)
#         ),
#         mainPanel(
#             textOutput("count")
#         )
#     )
# )
#
# server <- function(input, output) {
#     mycsvs <- reactive({
#         rbindlist(lapply(input$csvs$datapath, fread),
#                   use.names = TRUE, fill = TRUE)
#     })
#     output$count <- renderText(nrow(mycsvs()))
# }
#
# shinyApp(ui = ui, server = server)
#
#

