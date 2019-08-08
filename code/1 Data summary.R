library(gtalibrary)
library(lubridate)
library(stringr)

rm(list = ls())

gta_setwd()

load("8 Data dumps/EU state aid/data/EU SA case by case.Rdata")


##############################
#### Excluded settings #######
##############################

excl.objective <- c("Aid for culture and heritage conservation (Art. 53)",
                    "Culture")
years <- 2009:lubridate::year(Sys.Date())


#####################################
#### Throwing out obvious misses ####
#####################################
str_extract_all(case.base$duration[2], "\\d{4}")

case.base$duration.years <- str_extract_all(case.base$duration, "\\d{4}")
case.base$last.year <- max(c(year(case.base$date.notified)), case.base$duration.years)

############################
#### Summary stas ##########
############################

objective.stat <- as.data.frame(table(case.base$objective))
objective.stat <- objective.stat[order(-objective.stat$Freq),]


instrument.stat <- as.data.frame(table(case.base$instrument))
instrument.stat <- instrument.stat[order(-instrument.stat$Freq),]

