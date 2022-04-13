# t-Test: Delayed reactivity

library(chartmusicdata)
library(shiny)

ui <- fluidPage(
  
  titlePanel("Exploring t-Tests: Effect of Mean Diff. and N on p-Value and Effect Size"),
  
  sidebarLayout(
    
    sidebarPanel(
     sliderInput(inputId = "N", label = "N in each group", min = 10, max = 1000, value = 50),
     sliderInput(inputId = "mean1", label = "Mean for group 1", min = 10, max = 50, value = 10),
     sliderInput(inputId = "mean2", label = "Mean fro group 2", min = 10, max = 50, value = 10)
    ),
    
    mainPanel(
      # 
    )
  )
  
)

