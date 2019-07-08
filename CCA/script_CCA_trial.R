#### Canonical Correspondence Analysis of Fish Diets ####

## Date: 07-01-2019
## Authors: Justin Suca and Jaxine Wolfe

## Goal: Generate a CCA of the diet composition of each fish species per LTER cruise

# Background: 
# data are in proportions 
# sample data - Arctic cod 
# the df is split into a matrix of predictors and responses (diet proportions)
# any fish without any diet data, unknowns, other are removed

##------------------------------

# load necessary libraries
library(tidyverse)
library(CCA)
# library(car)
library(vegan)

setwd("D:/Arctic/Bsaida_Gut_Content_Data")
Bsaida_data <- read.csv("Bsaida_2017_CCA_190128.csv", header=TRUE)

# this transformation is common in diet studies for proportion 
trans.arcsine <- function(x){
  asin(sign(x) * sqrt(abs(x)))
}

# set your predictors (meta-data)
# fork length, longitude, and dept of 34.5 isohaline
Pred <- Bsaida_data[,1:3] 
# set your prey items 
Diet <- Bsaida_data[,4:12]
# transform your prey data 
DietArc <- trans.arcsine(Diet)

# CCA
# create a "full" model with all predictors 
# y ~ x 
# the dot means "any columns from data that are otherwise not used"
CCA_Bsaida <- cca(DietArc~., Pred)
# make a null model
mod0 <- cca(DietArc~1,Pred)
# perform a stepwise selection of predictors through permuatation tests against the null model
New_CCA <- step(mod0, scope = formula(CCA_Bsaida), test = "perm", perm.max = 100)

# plot the results 
tiff("B_saida_CCA_190201.tiff",width = 8, height = 6, res = 200, units = "in")
plot(New_CCA, display = c("sp","bp"), xlim = c(-2,3.5), ylim = c(-2,2))
dev.off() # returns the number and name of the new active device
anova(New_CCA)


## Trial CCA using Jutin's data ####

dietdata <- read_csv("Forage_Fish_Diet_Data_2013_2015_Final.csv")
dietdata[is.na(dietdata)] <- 0 # convert empties to 0

# Add columns for Day/Night, Season

# Aggregate data based on groupings of explanatory variables
dietagg <- dietdata %>%
  group_by(Cruise,Station_Depth,Region,Species) %>%
  summarise_at(vars(Centropages_spp:Unknown), sum) 
# Create species-specific data frame
dietsp <- dietagg %>% filter(Species == "P. triacanthus")

# isolate predictors 
predictors <- select(dietsp, c("Cruise", "Station_Depth", "Region"))
# isolate diet info
prey <- dietsp[,5:ncol(dietsp)]
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