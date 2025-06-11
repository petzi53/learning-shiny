library(shiny)
library(bslib)
ui <- page_navbar(
    title = "Cool app",
    theme = bs_theme(
        # preset = "flatly",
        primary = "#95a5a6",
        success = "#3F2A56"
    ),
    sidebar = sidebar()
)
server <- function(input, output) {}
shinyApp(ui, server)
