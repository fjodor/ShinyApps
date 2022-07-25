# Shiny App: Simple file upload

library(shiny)
library(tidyverse)

ui <- fluidPage(
  
  titlePanel("File Upload"),
  
  sidebarLayout(
    
    sidebarPanel(
      fileInput(inputId = "upload", 
                label = "Upload a songs2000 dataset (.rds format)", buttonLabel = "Upload ...",
                accept = ".rds", multiple = FALSE)
    ),
    mainPanel(
      h2("Revenue of all songs over time"),
      plotOutput(outputId = "plot")
    )
  )
)

server <- function(input, output, session) {

  # Process file input
  data <- reactive({
    req(input$upload)
    
    # Validate file extension (browsers don't always enfore correct file type)
    ext <- tools::file_ext(input$upload$name)
    switch(ext,
           rds = readRDS(input$upload$datapath),
           validate("Invalid file; please upload an .rds file")
    )
  })
  
  output$plot <- renderPlot({
    ggplot(data(), aes(x = year_month, y = indicativerevenue)) +
      geom_jitter(size = 0.5, alpha = 0.2) +
      scale_x_discrete(labels = function(x) {
        x <- sort(unique(x))
        x[seq(2, length(x), 4)] <- ""
        x[seq(3, length(x), 4)] <- ""
        x[seq(4, length(x), 4)] <- ""
        x
      }) +
      scale_y_continuous(labels = scales::label_dollar(scale = 1000)) +
      theme_bw(base_size = 14) +
      theme(axis.text.x = element_text(angle = 90))
    
  })
}

shinyApp(ui = ui, server = server)

    