# author: Diana Lin
# date: Mar 10, 2020

# Phony because it is not a real 'target'/'file'
.PHONY: all clean

# final products of the make
all: docs/finalreport.html docs/finalreport.pdf

# use load.R to fetch csv from internet
data/autism.csv: src/load.R
	Rscript src/load.R --filepath="data/autism.csv" --url_to_read="https://github.com/STAT547-UBC-2019-20/data_sets/raw/master/Autism-Adult-Data.arff"

# use clean.R to clean csv and write new one
data/autism_cleaned.csv: data/autism.csv src/clean.R 
	Rscript src/clean.R --filepath_raw="data/autism.csv" --filepath_cleaned="data/autism_cleaned.csv"

# use eda.R to plot data in cleaned csv
images/barplot.png images/propbarplot.png images/correlation.png: data/autism_cleaned.csv src/eda.R 
	Rscript src/eda.R --filepath_cleaned="data/autism_cleaned.csv"
	
# use the final report Rmd file to knit final report along with plots
docs/finalreport.pdf docs/finalreport.html: docs/finalreport.Rmd src/knit.R images/barplot.png images/propbarplot.png images/correlation.png
	Rscript src/knit.R --finalreport="docs/finalreport.Rmd"

# Delete all files that are produced by make all
clean:
	rm -f data/*
	rm -f images/*
	rm -f docs/*.md
	rm -f docs/*.html