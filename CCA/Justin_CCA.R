#### Canonical Correspondence Analysis of Fish Diets ####

## Date: 07-01-2019
## Authors: Justin Suca and Jaxine Wolfe

## Goal: Generate a CCA of the diet composition of each fish species per LTER cruise

# Overview: 
# Data is merged from fisheries datasets to define daynight and season explanatory vars
# prey counts are converted proportions 
# the df is split into a matrix of predictors and responses (diet proportions)
# any fish without any diet data, unknowns, other are removed

# This script requires a folder of fisheries trawl data and the SCA data

# Setup -------------------------------------------------------------------

rm(list = ls())

# load necessary libraries
library(tidyverse)
library(CCA)
library(lubridate)
library(vegan)
library(stringr)
library(maptools)

# Data Wrangling ----------------------------------------------------------

# set working directory
setwd("/Users/jaxinewolfe/Documents/Research/PEP/NESLTER/Data/LlopizLab/CCA")

# load necessary dataset
dietdata <- read_csv("Forage_Fish_Diet_Data_2013_2015_Final.csv")
dietdata[is.na(dietdata)] <- 0 # convert empties to 0

## Wide to Long Conversion ##

diet.long <- dietdata %>%
  gather(preytype,count,Centropages_spp:Unknown,factor_key = TRUE) %>%
  filter(count != 0)
# write.csv(diet.long, "Forage_Fish_Diet_Data_2013_2015_Final_long.csv")

## Merging Fisheries Cruise data files ##
# Combine spring and fall cruise datasets to be merged with the diet data

setwd("/Users/jaxinewolfe/Documents/Research/PEP/NESLTER/Data/LlopizLab/CCA/FSCSTables_SVSTA/")
# create list of files in the working directory
file_list <- list.files()
# Define columns to be extracted from fisheries data
FSCScols <- c("CRUISE6", "STATION", "EST_YEAR", "EST_MONTH", "EST_DAY", "EST_TIME",
              "GMT_YEAR", "GMT_MONTH", "GMT_DAY", "GMT_TIME", "SURFTEMP", "BOTTEMP")

# Creates merged dataset from the fisheries data
for (i in 2:length(file_list)){

    FSCSdataset <- read.csv(file_list[1], header = TRUE) %>%
      select(FSCScols)
  
    # create temporary dataset to ammend the FSCSdataset
    temp_dataset <-read.csv(file_list[i], header = TRUE) %>%
      select(FSCScols)
    FSCSdataset <- rbind(FSCSdataset, temp_dataset[, colnames(FSCSdataset)])
    FSCSdataset[is.na(FSCSdataset)] <- "NA" # convert empties to NA
    rm(temp_dataset)
}


## Merging Diet and Cruise Datasets ##

# Prep to merge: Standardize the character layout for time

# Adjust Time column of dietdata: convert to %H:%M format
# Rewrite time column in diet dataset
dietdata$Time <- format(as.POSIXct(str_pad(dietdata$Time, 4, pad = "0"), 
                                   format="%H%M", origin = ""), "%H:%M")
# Do the same for the fisheries data
# FSCSdataset$EST_TIME <- format(as.POSIXct(str_pad(FSCSdataset$EST_TIME, 8, pad = "0"), 
                                          # format = "%H:%M:%S", origin = ""), "%H:%M")

# Merge datasets
# use unique to remove duplicate rows
diet_join <- unique(left_join(x = dietdata, y = FSCSdataset, 
                       by = c("Cruise" = "CRUISE6", "Station" = "STATION")))

# isolate missing fisheries cruise_stations
missing <- diet_join[is.na(diet_join$EST_DAY),]
write_csv(missing,"FISHERIES_MIA.csv")

# add column with datetime
diet_join$GMT_datetime <- with(diet_join, ymd_hms(paste(GMT_YEAR, GMT_MONTH, GMT_DAY, GMT_TIME, sep= ' '),
                                             tz = "GMT"))
diet_join$EST_datetime <- with(diet_join, ymd_hms(paste(EST_YEAR, EST_MONTH, EST_DAY, EST_TIME, sep= ' '),
                                                  tz = "EST"))
# eliminate rows with NA for datetime (25 total)
diet_join <- diet_join[complete.cases(diet_join[ , "GMT_datetime"]),]


## Calculating Day and Night ##

# function creates a vector indicating day vs. night based on sunrise and sunset
# requires that data frame have Longitude, Latitude, and datetime columns
daynight <- function(x) {
  crds <- SpatialPoints(matrix(c(x$Longitude, x$Latitude), ncol = 2, byrow = TRUE),
                        proj4string=CRS("+proj=longlat +datum=WGS84"))
  ts <- x$EST_datetime
  sunrise <- sunriset(crds, ts, POSIXct.out = TRUE,
                           direction = "sunrise")$time
  sunset <- sunriset(crds, ts, POSIXct.out = TRUE,
                               direction = "sunset")$time
  # use 'ifelse'  to create vector indicating day vs. night based on sunrise and sunset
  day_night <- ifelse(ts >= sunrise & ts <= sunset,
                   yes = "Day", no = "Night")
  print(sunrise)
  print(sunset)

  return(day_night)
}

# add daynight column to dataset in order to compare observations
diet_join$day_night <- daynight(diet_join)
diet_join <- diet_join[complete.cases(diet_join[ , "day_night"]),]

# isolate missing fisheries cruise_stations
# mia_daynight <- diet_final[is.na(diet_final$day_night),]
# write_csv(mia_daynight, "daynight_NAs.csv")

## Define Seasons ##
diet_join$seasons <- ifelse((diet_join$EST_MONTH == 3 | diet_join$EST_MONTH == 4 |
                            diet_join$EST_MONTH == 5), yes = "Spring", no = "Fall")


# Canonical Correspondence Analysis ---------------------------------------

# Aggregate data based on groupings of explanatory variables
dietsp <- diet_join %>%
  group_by(Region,day_night, seasons, Station_Depth,SURFTEMP,BOTTEMP) %>%
  # Create species-specific data frame
  filter(Species == "A. aestivalis") %>%
  summarise_at(vars(Centropages_spp:Unknown), sum) 
# %>%
#   mutate(preytotal = rowSums(.[,"Centropages_spp":ncol(.)]), na.rm = TRUE)

# & day_night != "NA"
  # mutate(preytotal = rowSums(select(.,"Centropages_spp":"Unknown")), na.rm = TRUE)

# this transformation is common in diet studies for proportion 
trans.arcsine <- function(x){
  asin(sign(x) * sqrt(abs(x)))
}

# isolate predictors 
predictors <- select(dietsp, c("Region","day_night","seasons","Station_Depth", "SURFTEMP","BOTTEMP"))
# isolate diet info
prey <- dietsp[,7:ncol(dietsp)]
# create vector of prey count totals per row
preytotal <- rowSums(prey)
# convert counts to proportions
preyprop <- prey/preytotal
preyprop[preyprop == "NaN"] <- 0
# transform proportions using arcsin
preyarc <- trans.arcsine(preyprop)

# CCA
# create a "full" model with all predictors 
# y ~ x 
# the dot means "any columns from data that are otherwise not used"
# Note: none of the rowsums can equal zero
CCA_full <- cca(preyarc~., predictors)
# make a null model
CCA_null <- cca(preyarc~1,predictors)
# perform a stepwise selection of predictors through permuatation tests against the null model
CCA_final <- step(CCA_null, scope = formula(CCA_full), test = "perm", perm.max = 100)

# plot the results
# tiff("B_saida_CCA_190201.tiff",width = 8, height = 6, res = 200, units = "in")
plot(CCA_final, display = c("sp","bp"))
dev.off() # returns the number and name of the new active device
anova(New_CCA)

# I left out prey categories that averaged less than 5% by number  in the diet of each species
