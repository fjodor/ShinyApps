# Example from rdrr.io
# https://appsilon.com/r-shiny-caching/

# Other options:
# renderCachedPlot()
# memoise package

library(shiny)
library(dplyr)

shinyOptions(cache = cachem::cache_disk("./bind-cache"))

ui <- fluidPage(
  sliderInput("x", "x", 1, 10, 5),
  sliderInput("y", "y", 1, 10, 5),
  actionButton("go", "Go"),
  div("x * y: "),
  verbatimTextOutput("txt")
)


server <- function(input, output, session) {
  r <- reactive({
    message("Doing expensive computation...")
    Sys.sleep(2)
    input$x * input$y
  }) %>%
    bindCache(input$x, input$y) %>%
    bindEvent(input$go)
  output$txt <- renderText(r())
}

shinyApp(ui = ui, server = server)

