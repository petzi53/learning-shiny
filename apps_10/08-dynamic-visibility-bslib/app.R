library(shiny)
library(bslib)

ui <- page_sidebar(
    title = "My dashboard",
    sidebar = sidebar(
        selectInput("controller", "Show",
                    choices = paste0("panel", 1:3)),
        navset_hidden(
            id = "switcher",
            nav_panel_hidden(value = "panel1", p("Panel 1 content")),
            nav_panel_hidden(value = "panel2", p("Panel 2 content")),
            nav_panel_hidden(value = "panel3", p("Panel 3 content"))
        )
    ),
)


server <- function(input, output, session) {

    observe({
        nav_select("switcher", input$controller)
    })

}

shinyApp(ui, server)
