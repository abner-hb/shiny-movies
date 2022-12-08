library(shiny)
library(RSQLite)
library(tidyverse)
movies = read_csv("clean_data.csv")
# source("R/get_movie_rows.R")
# source("R/movie_plot.R")
# source("R/build_plot.R")

# Define UI for dataset viewer app ----
ui <- fluidPage(
    
    # App title ----
    titlePanel("Movie Plot"),
    
    # Sidebar layout with a input and output definitions ----
    sidebarLayout(
        
        # Sidebar panel for inputs ----
        sidebarPanel(
            
            # Input: x
            selectInput("x",
                        label = "Choose an x:",
                        choices = c("release_date", "budget", "revenue", "duration")),
            
            # Input: y
            selectInput("y",
                        label = "Choose a y:",
                        choices = c("budget","revenue","duration")),
            
            # Input: column
            selectInput("col",
                        label = "Column to filter:",
                        choices = c("None", "actors","director","main_country","production_companies","title")),
            
            # filter by director
            textInput("name", "Filter by Name","Tom Hanks"),
            
            submitButton("Render Plot")
        ),
        
        mainPanel(
            
            #function that decide plot type
            plotOutput(outputId = "myPlot")
            
        )
    )
)

# Define server logic to summarize and view selected dataset ----
server <- function(input, output, session) {
    
    
    # Return the requested dataset ----
    datasetInput <- reactive({
        switch(input$x,
               "budget" = movies$budget,
               "revenue" = movies$revenue,
               "duration" = movies$duration,)
    })
    datasetInput <- reactive({
        switch(input$y,
               "budget" = movies$budget,
               "revenue" = movies$revenue,
               "duration" = movies$duration,)
    })
    datasetInput <- reactive({
        switch(input$col,
               "actors" = "actors",
               "director" = "director",
               "main_country" = movies$main_country,
               "production_companies" = movies$production_companies,
               "title" = "title")
    })
    
    
    # Generate a plot
    output$myPlot <- renderPlot({
                 
        if(input$name!= ""){
            b=input$name
        }else{
            b=NULL
        }
       
        
        build_plot(
            xcol = input$x,
            ycol = input$y,
            cols_to_filter = input$col,
            containing = b
        )
    })
    
}

# Create Shiny app ----
shinyApp(ui = ui, server = server)
