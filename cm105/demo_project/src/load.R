"This script takes in an arff file and exports a csv in the data folder

Usage: src/load.R --url_to_read=<url_to_read> --filepath=<filepath>" -> doc

library(tidyverse)
library(docopt)

opt <- docopt(doc) 

main <- function(url_to_read = "https://github.com/STAT547-UBC-2019-20/data_sets/raw/master/Autism-Adult-Data.arff", 
                 filepath = "data/autism.csv"){
    # Read file
    df <- foreign::read.arff(url_to_read)

    # Save as CSV for easier loading
    write_csv(df, path = filepath)
}

main(opt$url_to_read, opt$filepath)