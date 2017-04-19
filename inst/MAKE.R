library("readr")
library("tabulizer")
library("dplyr")
library("tidyr")
library("lubridate")
library("ropenaq")
data_us <- NULL

source("inst/functions_pdf_transformation.R")
source("inst/pm25_consulate_2013_2014.R")
source("inst/pm25_consulate_2015.R")
source("inst/pm25_consulate_2016.R")

###############################################################
# save
###############################################################

data_us <- data_us %>%
  select(datetime,
         PM2.5_Delhi,
         PM2.5_Chennai,
         PM2.5_Kolkata,
         PM2.5_Hyderabad,
         PM2.5_Mumbai)  %>%
  gather("city", "conc",PM2.5_Delhi:PM2.5_Mumbai)
data_us <- data_us %>%
  mutate(city = gsub("PM2\\.5_", "", city)) %>%
  mutate(conc = as.numeric(conc))
pm25_india <- data_us
save(pm25_india, file = "data/pm25_india.RData", compress = "xz")
data_us <- mutate(data_us,
                  datetime = as.character(datetime))
write_csv(data_us, path = "inst/pm25USA.csv")

