datetime <- Sys.time() + (86400 * 0:10)

server <- function(input, output, session) {
    output$interaction_slider <- renderUI({
        sliderInput(
            "slider",
            "Select Range:",
            min   = min(datetime),
            max   = max(datetime),
            value = c(min, max)
        )
    })

    brks <- reactive({
        req(input$slider)
        seq(input$slider[1], input$slider[2], length.out = 10)
    })

    output$breaks <- brks
}
