# Demo Project - Autism Spectrum Disorder Screening

This is a demo project for STAT 547 so you know the level of detail we are expecting. 

The HTML version of the report can be found [here](https://stat547-ubc-2019-20.github.io/demo_project/docs/milestone2-547-example.html)

This will continue to update throughout the course and important changes will be marked by a release.

## Usage

Below are the steps to reproduce the analysis in this document:

1. [load.R](https://github.com/STAT547-UBC-2019-20/demo_project/blob/master/src/load.R): Loads the data file into a CSV.

2. [clean.R](https://github.com/STAT547-UBC-2019-20/demo_project/blob/master/src/clean.R): Cleans the data.

3. [eda.R](https://github.com/STAT547-UBC-2019-20/demo_project/blob/master/src/eda.R): Performs exploratory data analysis.

4. [knit.R](https://github.com/STAT547-UBC-2019-20/demo_project/blob/master/src/knit.R): Knits the .Rmd file into pdf and html files.

To replicate this analysis, clone this repository, navigate to the `src` folder in your terminal, and type in the following commands:

```
Rscript src/load.R --filepath="data/autism.csv" --url_to_read="https://github.com/STAT547-UBC-2019-20/data_sets/raw/master/Autism-Adult-Data.arff"

Rscript src/clean.R --filepath_raw="data/autism.csv" --filepath_cleaned="data/autism_cleaned.csv"

Rscript src/eda.R --filepath_cleaned="data/autism_cleaned.csv"

Rscript src/knit.R --finalreport="docs/finalreport.Rmd"
```

## Acknowledgements

The report was initially created by Matthew Connell and originated as a DSCI 522 team project by Thomas Pin and Tejas Phaterpekar, Matthew Connell - [Autism Spectrum Disorder Screening Machine Learning Analysis](https://github.com/UBC-MDS/522-Workflows-Group-414).
