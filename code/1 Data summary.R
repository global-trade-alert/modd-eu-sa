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

### Irrelevant objective
case.base <- subset(case.base, !(objective %in% excl.objective))


### In the GTA reporting period
case.base$year.implemented <- str_extract(case.base$duration, "from \\d{2}.\\d{2}.\\d{4}")
case.base$year.implemented <- str_extract(case.base$year.implemented, "\\d{4}")
table(case.base$year.implemented)

str_extract_all(case.base$duration[2], "\\d{4}")

case.base$duration.years <- str_extract_all(case.base$duration, "\\d{4}")
# case.base$duration.years <- as.character(str_extract_all(case.base$duration, "\\d{4}"))

case.base$last.year <- NA
for(row in 1:nrow(case.base)){
  case.base$last.year[row] <- as.numeric(max(sapply(case.base$duration.years[row], max)))
}; rm(row)


case.base$last.year <- max(c(year(case.base$date.notified)), case.base$duration.years)

############################
#### Summary stas ##########
############################

objective.stat <- as.data.frame(table(case.base$objective))
objective.stat <- objective.stat[order(-objective.stat$Freq),]

test <- subset(case.base, objective == "SMEs")


instrument.stat <- as.data.frame(table(case.base$instrument))
instrument.stat <- instrument.stat[order(-instrument.stat$Freq),]

###############################
#### kamran data cleaning #####
###############################

#First replace all commas (only surrounded by digits) by decimal periods
case.budget$budget=gsub('([[:digit:]]),([[:digit:]])', '\\1.\\2', case.budget$budget)

Numextract <- function(string){
  return(paste(unlist(regmatches(string,gregexpr("[[:digit:]]+\\.*[[:digit:]]*",string))),collapse=';'))
}

for (i in 1:nrow(case.budget)){
  case.budget$budget.numbers[i]=Numextract(case.budget$budget[i])
}

case.budget$test= str_extract(case.budget$budget, '\\b[^GBP]+$')
case.budget$test= str_extract(case.budget$test, '\\b[^EUR]+$')



