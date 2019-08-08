# Standardizing NES-LTER Data Entry and Analysis

This project uses an R Markdown file (LTER_Format.Rmd) to load a single-sheet, long-format XLSX dataset containing prey count and size data for each fish dissected from the 201802 trawl survey. The data entered from this sheet have been validated in Microsoft Excel using a prey type lookup table adjacent to the raw data sheet. The output of this project generates plots of relative prey abundance and mean prey size for each fish and cruise.

**Prerequisites:**
- Fish samples are subset for stomach content analysis from NOAA Fisheries cruises
- Stomach content data is collected and entered into a single sheet using data validation

**Dependencies:**
- Internet
- Microsoft Excel
- R and Rstudio
- R studio packages
  - tidyverse
  - readxl

### Files in Directory:
- *handwrittenSCA_6_17_2019SCan.pdf* is a scanned example of the handwritten diet data before its input into a spreadsheet

**Scripts:**
- *LTER_Format.Rmd* is the active R Markdown script used to produce the relative prey abundance and mean prey size figures for fish species from each cruise

**Input:**
- *LTER_SCA_trialdata.xslx* input file which contains NES-LTER fish stomach content data with prey counts and lengths

**Output:**
- *RelAbund_Cruise.pdf* are the relative abundance figures output from *LTER_Format.Rmd*
- *MeanPreySize_fish.pdf* are the mean prey size figures output from *LTER_Format.Rmd* for each fish species
