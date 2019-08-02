# Relative Prey Abundance

This project uses an R Markdown file (Prey_Abundance.Rmd) to summarize and plot the relative prey abundance for fish species from each NES-LTER cruise. The output of this project generates plots of relative prey abundance for each fish and cruise.  

**NOTE:** Run *ITIS_Validation.Rmd* located in the [itis-validation folder](https://github.com/jaxinewolfe/LlopizLab/tree/master/Abundance/itis_validation) before running *Prey_Abundance.Rmd*

**Files in Directory:**

*Prey_Abundance.Rmd* is the active R Markdown script used to produce the relative prey abundance figures for fish species from each cruise

*itis_validation* is a folder containing the components used to resolve and validate the assigned prey types with ITIS 

*NESLTER_Diet_Taxa_2013_2015.csv* is the file output by *itis_validation* which contains NES-LTER fish stomach content data merged with taxonomic information used to bin prey types

*RelAbund_Cruise.pdf* are the relative abundance figures output from *Prey_Abundance.Rmd*

**Prerequisites:**
- Fish samples are subset for stomach content analysis from NOAA Fisheries cruises
- Stomach content data is collected and entered into a single sheet using data validation
- Data is converted to .csv for export to R Studio
- *ITIS_Validation.Rmd* (itis-validation folder) is run to validate taxa and assign categorical prey type bins

**Dependencies:**
- Internet
- Microsoft Excel
- R and Rstudio
- R studio packages
  - tidyverse

**Workflow:** (in progress)
- a Llopiz prey type list is assembled in R (combine Justin-long format- and Sarahs data sheets)
- the prey types are first run through ITIS_Validation.Rmd to resolve the names
- a lookup table is created to correct improper naming
- the resolved names and their appropriate groupings will be merged with the diet data from Justin or Sarah’s data
- the data is summarized and the abundance is graphed under the appropriate groupings