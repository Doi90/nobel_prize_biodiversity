#####################
### Load Packages ###
#####################

library(pdftools)
library(rvest)
library(tidyverse)
library(quanteda)

##########################
### Load Species Names ###
##########################

## From Catalogue of Life
### https://www.catalogueoflife.org/data/download

names <- read_tsv("data/NameUsage.tsv") %>%
  select(`col:scientificName`,
         `col:rank`,
         `col:genericName`,
         `col:infragenericEpithet`,
         `col:specificEpithet`,
         `col:infraspecificEpithet`,
         `col:cultivarEpithet`)

######################
### Load File List ###
######################

file_list <- read_csv("data/biodiversity in Nobel prizes.csv") %>%
  split(seq(nrow(.)))

#######################
### Create Patterns ###
#######################

patterns <- na.omit(c(unique(names$`col:genericName`),
                      unique(names$`col:specificEpithet`)))

patterns <- patterns[!grepl(x = patterns,
                           pattern = "\\(|\\)")]

patterns <- unique(tolower(patterns))

###################
### Scrape Text ###
###################

source("scripts/scrape_function.R")

lapply(file_list,
       scrape_analysis,
       patterns)
