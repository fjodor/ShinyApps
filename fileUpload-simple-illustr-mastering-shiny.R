# Simple Shiny app to illustrate how file upload works
# Source: https://mastering-shiny.org/action-transfer.html#server
# Live at https://hadley.shinyapps.io/ms-upload/

ui <- fluidPage(
  fileInput("upload", NULL, buttonLabel = "Upload...", multiple = TRUE),
  tableOutput("files")
)
server <- function(input, output, session) {
  output$files <- renderTable(input$upload)
}

shinyApp(ui = ui, server = server)