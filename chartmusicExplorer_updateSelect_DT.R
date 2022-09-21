library(chartmusicdata)
library(shiny)
library(tidyverse)
library(DT)

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
      selectInput(inputId = "song", label = "Select song to highlight", choices = NULL)
    ),
    
    mainPanel(
      h2("Selected Data, taken from songs2000"),
      DTOutput(outputId = "bandtable")
      # plotOutput(outputId = "bandplot")
    )
  )
)

server <- function(input, output, session) {

    output$bandtable <- renderDT({
    songsdata %>% 
      filter(artist == input$bandname) %>% 
      datatable(filter = "top")
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
}

shinyApp(ui = ui, server = server)
