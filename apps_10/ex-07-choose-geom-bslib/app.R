library(shiny)
library(bslib)

data(diamonds, package = "ggplot2")

ggp <- ggplot2::ggplot(diamonds, ggplot2::aes(carat))



ui <- page_sidebar(
    title = "Choose geom",
        sidebar = sidebar(
            selectInput("geom", "Type of distribution", choices =
                            c("Histogram" = "histogram",
                              "Frequency" = "frequency",
                              "Density" = "density")),
            navset_hidden(
                id = "params",
                nav_panel_hidden(value = "histogram",
                          sliderInput("bw_hist", "Binwidth", min = 0.01, max = 0.5, step = 0.01, value = 0.1, sep = ".")
                ),
                nav_panel_hidden(value = "frequency",
                          sliderInput("bw_freq", "Binwidth", min = 0.01, max = 0.5, step = 0.01, value = 0.1, sep = ".")
                ),
                nav_panel_hidden(value = "density",
                          selectInput("bw", "Bandwith", choices =
                                          c("nrd0: Silverman's rule of thumb" = "nrd0",
                                            "nrd: Scott's variation (more common)" = "nrd",
                                            "ucv: Unbiases cross-validation" = "ucv",
                                            "bcv: Biased cross-validation" = "bcv",
                                            "sj: Sheater & Jones pilot estimation of derivates" = "sj")
                          )
                )
            )
        ),
    card(
        card_header(textOutput("selected")),
        plotOutput("plot")
    )
)

server <- function(input, output, session) {

    observe({
        nav_select("params", input$geom)
        })

    # observeEvent(input$geom, {
    #     nav_select("params", input$geom)
    #     nav_show(
    #         id = "params",
    #         target = input$geom,
    #         select = TRUE
    #         )
    # })

    output$selected <- renderText({
        switch(input$geom,
               histogram = "Displaying the counts with bars",
               frequency = "Display the counts with lines",
               density = "Display kernel density estimate: A smoothed version of the histogram"
        )
   })

    p <- reactive({switch(input$geom,
                          histogram = ggp + ggplot2::geom_histogram(binwidth = input$bw_hist),
                          frequency = ggp + ggplot2::geom_freqpoly(binwidth = input$bw_freq),
                          density = ggp + ggplot2::geom_density(bw = input$bw)
    )
    })


    output$plot <-  renderPlot({
        p()

    })
}

shinyApp(ui, server)
