## global
library(readr)
library(shiny)
library(leaflet)
library(dplyr)
library(plotly)

#SFmap <- read_csv("~/Documents/*5500 Data Visualization/Assignment4/shiny SF airbnb/SFmap.csv")
#month <- read_csv("~/Documents/*5500 Data Visualization/Assignment4/shiny SF airbnb/month.csv")
#review <- read_csv("~/Documents/*5500 Data Visualization/Assignment4/shiny SF airbnb/review.csv")

#load("~/Desktop/shiny SF airbnb/.RData")

# variables
neighbourhood_cleansed <- c("Bayview", "Bernal Heights", "Castro/Upper Market", "Chinatown", 
              "Crocker Amazon", "Diamond Heights", "Downtown/Civic Center", 
              "Excelsior", "Financial District", "Glen Park", "Golden Gate Park",
              "Haight Ashbury", "Inner Richmond", "Inner Sunset", "Lakeshore", 
              "Marina", "Mission", "Nob Hill", "Noe Valley", "North Beach", 
              "Ocean View", "Outer Mission", "Outer Richmond", "Outer Sunset",
              "Pacific Heights", "Parkside", "Potrero Hill", "Presidio", "Presidio Heights",
              "Russian Hill", "Seacliff", "South of Market", "Treasure Island/YBI", 
              "Twin Peaks", "Visitacion Valley", "West of Twin Peaks", "Western Addition")

room_type <- c("Entire home/apt", "Private room", "Shared room")

groupColors <- colorFactor(c("#e01149", "#f6ff00","#2c07b2"),
                           domain = c("Entire home/apt", "Private room","Shared room"))
