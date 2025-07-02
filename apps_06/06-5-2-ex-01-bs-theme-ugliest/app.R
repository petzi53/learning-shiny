library(shiny)
library(bslib)

## To work with the used Google fonts you have either to write
## e.g., `base_font = font_google(<font name>)` or to download
## and integrate the fonts into your system

ui <- fluidPage(
    theme = bslib::bs_theme(
        fg = "rgba(37, 66, 192, 0.6)",
        font_scale = NULL,
        bg = "#ffffff",
        base_font = "Manufacturing Consent",
        code_font = "Fira Code",
        heading_font = "Bitcount Grid Double",
        secondary = "#9A3232",
        success = "#B3E7BD",
        spacer = "5rem"
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

## exchange above line with the following line
## to edit the theme in real-time
# bslib::run_with_themer(shinyApp(ui, server))
