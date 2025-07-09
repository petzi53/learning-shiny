library(shiny)

data(diamonds, package = "ggplot2")

ggp <- ggplot2::ggplot(diamonds, ggplot2::aes(carat))

parameter_tabs <- tabsetPanel(
    id = "params",
    type = "hidden",
    tabPanel("histogram",
            sliderInput("bw_hist", "Binwidth for Histogram", min = 0.01, max = 0.5, step = 0.01, value = 0.1, sep = ".")
    ),
    tabPanel("frequency",
            sliderInput("bw_freq", "Binwidth for Frequency", min = 0.01, max = 0.5, step = 0.01, value = 0.1, sep = ".")
    ),
    tabPanel("density",
            selectInput("bw", "Smoothing bandwith", choices =
                             c("nrd0: Silverman's rule of thumb" = "nrd0",
                               "nrd: Scott's variation (more common)" = "nrd",
                               "ucv: Unbiases cross-validation" = "ucv",
                               "bcv: Biased cross-validation" = "bcv",
                               "sj: Sheater & Jones pilot estimation of derivates" = "sj")
             )
    )
)

ui <- fluidPage(
    titlePanel("Distribution of diamonds"),
    sidebarLayout(
        sidebarPanel(
            selectInput("geom", "Type of distribution", choices =
                            c("Histogram" = "histogram",
                              "Frequency" = "frequency",
                              "Density" = "density")
                        ),
            parameter_tabs
        ),
        mainPanel(plotOutput("plot"))
    )
)

server <- function(input, output, session) {

    observeEvent(input$geom, {
        updateTabsetPanel(inputId = "params", selected = input$geom)
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
