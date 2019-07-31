# LlopizLab

Use Case: CCA

Files:
- FISHERIES_MIA.csv contains the observations in the Forage fish dataset (2013-15) where there were no corresponding stations in the fisheries dataset
- FSCSTables_SVSTA is a folder with the fisheries documentation of Spring and Fall cruises
- Forage_Fish_Diet_Data_2013_2015_Final_Justin.xslx and Forage_Fish_Diet_Data_2013_2015_wide are the identical Excel and .csv files containing fish stomach content in wide format
- map_Walsh_etal_2015_NE_Regions.png is a map of the Fisheries zonation of the NES
- script_CCA.R is the script used to produce the CCA for each cruise

Flow:
- Fisheries data is merged with the diet data (Justin) to add date  time information and columns of explanatory variables