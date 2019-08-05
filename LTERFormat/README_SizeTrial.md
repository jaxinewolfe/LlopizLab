# CCA for Stomach Content

This project uses an R Markdown file (CCA_Diet.Rmd) to conduct a canonical correspondence analysis (CCA) on the diets of fish species across multiple NES-LTER cruises. It merges date and temperature information from Fisheries datasets (FSCSTables_SVSTA) to assemble explanatory variables and converts prey counts to proportions for CCA. The output of this project is then generated in the form of CCA summaries and plots for distinct fish species, describing the relationship between their diets and the explanatory variables assigned.  

**Files in Directory:**

*CCA_Diet.Rmd* is the active R Markdown script used to produce the CCA for each cruise

*Forage_Fish_Diet_Data_2013_2015_wide.csv* input file which contains NES-LTER fish stomach content data in wide format

*FSCSTables_SVSTA* is a folder accessed by *CCA_Diet.Rmd* which contains spreadsheet documentation of Spring and Fall NOAA Fisheries cruises

*FISHERIES_MIA.csv* output file which contains a subset of the 2013-2015 fish diet dataset where there were no corresponding stations in the fisheries dataset

*map_Walsh_etal_2015_NE_Regions.png* is a map of the Fisheries stratum zonation of the Northeast Shelf

*cca_fish.pdf* are the CCA figures output from *CCA_Diet.Rmd* for each fish species

**Prerequisites:**
- Fish samples are subset for stomach content analysis from NOAA Fisheries cruises
- Stomach content data is collected and entered into a single sheet using data validation
- Data is converted to .csv for export to R Studio

**Dependencies:**
- Internet
- Microsoft Excel
- R and Rstudio
- R studio packages
  - tidyverse
  - CCA
  - lubridate
  - vegan
  - stringr
  - maptools
