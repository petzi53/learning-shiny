library(shiny)
library(bslib)

ui <- page_sidebar(
    theme = bslib::bs_theme(
        preset = "darkly",
        bg = "#0b3d91",
        fg = "white",
        base_font = "Source Sans Pro"
    ),
    sidebar = sidebar()
)

server <- function(input, output, session) {

}

shinyApp(ui, server)
