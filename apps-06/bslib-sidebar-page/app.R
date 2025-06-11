library(shiny)
library(bslib)
library(ggplot2)

ui <- page_sidebar(
    title = "Example dashboard",
    # code for bs_theme taken from
    # https://rstudio.github.io/bslib/articles/theming/index.html#main-colors
    # but results in the same error message
    # "Text to be written must be a length-one character vector"
    bs_theme(
        preset = "darkly",
        bg = "#101010",
        fg = "#FFF",
        primary = "#E69F00",
        secondary = "#0072B2",
        success = "#009E73",
        base_font = font_google("Inter"),
        code_font = font_google("JetBrains Mono")
    ),
    sidebar = sidebar(
        varSelectInput("var", "Select variable", mtcars)
    ),
    card(
        full_screen = TRUE,
        card_header("My plot"),
        plotOutput("p")
    )
)

server <- function(input, output) {
    output$p <- renderPlot({
        ggplot(mtcars) + geom_histogram(aes(!!input$var))
    })
}

shinyApp(ui, server)
