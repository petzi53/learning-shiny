library(shiny)
library(bslib)

ui <- fluidPage(
    theme = bslib::bs_theme(
        bg = "#0b3d91",
        fg = "white",
        base_font = "Source Sans Pro"
        ),
    sidebarLayout(
        sidebarPanel(
            textInput("txt", "Text input:", "text here"),
            sliderInput("slider", "Slider input:", 1, 100, 30)
        ),
        mainPanel(
            h1(paste0("Theme: darkly")),
            h2("Header 2"),
            p("Some text")
        )
    )
)


server <- function(input, output, session) {

}

shinyApp(ui, server)
