library(shiny)
source("R/get_movie_rows.R")
source("R/movie_plot.R")
source("R/build_plot.R")

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
                        choices = c("budget", "revenue","duration")),
            
            # Input: y
            selectInput("y",
                        label = "choose a y:",
                        choices = c("budget","revenue","duration")),
            
            # filter by actor
            textInput("col", "Column to filter"),
            
            # filter by director
            textInput("name", "Filter by Name"),
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
               "budget" = clean_data$budget,
               "revenue" = clean_data$revenue,
               "duration" = clean_data$duration,)
    })
    datasetInput <- reactive({
        switch(input$y,
               "budget" = clean_data$budget,
               "revenue" = clean_data$revenue,
               "duration" = clean_data$duration,)
    })
    
    
    # Generate a plot
    output$myPlot <- renderPlot({
        if(input$col!= ""){
            a=input$col
        }else{
            a=NULL
        }
                 
        if(input$name!= ""){
            b=input$name
        }else{
            b=NULL
        }
       
        
        build_plot(
            xcol = input$x,
            ycol = input$y,
            cols_to_filter = a,
            containing = b
        )
    })
    
}

# Create Shiny app ----
shinyApp(ui = ui, server = server)
