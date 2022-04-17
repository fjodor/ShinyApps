# t-Test: Direct vs. Delayed reactivity

# Adding a button to re-calculate only when the user explicitly wants to do so.

library(shiny)
library(compute.es)
library(report)

ui <- fluidPage(
  
  titlePanel("Exploring t-Tests: Effect of Mean Diff. and N on p-Value and Effect Size"),
  
  sidebarLayout(
    
    sidebarPanel(
     sliderInput(inputId = "N", label = "N in each Group", min = 10, max = 200, value = 30),
     sliderInput(inputId = "mean1", label = "Mean in Group 1", min = 10, max = 50, value = 10),
     sliderInput(inputId = "mean2", label = "Mean in Group 2", min = 10, max = 50, value = 11),
     sliderInput(inputId = "sd1", label = "Standard Deviation in Group 1", min = 1, max = 10, value = 5),
     sliderInput(inputId = "sd2", label = "Standard Deviation in Group 2", min = 1, max = 10, value = 5),
     actionButton(inputId = "button", label = "Calculate!")
    ),
    
    mainPanel(
      htmlOutput(outputId = "ttest") 
    )
  )
)

server <- function(input, output, session) {

  data <- eventReactive(input$button, {
    set.seed(1975)
    data.frame(
      x = c(rnorm(n = input$N, mean = input$mean1, sd = input$sd1),
            rnorm(n = input$N, mean = input$mean2, sd = input$sd2)),
      group = c(rep("Group 1", input$N), rep("Group 2",input$N))
    ) 
  })

    output$ttest <- renderText({

    # data <- data()
    
    ttest <- t.test(x ~ group, data = data())
    effsize <- tes(ttest$statistic, n.1 = input$N, n.2 = input$N, verbose = FALSE)
    
    paste("Mean in Group 1:", round(mean(data()$x[data()$group == "Group 1"]), 2), "<br>",
          "Mean in Group 2:", round(mean(data()$x[data()$group == "Group 2"]), 2), "<br><br>",
          "Standard Deviation in Group 1:", round(sd(data()$x[data()$group == "Group 1"]), 2), "<br>",
          "Standard Deviation in Group 2:", round(sd(data()$x[data()$group == "Group 2"]), 2), "<br><br>",
          "<b>The p value of our t-Test is:", format.pval(ttest$p.value, digits = 2), "</p>",
          "The Effect Size - Cohen's d - is:", effsize$d, "</b><br><br>",
          "More detailed interpretation:<br><br>", report(ttest))
  })
}

shinyApp(ui = ui, server = server)