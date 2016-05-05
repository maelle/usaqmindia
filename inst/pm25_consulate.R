library("readr")
library("tabulizer")
library("dplyr")
library("tidyr")
library("lubridate")

data_us <- NULL

###############################################################
# 2013 and 2014 files
###############################################################
for(name in c("inst/extdata/aqm2013.csv", "inst/extdata/aqm2014.csv")){
  file <- read_csv(name, skip = 2,
                   na = c("", "NA", "NoData", "-999"),
                   col_names = FALSE)
  file <- file[2:nrow(file), 1:12]
  names(file) <- c("Date", "Time",
                   "PM2.5_Delhi", "PM2.5_Delhi_AQI", "PM2.5_Chennai", "PM2.5_CHN_AQI",
                   "PM2.5_Kolkata", "PM2.5_KOL_AQI", "PM2.5_Mumbai", "PM2.5_MUM_AQI",
                   "PM2.5_Hyderabad", "PM2.5_HYD_AQI")

  which24 <- which(grepl("24:00 AM", file$Date))

  file <- file %>%
    mutate(Time = ifelse(grepl("24:00 AM", Date),
                         "12:00 AM", Time)) %>%
    mutate(Date = dmy(gsub(" 24:00 AM", "", Date)))

  file$Date[which24] <- file$Date[which24] + days(1)

  file <- file %>%
    filter(!is.na(Date)) %>%
    mutate(datetime = paste(as.character(Date), Time)) %>%
    mutate(datetime = parse_date_time(datetime,
                                      "%Y-%m-%d I:M p",
                                      tz = "Asia/Kolkata")) %>%
    select(datetime, everything()) %>%
    select(- Date, - Time)

  data_us <- bind_rows(data_us, file)
}

###############################################################
# 2015 csv file for january to november
###############################################################
file <- read_csv("inst/extdata/jan-nov2015.csv", skip = 5,
                 col_names = c("Date", "Time",
                               "PM2.5_Delhi", "PM2.5_Chennai",
                               "PM2.5_Kolkata", "PM2.5_Mumbai",
                               "PM2.5_Hyderabad"),
                 na = c("", "NA", "NoData", "-999",
                        "---", "InVld", "PwrFail"))

which24 <- which(grepl("24:00 AM", file$Date))

file <- file %>%
  mutate(Time = ifelse(grepl("24:00 AM", Date),
                       "12:00 AM", Time)) %>%
  mutate(Date = dmy(gsub(" 24:00 AM", "", Date)))

file$Date[which24] <- file$Date[which24] + days(1)

file <- file %>%
  filter(!is.na(Date)) %>%
  mutate(datetime = paste(as.character(Date), Time)) %>%
  mutate(datetime = parse_date_time(datetime,
                                    "%Y-%m-%d I:M p",
                                    tz = "Asia/Kolkata")) %>%
  select(datetime, everything()) %>%
  select(- Date, - Time) %>%
  mutate(PM2.5_Delhi = as.character(PM2.5_Delhi)) %>%
mutate(PM2.5_Chennai = as.character(PM2.5_Chennai)) %>%
  mutate(PM2.5_Kolkata = as.character(PM2.5_Kolkata)) %>%
  mutate(PM2.5_Mumbai = as.character(PM2.5_Mumbai)) %>%
  mutate(PM2.5_Hyderabad = as.character(PM2.5_Hyderabad))

data_us <- bind_rows(data_us, file)
###############################################################
# 2015 file for december is a pdf, yikee
###############################################################

# f <- "inst/extdata/jan-dec_2015.pdf"
# out1 <- extract_tables(f)
# save(out1, file = "inst/extdata/us_data.RData")
load("inst/extdata/us_data.RData")

# functions for transforming the output
# look at the pdf, missing are shifted to the left which is a nightmare
colle_tout <- function(ligne){
  temp <- ligne[1:length(ligne)][ligne[1:length(ligne)] != ""]
  if(length(temp) == 6){
    temp <- temp[2:6]
  }
  toString(temp)
}
transform_tableau <- function(frame){
  as.data.frame(apply(frame, 1, colle_tout))
}

# apply said functions
all_pm <- bind_rows(lapply(out1, transform_tableau))
names(all_pm) <- "name"
# now separate
all_pm <- all_pm %>% separate(col = name,
                              sep = ",",
                              into = c("PM2.5_Chennai",
                                       "PM2.5_Kolkata",
                                       "PM2.5_Hyderabad",
                                       "PM2.5_Mumbai",
                                       "PM2.5_Delhi"))

# we now have to translate missing
all_pm <- all_pm %>%
  mutate(PM2.5_Chennai = ifelse(grepl("---", PM2.5_Chennai), "NA", PM2.5_Chennai)) %>%
  mutate(PM2.5_Kolkata = ifelse(grepl("---", PM2.5_Kolkata), "NA", PM2.5_Kolkata)) %>%
  mutate(PM2.5_Hyderabad = ifelse(grepl("---", PM2.5_Hyderabad), "NA", PM2.5_Hyderabad)) %>%
  mutate(PM2.5_Mumbai = ifelse(grepl("---", PM2.5_Mumbai), "NA", PM2.5_Mumbai)) %>%
  mutate(PM2.5_Delhi = ifelse(grepl("---", PM2.5_Delhi), "NA", PM2.5_Delhi))%>%
  mutate(PM2.5_Chennai = ifelse(grepl("PwrFail", PM2.5_Chennai), "NA", PM2.5_Chennai)) %>%
  mutate(PM2.5_Kolkata = ifelse(grepl("PwrFail", PM2.5_Kolkata), "NA", PM2.5_Kolkata)) %>%
  mutate(PM2.5_Hyderabad = ifelse(grepl("PwrFail", PM2.5_Hyderabad), "NA", PM2.5_Hyderabad)) %>%
  mutate(PM2.5_Mumbai = ifelse(grepl("PwrFail", PM2.5_Mumbai), "NA", PM2.5_Mumbai)) %>%
  mutate(PM2.5_Delhi = ifelse(grepl("InVld", PM2.5_Delhi), "NA", PM2.5_Delhi))%>%
  mutate(PM2.5_Chennai = ifelse(grepl("InVld", PM2.5_Chennai), "NA", PM2.5_Chennai)) %>%
  mutate(PM2.5_Kolkata = ifelse(grepl("InVld", PM2.5_Kolkata), "NA", PM2.5_Kolkata)) %>%
  mutate(PM2.5_Hyderabad = ifelse(grepl("InVld", PM2.5_Hyderabad), "NA", PM2.5_Hyderabad)) %>%
  mutate(PM2.5_Mumbai = ifelse(grepl("InVld", PM2.5_Mumbai), "NA", PM2.5_Mumbai)) %>%
  mutate(PM2.5_Delhi = ifelse(grepl("---", PM2.5_Delhi), "NA", PM2.5_Delhi))

# now find the corresponding times
# not that easy since part of the pdf is unreadable
horaire <- function(ligne){
  parse_date_time(ligne[1],
                  "%d%m%Y %I:%M %p",
                  tz = "Asia/Kolkata")
}
horaire_tableau <- function(frame){
  as.data.frame(apply(frame, 1, horaire))
}
times_us <- bind_rows(lapply(out1, horaire_tableau))
names(times_us) <- "datetime"
times_us <- times_us %>%
  mutate(datetime = as.POSIXct(datetime, origin = "1970-01-01", tz = "Asia/Kolkata"))

all_pm <-  cbind(all_pm, times_us)
names(all_pm)[6] <- "datetime"
first_interesting <- max(which(month(all_pm$datetime) == 11))+2
all_pm <- all_pm[first_interesting:nrow(all_pm),]
all_pm$datetime <- seq(from = ymd_hms("2015-12-01 01:00:00", tz = "Asia/Kolkata"),
                       to = ymd_hms("2016-01-01 00:00:00", tz = "Asia/Kolkata"),
                       by = "1 hour")
data_us <- bind_rows(data_us, all_pm)

###############################################################
# 2016 files
###############################################################
file <- read_csv("inst/extdata/jan-2016.csv", skip = 5,
                 col_names = c("Date", "Time",
                               "PM2.5_Delhi", "PM2.5_Chennai",
                               "PM2.5_Kolkata", "PM2.5_Mumbai",
                               "PM2.5_Hyderabad"),
                 na = c("", "NA", "NoData", "-999",
                        "---", "InVld", "PwrFail"))

which24 <- which(grepl("24:00 AM", file$Date))

file <- file %>%
  mutate(Time = ifelse(grepl("24:00 AM", Date),
                       "12:00 AM", Time)) %>%
  mutate(Date = dmy(gsub(" 24:00 AM", "", Date)))

file$Date[which24] <- file$Date[which24] + days(1)

file <- file %>%
  filter(!is.na(Date)) %>%
  mutate(datetime = paste(as.character(Date), Time)) %>%
  mutate(datetime = parse_date_time(datetime,
                                    "%Y-%m-%d I:M p",
                                    tz = "Asia/Kolkata")) %>%
  select(datetime, everything()) %>%
  select(- Date, - Time) %>%
  mutate(PM2.5_Delhi = as.character(PM2.5_Delhi)) %>%
  mutate(PM2.5_Chennai = as.character(PM2.5_Chennai)) %>%
  mutate(PM2.5_Kolkata = as.character(PM2.5_Kolkata)) %>%
  mutate(PM2.5_Mumbai = as.character(PM2.5_Mumbai)) %>%
  mutate(PM2.5_Hyderabad = as.character(PM2.5_Hyderabad))

data_us <- bind_rows(data_us, file)

##########
file <- tbl_df(read.table("inst/extdata/aqifeb2016.csv", sep = ",",
                            skip = 0,
                     col.names = c("Date", "Time",
                                   "PM2.5_Delhi", "PM2.5_Chennai",
                                   "PM2.5_Kolkata", "PM2.5_Mumbai",
                                   "PM2.5_Hyderabad"),
                     fill = TRUE, na.strings = TRUE,
                     stringsAsFactors = FALSE))
file <- file[2:nrow(file),]

which24 <- which(grepl("24:00 AM", file$Time))

file <- file %>%
  mutate(Time = ifelse(grepl("24:00 AM", Time),
                       "12:00 AM", Time)) %>%
  mutate(Date = dmy(Date))

file$Date[which24] <- file$Date[which24] + days(1)

file <- file %>%
  filter(!is.na(Date)) %>%
  mutate(datetime = paste(as.character(Date), Time)) %>%
  mutate(datetime = parse_date_time(datetime,
                                    "%Y-%m-%d I:M p",
                                    tz = "Asia/Kolkata")) %>%
  select(datetime, everything()) %>%
  select(- Date, - Time) %>%
  mutate(PM2.5_Delhi = as.character(PM2.5_Delhi)) %>%
  mutate(PM2.5_Chennai = as.character(PM2.5_Chennai)) %>%
  mutate(PM2.5_Kolkata = as.character(PM2.5_Kolkata)) %>%
  mutate(PM2.5_Mumbai = as.character(PM2.5_Mumbai)) %>%
  mutate(PM2.5_Hyderabad = as.character(PM2.5_Hyderabad))

data_us <- bind_rows(data_us, file)

####
file <- read_csv("inst/extdata/aqmdatamarch2016.csv", skip = 5,
                 col_names = c("Date", "Time",
                               "PM2.5_Chennai", "PM2.5_Kolkata",
                               "PM2.5_Hyderabad", "PM2.5_Mumbai",
                               "PM2.5_Delhi"),
                 na = c("", "NA", "NoData", "-999",
                        "---", "InVld", "PwrFail"))

which24 <- which(grepl("24:00 AM", file$Date))

file <- file %>%
  mutate(Time = ifelse(grepl("24:00 AM", Date),
                       "12:00 AM", Time)) %>%
  mutate(Date = dmy(gsub(" 24:00 AM", "", Date)))

file$Date[which24] <- file$Date[which24] + days(1)

file <- file %>%
  filter(!is.na(Date)) %>%
  mutate(datetime = paste(as.character(Date), Time)) %>%
  mutate(datetime = parse_date_time(datetime,
                                    "%Y-%m-%d I:M p",
                                    tz = "Asia/Kolkata")) %>%
  select(datetime, everything()) %>%
  select(- Date, - Time) %>%
  mutate(PM2.5_Delhi = as.character(PM2.5_Delhi)) %>%
  mutate(PM2.5_Chennai = as.character(PM2.5_Chennai)) %>%
  mutate(PM2.5_Kolkata = as.character(PM2.5_Kolkata)) %>%
  mutate(PM2.5_Mumbai = as.character(PM2.5_Mumbai)) %>%
  mutate(PM2.5_Hyderabad = as.character(PM2.5_Hyderabad))

data_us <- bind_rows(data_us, file)

######
file <- read_csv("inst/extdata/aqmapril2016.csv", skip = 5,
                 col_names = c("Date", "Time",
                               "PM2.5_Chennai", "PM2.5_Kolkata",
                               "PM2.5_Hyderabad", "PM2.5_Mumbai",
                               "PM2.5_Delhi"),
                 na = c("", "NA", "NoData", "-999",
                        "---", "InVld", "PwrFail"))

which24 <- which(grepl("24:00 AM", file$Date))

file <- file %>%
  mutate(Time = ifelse(grepl("24:00 AM", Date),
                       "12:00 AM", Time)) %>%
  mutate(Date = dmy(gsub(" 24:00 AM", "", Date)))

file$Date[which24] <- file$Date[which24] + days(1)

file <- file %>%
  filter(!is.na(Date)) %>%
  mutate(datetime = paste(as.character(Date), Time)) %>%
  mutate(datetime = parse_date_time(datetime,
                                    "%Y-%m-%d I:M p",
                                    tz = "Asia/Kolkata")) %>%
  select(datetime, everything()) %>%
  select(- Date, - Time) %>%
  mutate(PM2.5_Delhi = as.character(PM2.5_Delhi)) %>%
  mutate(PM2.5_Chennai = as.character(PM2.5_Chennai)) %>%
  mutate(PM2.5_Kolkata = as.character(PM2.5_Kolkata)) %>%
  mutate(PM2.5_Mumbai = as.character(PM2.5_Mumbai)) %>%
  mutate(PM2.5_Hyderabad = as.character(PM2.5_Hyderabad))

data_us <- bind_rows(data_us, file)

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
write_csv(data_us, path = "inst/pm25USA.csv")
pm25_india <- data_us
save(pm25_india, file = "data/pm25_india.RData")






