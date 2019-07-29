## Calculating Day and Night ##

# set working directory
wd <- "your working directory"
setwd(wd)

# load necessary data
d <- read.csv("daynight_NAs.csv", header = TRUE)

# function creates a vector indicating day vs. night based on sunrise and sunset
# requires that data frame have Longitude, Latitude, and datetime columns
daynight <- function(x) {
  crds <- SpatialPoints(matrix(c(x$Longitude, x$Latitude), ncol = 2, byrow = TRUE),
                        proj4string=CRS("+proj=longlat +datum=WGS84"))
  ts <- x$GMT_datetime
  sunrise <- sunriset(crds, ts, POSIXct.out = TRUE,
                      direction = "sunrise")$time
  sunset <- sunriset(crds, ts, POSIXct.out = TRUE,
                     direction = "sunset")$time
  # use 'ifelse'  to create vector indicating day vs. night based on sunrise and sunset
  daynight <- ifelse(ts >= sunrise & ts <= sunset,
                     yes = "Day", no = "Night")
  print(sunrise)
  print(sunset)
  return(daynight)
}

