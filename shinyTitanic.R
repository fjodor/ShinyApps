library(shiny)
library(titanic)
library(tidyverse)
library(rpart)
library(rpart.plot)

titanic <- titanic_train %>% 
    # select(Survived, Pclass, Sex, Age) %>% 
    select(-PassengerId, -Name) %>% 
    rename(Alter = Age, Passagierklasse = Pclass, Geschlecht = Sex) %>% 
    mutate(Survived = factor(Survived),
           Survived = fct_recode(Survived, Ertrunken = "0", Gerettet = "1"),
           Geschlecht = fct_recode(Geschlecht, weiblich = "female", männlich = "male"),
           Passagierklasse = factor(Passagierklasse),
           Passagierklasse = fct_recode(Passagierklasse, `1. Klasse` = "1", `2. Klasse` = "2", `3. Klasse` = "3"),
           Alter = round(Alter))



ui <- fluidPage(
    
    titlePanel("Data Mining mit R: Titanic"),
    
    sidebarLayout(
        sidebarPanel(
            checkboxInput(inputId = "surrogate", label = "Fehlwerte: Ersatzvariable verwenden"),
            radioButtons(inputId = "firstsplit", label = "Erste Verzweigung:",
                         choices = c("Algorithmus entscheidet", "Alter", "Passagierklasse"))
            ),

        mainPanel(
            plotOutput(outputId = "titanicPlot", width = "100%", height = "600px")
        )
    )
)

server <- function(input, output) {
    
    output$titanicPlot <- renderPlot({
        
        cost <- case_when(
            input$firstsplit == "Algorithmus entscheidet"   ~ c(rep(1, 3), rep(100, 6)),
            input$firstsplit == "Alter"                     ~ c(1, 1, 0.01, rep(100, 6)),
            input$firstsplit == "Passagierklasse"           ~ c(0.01, 1, 1, rep(100, 6))
        )
        
        tree <- rpart(Survived ~ ., data = titanic, method = "class", usesurrogate = ifelse(isTRUE(input$surrogate), 1, 0),
                      cost = cost, cp = 0.01, maxdepth = 4)
        
        prp(tree, main = "Titanic: Wurden Frauen und Kinder zuerst gerettet?",
            type = 4,                                     # type: 1 = label all nodes
            extra = 1,                                    # extra: 1 = number of obs per node; +100: percentage
            prefix = "Ertrunken / Gerettet\nMehrheit: ",
            xsep = " / ",
            faclen = 0,                                     # do not abbreviate factor levels
            nn = FALSE,                                     # display the node numbers
            ni = TRUE,                                      # display node indices
            yesno = 2,                                      # write yes / no at every split
            roundint = TRUE,
            # ycompress = FALSE,
            yes.text = "ja",
            no.text = "nein",
            facsep = ", ",
            varlen = 0,                                     # don't abbreviate variable names
            shadow.col = "gray",
            split.prefix = " ",
            split.suffix = " ",
            # col = cols, border.col = cols,                # use for categorical outcomes, predefine colours
            box.palette = "BuGn",
            # box.palette = "auto",
            split.box.col = "lightgray",
            split.border.col = "darkgray",
            split.round = .5,
            cex = NULL)                                        # text size
        
    })
}

# shinyApp(ui = ui, server = server)

shinyApp(ui = ui, server = server, options = list(display.mode = "showcase"))
