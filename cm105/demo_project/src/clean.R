"This script loads in the autism.csv file, cleans it, and then re-exports the file with the same name

Usage: src/clean.R --filepath_raw=<filepath_raw> --filepath_cleaned=<filepath_cleaned>" -> doc

library(tidyverse)
library(docopt)

opt <- docopt(doc)

main <- function(filepath_raw, filepath_cleaned){
    ## Load the csv
    df <- read_csv(filepath_raw)

    # If you have columns you need to drop from your dataframe, try the following
    drop <- c("X1", "X2")
    df <- df[ , !(names(df) %in% drop)]
    ## Attribution https://stackoverflow.com/questions/4605206/drop-data-frame-columns-by-name

    # Three of our column names are mispelled (jundice -> jaundice, austim -> autism, and contry_of_res)
    # Look at the column names with: names(df)
    names(df)[14] <- "jaundice"
    names(df)[15] <- "autism"
    names(df)[16] <- "country_of_res"

    # Save our cleaned dataframe
    write_csv(df, path = filepath_cleaned)
}

main(opt$filepath_raw, opt$filepath_cleaned)