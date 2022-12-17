library(shiny)
library(RSQLite)
library(tidyverse)
movies = read_csv("clean_data.csv")
source("R/get_movie_rows.R")
# source("R/movie_plot.R")
# source("R/build_plot.R")

# Define UI for dataset viewer app ----
ui<-fluidPage(
    titlePanel("Movie explorer"),
    fluidRow(
        column(3,
               wellPanel(
                   h4("Filter"),
                   selectInput("fields",
                               label = "fields:",
                               choices = c("actors","director","duration")),
                   selectInput("conditions",
                               label = "Conditions:",
                               choices = c("Including","Not including",">=","<=")),
                   textInput("values","values", value=1),
                   selectInput("joiners",
                               label = "Joiners",
                               choices = c("AND","OR","NONE")),
                   actionButton("do", "Click Me"),
                   actionButton("clear", "Clear")
                   
               ),
               
               
               wellPanel(
                   selectInput("x",
                               label = "Choose an x:",
                               choices = c("release_date", "budget", "revenue", "duration")),
                   selectInput("y",
                               label = "Choose a y:",
                               choices = c("budget","revenue","duration")),
                   
               ),
               
        ),
        
        column(9,
               plotOutput(outputId = "myplot"),
               tableOutput('table'),
               
        )
        
    )
)


server <- function(input, output, session) {
    v <- reactiveValues(data = data.frame(field=c(), condition=c(),
                                          value=c(), joiner=c()))
    
    observeEvent(input$do, {
        df <- v$data
        df2 <- data.frame(fields=input$fields, conditions=input$conditions, values=input$values,
                          joiners=input$joiners)
        v$data <- rbind(df, df2)
        print(v$data)
    })
    observeEvent(input$clear,{
        v$data<-data.frame()
    })
    output$table <- renderTable(v$data)
    # # Generate a plot
    output$myplot <- renderPlot({
        
        build_plot(
            xcol = input$x,
            ycol = input$y,
            input_mat = v$data
        )
    })
    
}

# Create Shiny app ----
shinyApp(ui = ui, server = server)
