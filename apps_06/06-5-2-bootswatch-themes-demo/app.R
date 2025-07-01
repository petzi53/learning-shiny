library(shiny)
library(bslib)

ui <- page_sidebar(
    theme = bslib::bs_theme(
        fg = "rgba(37, 66, 192, 0.6)",
        font_scale = NULL,
        bg = "#ffffff"
    ),
    sidebar = sidebar()
)

server <- function(input, output, session) {

}

shinyApp(ui, server)
