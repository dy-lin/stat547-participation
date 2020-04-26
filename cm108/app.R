# author: Diana Lin
# date: March 19,2020

"This script is the main file that creates a Dash app for cm108 on the gapminder dataset.

Usage: app.R
"

## Load libraries
library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashTable)
library(tidyverse)
library(plotly)
library(gapminder)

## Make plot
make_plot <- function(yaxis = "gdpPercap", yscale = "identity"){
  
  # gets the label matching the column value
  yaxisKey <-
    tibble(
      label = c("GDP Per Capita", 
      "Life Expectancy", 
                "Population"),
      value = c("gdpPercap", 
                "lifeExp", 
                "pop")
    )
  
  y_label <- yaxisKey$label[yaxisKey$value==yaxis]
  y_label <- if_else(yscale == "identity", y_label, paste0("log(",y_label,")"))
  
  # Filter our data based on the year/continent selections
  data <- gapminder
  p <- ggplot(data, aes(x = year, y = !!sym(yaxis), colour = continent,
                        text = paste('continent: ', continent,
                                     '</br></br></br> Year:', year,
                                     '</br></br> GDP:', gdpPercap))) +
    geom_jitter(alpha = 0.6) +
    scale_color_manual(name = 'Continent', values = continent_colors) +
    scale_x_continuous(breaks = unique(data$year))+
    scale_y_continuous(trans = yscale) +
    xlab("Year") +
    ylab(y_label) +
    ggtitle(paste("Change in",y_label,"over time",sep=" ")) +
    theme_bw()
  
  # passing c("text") into tooltip only shows the contents of the "text" aesthetic specified above
  ggplotly(p, 
           tooltip = c("text"))
}

## Assign components to variables

heading_title <- htmlH1('Gapminder Dash Demo')
heading_subtitle <- htmlH2('Looking at country data interactively')

# Storing the labels/values as a tibble means we can use this both 
# to create the dropdown and convert colnames -> labels when plotting
yaxisKey <- tibble(label = c("GDP Per Capita", "Life Expectancy", "Population"),
                   value = c("gdpPercap", "lifeExp", "pop"))

#Create the dropdown
yaxisDropdown <- dccDropdown(
  id = "y-axis",
  options = map(
    1:nrow(yaxisKey), function(i){
      list(label=yaxisKey$label[i], value=yaxisKey$value[i])
    }),
  value = "gdpPercap"
)

graph <- dccGraph(
  id = 'gap-graph',
  figure=make_plot() # gets initial data using argument defaults
)

sources <- dccMarkdown("[Data Source](https://cran.r-project.org/web/packages/gapminder/README.html)")

# Create Radio button with default value 
logbutton <- dccRadioItems(
  id = 'yaxis-type',
  options = list(list(label = 'Linear', value = 'identity'),
                 list(label = 'Log', value = 'log10')),
  value = 'identity'
)

## Create Dash instance

app <- Dash$new()

## Specify App layout

app$layout(
  htmlDiv(
    list(
      heading_title,
      heading_subtitle,
      # selection components
      htmlLabel('Select y-axis metric:'),
      yaxisDropdown,
      htmlIframe(height=15, width=10, style=list(borderWidth = 0)),
      htmlLabel('Select y scale: '),
      logbutton,
      # graph and table
      # htmlIframe for spacing without using css
      htmlIframe(height=20, width=10, style=list(borderWidth = 0)),
      graph,
      htmlIframe(height=20, width=10, style=list(borderWidth = 0)), # space
      sources
    )
  )
)

## App Callbacks

## Update Plot
app$callback(
  # What you want to update
  output=list(id = 'gap-graph', property='figure'),
  # Based on the following values
  params = list(input(id = 'y-axis', property = 'value'),
                input(id = 'yaxis-type', property = 'value')),
  # Translate your list of params into function arguments
  function(yaxis_value, yaxis_type) {
    make_plot(yaxis_value,yaxis_type)
  }
)

## Run app
app$run_server(debug=TRUE)

# command to add dash app in Rstudio viewer:
# rstudioapi::viewer("http://127.0.0.1:8050")