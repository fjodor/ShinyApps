# Quelle: https://appsilon.com/how-to-use-tailwindcss-in-shiny/

ui <- div(
  tags$script(src = "https://cdn.tailwindcss.com"),
  div(
    "I am a rounded box!", 
    class = "rounded bg-gray-300 w-64 p-2.5 m-2.5"
  )
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)

# The downside of using TailwindCSS in Shiny is that you might have trouble
# using base Shiny components such as selectInput and textInput. You might need
# to reimplement some of the JavaScript-based logic to set up the communication
# between your custom styled inputs and Shiny.