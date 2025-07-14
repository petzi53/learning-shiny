### reactlog data extraction

library(shiny)
options(shiny.reactlog = TRUE)
source(paste0(here::here(), "/R/reactlog-utils.R"))


reset_graph()
# Interact with the application, then close it
runApp(paste0(here::here(), "/apps_14/50-two-freqpoly/app.R"))
# Save the data to files
process_last_reactlog(name = "two-freqpoly")
