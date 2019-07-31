# LlopizLab

Use Case: Relative Abundance

Files:
- handwrittenSCA_6_17_2019SCan.pdf is the handwritten documentation of stomach content analysis for the 201802 Cruise
- RelAbund_? are the relative abundance figures produced by the script_abundance.R file
- script_abundance.R is the script used to produce the relative prey abundance figures for each cruise across fish species
- namespace_validation is a folder containing the components used to validate the prey types with ITIS

Flow: 
- a Llopiz prey type list is assembled in R (combine Justin-long format- and Sarahs data sheets)
- the prey types are first run through ITIS_validation.Rmd to resolve the names
- a lookup table is created to correct improper naming
- the resolved names and their appropriate groupings will be merged with the diet data from Justin or Sarah’s data
- the data is summarized and the abundance is graphed under the appropriate groupings