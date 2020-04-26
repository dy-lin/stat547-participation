# author: Diana Lin
# date: March 24,2020

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
  p <- ggplot(data, aes(
    x = year,
    y = !!sym(yaxis),
    colour = continent,
    customdata=country,
    text = paste(
      'Continent: ',
      continent,
      '</br></br> Country: ',
      country,
      '</br></br>Year:',
      year,
      '</br></br> GDP:',
      gdpPercap
    )
  )) +
    geom_jitter(alpha = 0.6) +
    scale_color_manual(name = 'Continent', values = continent_colors) +
    scale_x_continuous(breaks = unique(data$year)) +
    scale_y_continuous(trans = yscale) +
    xlab("Year") +
    ylab(y_label) +
    ggtitle(paste("Change in", y_label, "over time", sep = " ")) +
    theme_bw()
  
  # Passing c("text") into tooltip only shows the contents of the "text" aesthetic specified above
  ggplotly(p, 
           tooltip = c("text")) %>%
    layout(clickmode = 'event+select')
}

make_country_graph <- function(country_select = "Canada", 
                               yaxis = "gdpPercap") {
  
  yaxisKey <-
    tibble(
      label = c("GDP Per Capita", 
                "Life Expectancy", 
                "Population"),
      value = c("gdpPercap", 
                "lifeExp", 
                "pop")
    )
  
  # Get label corresponding to axis
  y_label <- yaxisKey$label[yaxisKey$value==yaxis]
  
  # Filter data bsed on year/continent
  data <- gapminder %>%
    filter(country == country_select)
  
  # Make the plot
  p2 <- ggplot(data, aes(x=year, y= !!sym(yaxis), colour = continent)) +
    geom_line() +
    scale_color_manual(name = "Continent", values = continent_colors) +
    scale_x_continuous(breaks = unique(data$year)) +
    xlab("Year") +
    ylab(y_label) +
    ggtitle(paste("Change in",y_label,"over time, country:",country_select, sep=" ")) +
    theme_bw()
  
  ggplotly(p2)
    
}

## Assign components to variables

heading_title <- htmlH1('Gapminder Dash Demo')
heading_subtitle <- htmlH2('Looking at country data interactively')

graph_country <- dccGraph( id = 'gap-graph-country',
                           figure = make_country_graph())

# Storing the labels/values as a tibble means we can use this both 
# to create the dropdown and convert colnames -> labels when plotting
yaxisKey <- tibble(label = c("GDP Per Capita", "Life Expectancy", "Population"),
                   value = c("gdpPercap", "lifeExp", "pop"))

# Create the dropdown
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

# Create radio buttons with default value
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
      # Selection components
      htmlLabel('Select y-axis metric:'),
      yaxisDropdown,
      htmlIframe(height=15, width=10, style=list(borderWidth = 0)),
      htmlLabel('Select y scale: '),
      logbutton,
      # Graph and table
      # Spacing
      htmlIframe(height=20, width=10, style=list(borderWidth = 0)),
      graph,
      graph_country,
      htmlIframe(height=20, width=10, style=list(borderWidth = 0)), #space
      sources
    )
  )
)

## App Callbacks
app$callback(
  #W hat you want to update
  output=list(id = 'gap-graph', property='figure'),
  # Based on the following values
  params = list(input(id = 'y-axis', property = 'value'),
                input(id = 'yaxis-type', property = 'value')),
  # Translate your list of params into function arguments
  function(yaxis_value, yaxis_type) {
    make_plot(yaxis_value,yaxis_type)
  }
)

# Update the other graph 
app$callback(output = list(id = 'gap-graph-country', property = 'figure'),
             params = list(
               input(id = 'y-axis', property = 'value'),
               input(id = 'gap-graph', property = 'clickData')
             ),
             function(yaxis_value, clickData) {
               country_name <- clickData$points[[1]]$customdata
               make_country_graph(country_name, yaxis_value)
             })

## Run app
app$run_server(debug = FALSE)
# for some reason doesn't work if debug =TRUE

# command to add dash app in Rstudio viewer:
# rstudioapi::viewer("http://127.0.0.1:8050")