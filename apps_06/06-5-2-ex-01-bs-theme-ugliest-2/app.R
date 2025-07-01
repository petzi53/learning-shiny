library(shiny)
library(bslib)

ui <- fluidPage(
    # theme = bs_theme(),  # Initialize bslib theme
    theme = bslib::bs_theme(
        fg = "rgba(37, 66, 192, 0.6)",
        font_scale = NULL,
        bg = "#ffffff",
        base_font = font_google("Manufacturing Consent"),
        code_font = font_google("Fira Code"),
        heading_font = font_google("Bitcount Grid Double"),
        secondary = "#9A3232",
        success = "#B3E7BD",
        spacer = "5rem"
    ),
    # theme = bslib::bs_theme(
    #     bg = "#0b3d91",
    #     fg = "white",
    #     base_font = "Source Sans Pro"
    #     ),
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
    bslib::bs_themer(theme)
}

shinyApp(ui, server)

# bslib::run_with_themer(shinyApp(ui, server))
