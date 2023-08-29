#####################
### Load Packages ###
#####################

library(tidyverse)
library(gender)

######################
### Load File List ###
######################

file_list <- read_csv("data/biodiversity in Nobel prizes.csv")

#######################
### Gender Analysis ###
#######################

## First names

name_df <- file_list %>%
  filter(str_detect(string = doc_type,
                    pattern = "speech")) %>%
  select(full_name) %>%
  mutate(full_name = str_squish(full_name),
         first_name = str_extract(string = full_name,
                                  pattern = "^\\S+"))

## Ensure datasets are up to date

#install_genderdata_package()
#check_genderdata_package()

## Analyse gender

gender_df <- gender(names = name_df$first_name,
                    method = "genderize") %>%
  distinct()

out_df <- left_join(name_df,
                    gender_df,
                    by = c("first_name" = "name"))

#####################
### Write To File ###
#####################

write_csv(out_df,
          "outputs/recipient_assumed_gender.csv")
