library(chartmusicdata)
library(DT)
library(shiny)

ui <- fluidPage(

  titlePanel("Explore chartmusicdata"),

    selectInput(inputId = "chooseData",
                    label = "Choose Dataset",
                    choices = ls("package:chartmusicdata")
      ),
    
      h3("Enjoy Exploring the Data!"),
      
      DTOutput("table")
)

server <- function(input, output, session) {
  
  output$table <- renderDT({
    data <- get(input$chooseData, "package:chartmusicdata")
    DT::datatable(data, filter = "top")
  })
}

shinyApp(ui, server)
