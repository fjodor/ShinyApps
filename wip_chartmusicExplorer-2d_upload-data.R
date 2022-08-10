library(chartmusicdata)
library(shiny)
library(tidyverse)

ui <- fluidPage(
  
  titlePanel("File Upload"),
  
  sidebarLayout(
    
    sidebarPanel(
      fileInput(inputId = "upload", 
                label = "Upload a songs2000 dataset (.rds format)", buttonLabel = "Upload ...",
                accept = ".rds", multiple = FALSE),
      selectInput(inputId = "bandname", label = "Select band / artist", choices = NULL, selected = "Drake"),
      selectInput(inputId = "song", label = "Select song to highlight", choices = NULL, selected = "God's Plan")
    ),
    
    mainPanel(
      h2("Selected Data, taken from uploaded file"),
      tableOutput("head"),
      plotOutput(outputId = "bandplot")
    )
  )
)

server <- function(input, output, session) {

    # Here we deal with the file input

    data <- reactive({
      req(input$upload)
      
      # Validate file extension (browsers don't always enfore correct file type)
      ext <- tools::file_ext(input$upload$name)
      switch(ext,
             rds = readRDS(input$upload$datapath),
             validate("Invalid file; please upload an .rds file")
             )
      })

    band_react <- reactive({
      req(input$upload)
      input$bandname
      print(band_react)
    })
    
    # band_react <- reactive(input$bandname)
    
    output$bandplot <- renderPlot({

      req(input$upload)      
      req(input$bandname)
      req(input$song)
    
      plotdata_full <- data() %>% 
        filter(artist == band_react())
  
      plotdata_highlight <- plotdata_full %>% 
        filter(song == input$song)
  
      ggplot(plotdata_full, aes(x = year_month, y = indicativerevenue)) +
        geom_point(size = 1.5, color = "darkgrey") +
        geom_point(data = plotdata_highlight, size = 2.5, color = "darkblue") +
        labs(title = paste("Songs by", band_react()),
             subtitle = paste("Highlighted Song:", input$song),
             x = "Month and Year",
             y = "Indicative Revenue in USD") +
        scale_x_discrete(labels = function(x) {
          x <- sort(unique(x))
          x[seq(2, length(x), 2)] <- ""
          x
        }) +
        scale_y_continuous(labels = scales::label_dollar(scale = 1000)) +
        theme_bw(base_size = 14) +
        theme(axis.text.x = element_text(angle = 90))
        
    })
  
    band <- reactive({
      req(input$bandname)
      filter(data(), artist == input$bandname)
    })
    
    observe({
      x <- band()
      songs <- data() %>% 
        filter(artist == input$bandname) %>% 
        pull(song)
      updateSelectInput(inputId = "song", choices = songs)
    }) %>% bindEvent()
}

shinyApp(ui = ui, server = server)
