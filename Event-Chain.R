# Skeleton for an event chain in Shiny
# For the server function, check here:
# https://www.statworx.com/en/content-hub/blog/master-r-shiny-one-trick-to-build-maintainable-and-scaleable-event-chains/
  
library(shiny)

ui <- fluidPage(
  
  titlePanel("A Simple Event Chain in Shiny"),
  h2("Choose wisely!"),
  
  fluidRow(
    column(4, offset = 1,
           h3("Why were you born?"),
           h4("Choose at least one important reason"),
           checkboxGroupInput(
             "whyBorn", label = "",
             choiceNames = c("To get rich", "To climb the career ladder as far as possible",
                             "To discover the immortal aspect inside", "To help others"),
             choiceValues = c(1, 2, 11, 12)
            )
          ),
    
    column(4, offset = 1,
           h3("Which superpower do you desire the most?"),
           radioButtons(
             "superpower", label = "",
             choiceNames = c("Successful Businessman", "Master Coder",
                             "Intuition for other people's needs", "Unwavering Faith"),
             choiceValues = c(1, 2, 11, 12)
           )
         )
  ),
  
  fluidRow(
    column(2, offset = 5,
           actionButton("evaluate", "Evaluate my choices!",
                        class = "btn-primary btn-lg",
                        icon = icon("yin-yang"), verify_fa = FALSE)
          )
  )
)

server <- function(input, output, session) {
  
  # First evaluate superpower and provide feedback,
  # then evaluate why born and provide feedback (or open specific tabs)

  rv <- reactiveValues(
    superpower = FALSE,
    whyBorn = FALSE
  )
  
  observe({
    rv$superpower <- !(rv$superpower)
  }) |> bindEvent(input$evaluate, ignoreInit = TRUE)
 
  observe({

    num <- as.numeric(input$superpower)
    
    showModal(modalDialog(
      title = "Evaluation: Superpower",

      if (num > 10) {
        "You're in on the Spiritual Path!"
      } else {
        "Best of luck!"
      },
      
      footer = actionButton("stepWhyBorn", "Next: Evaluate 'Why born?'")
      
    ))

  }) |> bindEvent(rv$superpower, ignoreInit = TRUE)

  observe({
    rv$whyBorn <- !(rv$whyBorn)
  }) |> bindEvent(input$stepWhyBorn, ignoreInit = TRUE)

  observe({
    
    num <- sum(as.numeric(input$whyBorn))
    
    showModal(modalDialog(
      title = "Evaluation: Why were you born?",
      
      if (num > 10) {
        "You're in on the Spiritual Path!"
      } else {
        "Best of luck!"
      },
      
      footer = actionButton("end", "OK - end of App")
      
    ))
    
  }) |> bindEvent(rv$whyBorn, ignoreInit = TRUE)

  observe({
    stopApp(42)
  }) |> bindEvent(input$end, ignoreInit = TRUE)
}

shinyApp(ui, server)
