#### Sample Data Management Script for LTER Stomach Content ####

## Author: Jaxine Wolfe
## Date: 06-19-2019

## Note: This script will output a summary sheet from the input of raw diet data

# Load libraries
library(tidyverse)

# Set working directory
setwd("/Users/jaxinewolfe/Documents/Research/PEP/NESLTER/FOLFE")

# Load trial stomach content data
# Data is in long format
sca <- read_csv("LTER_SCA_trialdata.csv")
str(sca)

## TASK 1: GENERATE SUMMARY SHEETS
# NOTE: The smallest individual unit is Cruise_Station_FishSpecies
# These summary sheets can be exported as needed

# Generate summary sheet with prey totals per Cruise_Station_FishSpecies
sca_preytot <- sca %>%
  filter(PreyCount != "NA") %>%
  group_by(Cruise, Station, FishSpecies, PreySpecies) %>%
  # add prey items across fish from the same cruise and station
  summarize(PreyTotal = sum(PreyCount))

sca_percent <- sca_preytot %>%
  group_by(FishSpecies) %>%
  # add column for percent composition
  mutate(PreyPercent = (PreyTotal/sum(PreyTotal))*100)
# write.csv("LTER_SCA_percent.csv")

# Generate summary sheet with grand prey totals and richness
sca_summary <- sca_preytot %>%
  group_by(Cruise, Station, FishSpecies) %>%
  summarise(TotalCount = sum(PreyTotal),
            PreyRichness = length(unique(PreySpecies)))


## TASK 2: GENERATE SUMMARY ANALYSES
ggplot(data = sca_preytot) +
  geom_col(aes(x = FishSpecies, y = PreyTotal, fill = PreySpecies), 
           position = position_dodge())

# Percent composition
# remember percentages are calculated for Cruise_Station_FishSpecies
ggplot(data = sca_percent, aes(FishSpecies, PreyPercent, fill = PreySpecies)) +
  geom_col() +
  # scale_fill_brewer(palette = "Set3") +
  labs(title = "Diet Composition Per Fish", x = "Fish Species", y = "Percent Composition") +
  theme_classic()
