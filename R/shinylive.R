#### R/shinylive.R

# Workaround for Chromium Issue 468227 ######
## see: https://shiny.posit.co/r/components/inputs/download-button/
# Need this to properly download files
# this bug and workaround is only for shinylive,
# you do not need it in your regular app
downloadButton <- function(...) {
    tag <- shiny::downloadButton(...)
    tag$attribs$download <- NULL
    tag
}
### End of workaround ####
