# apps-09/download-report-github
# taken from chapter 9.2.3 Downloading reports of "Master Shiny"
# code taken from rmarkdown-report/,
# https://github.com/hadley/mastering-shiny/tree/main/rmarkdown-report


library(shiny)

# Copy report to temporary directory. This is mostly important when
# deploying the app, since often the working directory won't be writable
report_path <- tempfile(fileext = ".Rmd")
file.copy("report.Rmd", report_path, overwrite = TRUE)

render_report <- function(input, output, params) {
    rmarkdown::render(input,
                      output_file = output,
                      params = params,
                      envir = new.env(parent = globalenv())
    )
}

ui <- fluidPage(
    sliderInput("n", "Number of points", 1, 100, 50),
    downloadButton("report", "Generate report")
)

server <- function(input, output) {
    output$report <- downloadHandler(
        filename = "report.html",
        content = function(file) {
            params <- list(n = input$n)
            callr::r(
                render_report,
                list(input = report_path, output = file, params = params)
            )
        }
    )
}

shinyApp(ui, server)
