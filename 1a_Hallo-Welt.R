library(shiny)
ui <- fluidPage(
  "Hallo, Welt!"
)
server <- function(input, output, session) {
}
shinyApp(ui, server)