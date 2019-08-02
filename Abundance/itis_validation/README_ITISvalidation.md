# ITIS Taxonomic Validation

This project uses an R Markdown file (ITIS_Validation.Rmd) modified from [GitHub: WoRMs namespace_validation](https://github.com/klqi/EDI-NES-LTER-2019/tree/master/namespace_validation) to resolve, validate, and re-classify given prey species.It generates an output .csv file with the original and corrected information, using the ITIS database (primary) or NCBI (secondary). The resolved output of this project is merged with 2013-2015 diet data to assign categorical bins and used as input for the visualization of [relative prey abundance](https://github.com/jaxinewolfe/LlopizLab/tree/master/Abundance).

**NOTE:** If *Llopiz_preytypes.csv* and *Forage_Fish_Diet_Data_2013_2015_long.csv* already exists in this directory, do NOT run the unique_preytypes.R script. Instead, proceed directly to *ITIS_Validation.Rmd*.  

**Files in Directory:** 

*ITIS_Validation.Rmd* is the active R Markdown script used to query the global name resolver and ITIS to procure valid classifications for input names and bin taxa

*unique_preytypes.R* is a script that produces a vector of unique Llopiz prey type classifications

*LTER201802_StomachData_LTERFFSizes.csv* is input for *unique_preytypes.R*, which contains NES-LTER fish stomach content data in long format and is used to isolate unique prey types

*Forage_Fish_Diet_Data_2013_2015_wide.csv* is input for *unique_preytypes.R*, which will be converted to long format for the purpose of this project 

*Forage_Fish_Diet_Data_2013_2015_long.csv* is output from *unique_preytypes.R*, which contains NES-LTER fish stomach content data in long format and is used to isolate unique prey types

*Llopiz_preytypes.csv* contains the unique Llopiz prey type classifications output from *unique_preytypes.R*, which is input to *ITIS_Validation.Rmd*. (NOTE: This file was manually appended to include a column of prey types that were acceptable for ITIS and the global name resolver utilized by *ITIS_Validation.Rmd*).

*Llopiz_resolved.csv* is the file of validated prey types produced by *ITIS_Validation.Rmd*, which is merged with diet data and used to generate relative prey abundance (see *NESLTER_Diet_Taxa_2013_2015.csv* in the Abundance directory)

**Prerequisites:**
- Fish samples are subset for stomach content analysis from NOAA Fisheries cruises
- Stomach content data is collected and entered into a single sheet using data validation
- Data is converted to .csv for export to R Studio

**Dependencies:**
- Internet
- Microsoft Excel
- R and Rstudio
- R studio packages
  - taxize
  - plyr
  - dplyr
