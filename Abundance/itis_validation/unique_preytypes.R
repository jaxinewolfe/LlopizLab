#### Data Manipulation for ITIS Validation ####

# This script generates a lookup table of the Llopiz preytype names

rm(list = ls())

# load library
library(tidyverse)

# -------------------------------------------------------------------------

# Wide-to-long diet data conversion

# set working directory
my_path <- "/Users/jaxinewolfe/Documents/Research/PEP/NESLTER/Data/LlopizLab/Abundance/itis_validation"
setwd(my_path)

# load necessary dataset
dietdata <- read_csv("Forage_Fish_Diet_Data_2013_2015_wide.csv")
dietdata[is.na(dietdata)] <- 0 # convert empties to 0

diet.long <- dietdata %>%
  gather(preytype,count, Centropages_spp:Unknown, factor_key = TRUE) %>%
  filter(count != 0) # can be modified to filter out unwanted prey items
# write.csv(diet.long, "Forage_Fish_Diet_Data_2013_2015_long.csv")

# NOTE: Wrap the following code into a function
# Load 2013-2015 diet data
preytype_Justin <- read.csv("Forage_Fish_Diet_Data_2013_2015_long.csv", 
                            header = TRUE) %>% select(preytype)
# Isolate and clean preytype columns
preytype_Justin <- trimws(gsub('([[:upper:]])', ' \\1',
                               unique(preytype_Justin$preytype)))

# Load 201802 Cruise diet data
preytype_Sarah <- read.csv("LTER201802_StomachData_LTERFFSizes.csv", 
                           header = TRUE) %>% select(PreySpecies)
preytype_Sarah <- trimws(gsub('([[:upper:]])', ' \\1',
                              unique(preytype_Sarah$PreySpecies)))

# merge unique Llopiz preytypes
Llopiz_preytypes <- unique(c(preytype_Justin,preytype_Sarah))
# write_csv(as.data.frame(Llopiz_preytypes),
#           path = file.path(my_path, "Llopiz_preytypes.csv"))

# NOTE: manually added a preytype_validated column for ease of GNR

