
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

#######
f <- "inst/extdata/AQMmay2016.pdf"
out1 <- extract_tables(f)
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

all_pm <- all_pm %>%
  mutate(datetime = seq(from = ymd_hms("2016-05-01 01:00:00", tz = "Asia/Kolkata"),
                        to = ymd_hms("2016-06-01 00:00:00", tz = "Asia/Kolkata"),
                        by = "1 hour"))
data_us <- bind_rows(data_us, all_pm)






