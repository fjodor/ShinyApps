library(chartmusicdata)
library(shiny)
library(tidyverse)

artists <- songs2000 %>% 
  count(artist, sort = TRUE) %>% 
  slice_head(n = 10) %>% 
  pull(artist)

songsdata <- songs2000 %>% 
  filter(artist %in% artists)

ui <- fluidPage(
  
  titlePanel("Simple Dynamic UI: Update Function"),
  
  sidebarLayout(
    
    sidebarPanel(
      selectInput(inputId = "bandname", label = "Select band / artist", choices = artists, selected = "Drake"),
      selectInput(inputId = "song", label = "Select song to highlight", choices = NULL, selected = "God's Plan")
    ),
    
    mainPanel(
      h2("Selected Data, taken from songs2000"),
      plotOutput(outputId = "bandplot"),
      downloadButton("download")
      # downloadLink("download")  # Alternative
      # customise using class and icon arguments
    )
  )
)

server <- function(input, output, session) {

    band_react <- reactive(input$bandname)  
  
    output$bandplot <- renderPlot({

    plotdata_full <- songsdata %>% 
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
      filter(songsdata, artist == input$bandname)
    })
    
    observeEvent(band(), {
      songs <- songsdata %>% 
        filter(artist == input$bandname) %>% 
        pull(song)
      updateSelectInput(inputId = "song", choices = songs)
    })
    
    output$download <- downloadHandler(
      filename = function() {
        paste0(input$bandname, "-", input$song, ".png")
      },
      content = function(file) {
        ggsave(file, plot = last_plot(), width = 10, height = 6)
      }
    )
}

shinyApp(ui = ui, server = server)
