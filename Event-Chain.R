# Skeleton for an event chain in Shiny

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
  
}

shinyApp(ui, server)
