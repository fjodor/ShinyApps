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
      selectInput(inputId = "bandname", label = "Select band / artist", choices = NULL),
      selectInput(inputId = "song", label = "Select song to highlight", choices = NULL)
    ),
    
    mainPanel(
      h2("Selected Data, taken from uploaded file"),
      tableOutput("head"),
      plotOutput(outputId = "bandplot")
    )
  )
)

server <- function(input, output, session) {

    # Deal with the file input after user supplied a file

    data <- reactive({
      req(input$upload)
      
      # Validate file extension (browsers don't always enfore correct file type)
      ext <- tools::file_ext(input$upload$name)
      switch(ext,
             rds = readRDS(input$upload$datapath),
             validate("Invalid file; please upload an .rds file")
             )
      })

    # Update drop down of bands: Allow max. of Top 20 songs
    
    observe({
      req(data())
      data <- data()
      updateSelectInput(inputId = "bandname", choices = data %>% count(artist, sort = TRUE) %>% 
                          head(n = min(20, nrow(.))) %>% pull(artist))
    })
    
    band <- reactive({
      req(input$bandname)
      filter(data(), artist == input$bandname)
    })
    
    observe({
      songs <- band() %>% 
        pull(song)
      updateSelectInput(inputId = "song", choices = songs)
    }) # %>% bindEvent()

    # Table output
    
    output$head <- renderTable({
      req(band())
      head(band(), n = 5)
    })
    
    # Render plot
    
    output$bandplot <- renderPlot({
      
      req(band())      
      
      plotdata_full <- band()
      
      plotdata_highlight <- plotdata_full %>% 
        filter(song == input$song)
      
      ggplot(plotdata_full, aes(x = year_month, y = indicativerevenue)) +
        geom_point(size = 1.5, color = "darkgrey") +
        geom_point(data = plotdata_highlight, size = 2.5, color = "darkblue") +
        labs(title = paste("Songs by", input$bandname),
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
}

shinyApp(ui = ui, server = server)
