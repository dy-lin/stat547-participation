# author: Diana Lin
# date: 2020-03-17

"This script is the main file that creates a Dash app.

Usage: app.R
"

# 1. Load libraries
library(dash)
library(tidyverse)
library(plotly)
library(dashCoreComponents)
library(dashHtmlComponents)
library(purrr)

# Add make_plot as instructed in cm108
make_plot <- function() {
  plot <- mtcars %>% 
    ggplot() + 
    theme_bw() +
    geom_point(aes(x = mpg, y = hp) ) + 
    labs(x = 'Fuel efficiency (mpg)',
         y = 'Horsepower (hp)') + 
    ggtitle(("Horsepower and Fuel efficiency for "))
  
  ggplotly(plot)
}

# Assign components to variables as instructed in cm108
heading1 <- htmlH1('Hello world Dash application')
heading2 <- htmlH2('This is a subheading')

# tibble to associate label with value
opts <- tibble(label = c("New York City", "Montreal", "San Francisco"), value = c("NYC", "MTL", "SF"))

# drop down menu component
dropdown <- dccDropdown(
  id = 'location-dropdown',
  options = map(1:nrow(opts), function(x) {
    list(label=opts$label[x], value=opts$value[x])
  })
)

# graph component
plot <-  dccGraph(id='mtcars', figure = make_plot())

# 2. Create Dash instance 
app <- Dash$new()

# 3. Specify App layout

# THIS PART BELOW HAS BEEN TURNED INTO A FUNCTION ABOVE
# add ggplot (commented out from cm107)
# plot <- mtcars %>% 
#   ggplot() + 
#   theme_bw() +
#   geom_point(aes(x = mpg, y = hp) ) + 
#   labs(x = 'Fuel efficiency (mpg)',
#        y = 'Horsepower (hp)') + 
#   ggtitle(("Horsepower and Fuel efficiency for "))

# plot <- ggplotly(plot)

app$layout(
  htmlDiv(
    list(
      heading1,
      heading2,
      dropdown,
      plot
      
      # THESE COMPONENTS WERE ASSIGNED ABOVE TO IMPROVE NEATNESS AND READABILITY
      
      # commented out from cm107 since cm108 adds components
      # htmlH1('Hello world Dash application'),
      # htmlH2('This is a subheading'),
      # dccDropdown(
      # options = list(
      #   list(label = "New York City", value = "NYC"),
      #   list(label = "Montréal", value = "MTL"),
      #   list(label = "San Francisco", value = "SF")
      # ), 
      #   value="MTL"
      # ),
      # dccGraph(id='mtcars', figure = plot)
    )
  )
)

# 4. Run app

app$run_server(debug = TRUE)