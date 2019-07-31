#### Sample Data Management Script for LTER Stomach Content ####

## Author: Jaxine Wolfe
## Date: 06-19-2019

## Note: This script will output a summary sheet from the input of raw diet data

# Load libraries
library(tidyverse)

# Set working directory
setwd("/Users/jaxinewolfe/Documents/Research/PEP/NESLTER/Data/LlopizLab/Abundance")


# Merging ITIS Validation -------------------------------------------------

namespace_path <- "/Users/jaxinewolfe/Documents/Research/PEP/NESLTER/Data/LlopizLab/Abundance/namespace_validation"
setwd(namespace_path)

# load lookup table from namespace validation to merge
itis_prey <- read_csv("Llopiz_resolved.csv")

# Load Justin data
# rename as diet_Justin
preytype_Justin <- read_csv("Justin_Forage_Fish_Diet_Data_2013_2015_Final_long.csv")
# Isolate and clean preytype
preytype_Justin$preytype <- trimws(gsub('([[:upper:]])', ' \\1',
                               preytype_Justin$preytype))
# repeat for Sarahs data
# rename as diet_Sarah
preytype_Sarah <- read_csv("Sarah_LTER201802StomachData_LTERFFSizes.csv")
preytype_Sarah$PreySpecies <- trimws(gsub('([[:upper:]])', ' \\1',
                              preytype_Sarah$PreySpecies))

# merge data
diet_Justin <- left_join(x = preytype_Justin, y = itis_prey, 
                          by=(c("preytype"="Llopiz_preytypes")))

diet_Sarah <- left_join(x = preytype_Sarah, y = itis_prey, 
                         by=(c("PreySpecies"="Llopiz_preytypes")))


# Real Data ---------------------------------------------------------------

# Load trial stomach content data
# Data is in long format
# I will be using the diet_Justin df

## TASK 1: GENERATE SUMMARY SHEETS
# NOTE: The smallest individual unit is Cruise_Station_FishSpecies
# These summary sheets can be exported as needed

# Generate summary sheet with prey totals per Cruise_Station_FishSpecies
sca_preytot <- diet_Justin %>%
  filter(count != "NA") %>%
  group_by(Cruise, Station, Species, resolved_higher_order_fromgnr) %>%
  # add prey items across fish from the same cruise and station
  summarize(PreyTotal = sum(count))

sca_percent <- sca_preytot %>%
  group_by(Species) %>%
  # add column for percent composition
  mutate(PreyPercent = (PreyTotal/sum(PreyTotal))*100)
# write.csv("LTER_SCA_percent.csv")

SEPALL_PCT <- SEPALL %>%
  group_by(taxa,vent) %>%
  mutate(percent = (count/sum(count))*100)

# Generate summary sheet with grand prey totals and richness
sca_summary <- sca_preytot %>%
  group_by(Cruise, Station, Species) %>%
  summarise(TotalCount = sum(PreyTotal),
            PreyRichness = length(unique(resolved_higher_order_fromgnr)))


## TASK 2: GENERATE SUMMARY ANALYSES
# ggplot(data = sca_preytot) +
#   geom_col(aes(x = Species, y = PreyTotal, fill = Species), 
#            position = position_dodge())

# Percent composition
# remember percentages are calculated for Cruise_Station_FishSpecies
ggplot(data = sca_percent, aes(Species, PreyPercent, fill = resolved_higher_order_fromgnr)) +
  geom_col() +
  # scale_fill_brewer(palette = "Set3") +
  labs(title = "Diet Composition Per Fish", x = "Fish Species", y = "Percent Composition") +
  theme_classic()
ggsave("RelAbund_total.jpg")


