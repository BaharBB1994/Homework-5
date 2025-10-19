library(shiny)
library(palmerpenguins)
library(ggplot2)
library(dplyr)
library(rsconnect)

rsconnect::setAccountInfo(name='bahar1994',
                          token='585BCD8818F5D301E90AC7BFF7ECE402',
                          secret='d4WWZy7Fofkp3dN7CZEB/hoxDRHFRuO0lpmEAyRw')

ui <- fluidPage(
  titlePanel("Penguin Measurements Scatterplot"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("species", "Select Species:",
                  choices = c("All", as.character(unique(penguins$species))),
                  selected = "All"),
      
      selectInput("sex", "Select Sex:",
                  choices = c("All", as.character(unique(na.omit(penguins$sex)))),
                  selected = "All"),
      
      selectInput("xvar", "X-axis:",
                  choices = c("bill_length_mm", "bill_depth_mm", 
                              "flipper_length_mm", "body_mass_g"),
                  selected = "bill_length_mm"),
      
      selectInput("yvar", "Y-axis:",
                  choices = c("bill_length_mm", "bill_depth_mm", 
                              "flipper_length_mm", "body_mass_g"),
                  selected = "bill_depth_mm")
    ),
    
    mainPanel(
      plotOutput("scatterPlot")
    )
  )
)

server <- function(input, output) {
  
  filtered_data <- reactive({
    data <- penguins
    data$species <- as.character(data$species)
    data$sex <- as.character(data$sex)
    
    if(input$species != "All"){
      data <- data[data$species == input$species, ]
    }
    if(input$sex != "All"){
      data <- data[data$sex == input$sex, ]
    }
    
    data
  })
  
  output$scatterPlot <- renderPlot({
    data <- filtered_data()
    
    if(nrow(data) == 0){
      plot.new()
      text(0.5, 0.5, "No data for this combination of species and sex", cex = 1.5)
    } else {
      ggplot(data, aes_string(x = input$xvar, y = input$yvar, color = "species")) +
        geom_point(size = 3, alpha = 0.7) +
        labs(x = input$xvar, y = input$yvar, color = "Species") +
        theme_minimal()
    }
  })
}

shinyApp(ui = ui, server = server)
