setwd("~/Desktop/shiny SF airbnb")
library(readr)
#calendar <- read_csv("~/Desktop/shiny SF airbnb/calendar.csv")
#load("~/Desktop/shiny SF airbnb/.RData")
calendar$price <- gsub("[$,]","",calendar$price)
calendar$price <- as.numeric(calendar$price)

calendar$year = as.numeric(format(calendar$date, format = "%Y"))
calendar$month = as.numeric(format(calendar$date, format = "%m"))
calendar$day = as.numeric(format(calendar$date, format = "%d"))

library(dplyr)
month1718<-calendar %>% filter(available=='t') %>%
  group_by(month) %>%
  summarise(avg_pricemo=mean(price))

write_csv(month1718,"month.csv")
