#####################
### Load Packages ###
#####################

library(pdftools)
library(rvest)
library(microbenchmark)
library(tidyverse)
library(stringi)
library(quanteda)

##########################
### Load Species Names ###
##########################

## From Catalogue of Life
### https://www.catalogueoflife.org/data/download

names <- read_tsv("C:/Users/wilko/Downloads/test/NameUsage.tsv") %>%
  select(`col:scientificName`,
         `col:rank`,
         `col:genericName`,
         `col:infragenericEpithet`,
         `col:specificEpithet`,
         `col:infraspecificEpithet`,
         `col:cultivarEpithet`)

###################
### Scrape Text ###
###################

## PDF - normal

text_pdf <- pdftools::pdf_text("C:/Users/wilko/Downloads/press-medicine2022.pdf")

## PDF - Optical Character Recognition

text_pdf_ocr <- pdftools::pdf_ocr_text("C:/Users/wilko/Downloads/press-medicine2022.pdf")

## From Web

webpage <- read_html("https://www.nobelprize.org/prizes/medicine/2022/press-release/")

text_web <- html_text(html_nodes(webpage, "article"))

###########################
### Basic Text Cleaning ###
###########################

text_pdf <- text_pdf %>%
  str_squish()

text_pdf_ocr <- text_pdf_ocr %>%
  str_squish()

text_web <- text_web %>%
  str_squish()

#######################
### Create Patterns ###
#######################

## Test pattern of length:100 + "Homo" genus known to exist in text

pattern_test <- na.omit(c(unique(names$`col:genericName`)[1:98], "Homo", "sapiens"))

## Larger benchmark pattern 0f 10,000 Genus

pattern_all <- na.omit(unique(names$`col:genericName`))

########################
### Pattern Matching ###
########################

## Extract matches + context (Test subset only)

context_pdf_test <- kwic(tokens(text_pdf),
                         pattern = pattern_test)

context_pdf_ocr_test <- kwic(tokens(text_pdf_ocr),
                        pattern = pattern_test)

context_web_test <- kwic(tokens(text_web),
                    pattern = pattern_test)

## Extract matches + context (Everything)

context_pdf_full <- kwic(tokens(text_pdf),
                    pattern = pattern_all)

context_pdf_ocr_full <- kwic(tokens(text_pdf_ocr),
                             pattern = pattern_all)

context_web_full <- kwic(tokens(text_web),
                         pattern = pattern_all,
                         )

## Check what patterns matched
### Lots of false positives with tiny patterns
### Suggest we probably need to filter out anything
### less than 4 characters long, or we'll have lots of
### manual post-processing to do

context_pdf_full$pattern

context_pdf_ocr_full$pattern

context_web_full$pattern
context_web_full$pre

##########################
### Benchmarking Tests ###
##########################

## All patterns + context

microbenchmark(kwic(tokens(text_pdf),
                    pattern = pattern_all),
               times = 100)

microbenchmark(kwic(tokens(text_pdf_ocr),
                    pattern = pattern_all),
               times = 100)

microbenchmark(kwic(tokens(text_web),
                    pattern = pattern_all),
               times = 100)

