# author: Diana Lin
# date: 2020-03-05
"This script adds a new column to the `mtcars` dataset converting fuel efficiency from miles per gallon to Litres per 100km. This script takes the gallon_type as the variable argument.

Usage: first_script.R  --gallon_type=<USA or Imperial> --convert_to=<L/100km or km/L>" -> doc

# load the packages
library(tidyr)
library(ggplot2)
library(dplyr)
library(docopt)
library(glue)

# get the command line arguments
opt <- docopt(doc)

# main function 
main <- function(gallon_type, convert_to) {
  
  # convert the fuel based on command line arguments
  mtcars %>%
    fuel_conversion(gallon_type = gallon_type, convert_to = convert_to) %>%
    ggplot(aes (x = lkm, y = hp)) +
    geom_point() +
    theme_bw(16) +
    labs(x = glue("Fuel efficiency ({convert_to})"),
         y = "Horse power (hp)",
         title = "Fuel efficiency by horse power") +
    ggsave("test_plot.png", width = 8, height = 5)

  print(glue("The gallon_type is {gallon_type}, and it has been converted into {convert_to}."))
} 

#' calculate fuel efficiency in L/100km
#' 
#' @param df is an input of the mtcars dataframe
#' @param gallon_type is a string either `USA` or `Imperial`
#' @param convert_to is a string either `L/100km` or `km/L`
#' @examples
#' fuel_conversion('USA', 'L/100km')

fuel_conversion <- function(df, gallon_type = "USA", convert_to = "L/100km") {
  if (gallon_type == "USA") {
    if (convert_to == "L/100km") {
      conv <- 235.215
    } else {
      conv <- 0.425144
    }
  } else {
    if (convert_to == "L/100km") {
      conv <- 282.481
    } else {
      conv <- 0.354006 
    }
  }
  df %>%
    mutate(lkm = mpg*conv)
}

main(opt$gallon_type, opt$convert_to)