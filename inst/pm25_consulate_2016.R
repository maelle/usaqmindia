
###############################################################
# 2016 files
###############################################################
file <- read_csv("inst/extdata/jan-2016.csv", skip = 5,
                 col_names = c("Date", "Time",
                               "PM2.5_Delhi", "PM2.5_Chennai",
                               "PM2.5_Kolkata", "PM2.5_Mumbai",
                               "PM2.5_Hyderabad"),
                 col_types = "ccnnnnn",
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
                                    "%Y-%m-%d I:M p")) %>%
  mutate(datetime = force_tz(datetime,
                             "Asia/Kolkata"))  %>%
  select(datetime, everything()) %>%
  select(- Date, - Time)

data_us <- bind_rows(data_us, file)

##########
file <- tbl_df(read.table("inst/extdata/aqifeb2016.csv", sep = ",",
                          skip = 0,
                          col.names = c("Date", "Time",
                                        "PM2.5_Delhi", "PM2.5_Chennai",
                                        "PM2.5_Kolkata", "PM2.5_Mumbai",
                                        "PM2.5_Hyderabad"),
                          fill = TRUE, na.strings = TRUE,
                          stringsAsFactors = FALSE))%>%
  mutate(PM2.5_Chennai = as.numeric(PM2.5_Chennai),
         PM2.5_Kolkata = as.numeric(PM2.5_Kolkata),
         PM2.5_Hyderabad = as.numeric(PM2.5_Hyderabad),
         PM2.5_Mumbai = as.numeric(PM2.5_Mumbai),
         PM2.5_Delhi = as.numeric(PM2.5_Delhi))

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
  select(- Date, - Time)

data_us <- bind_rows(data_us, file)

####
file <- read_csv("inst/extdata/aqmdatamarch2016.csv", skip = 5,
                 col_names = c("Date", "Time",
                               "PM2.5_Chennai", "PM2.5_Kolkata",
                               "PM2.5_Hyderabad", "PM2.5_Mumbai",
                               "PM2.5_Delhi"),
                 col_types = "ccnnnnn",
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
  select(datetime, everything())

data_us <- bind_rows(data_us, file)

######
file <- read_csv("inst/extdata/aqmapril2016.csv", skip = 5,
                 col_names = c("Date", "Time",
                               "PM2.5_Chennai", "PM2.5_Kolkata",
                               "PM2.5_Hyderabad", "PM2.5_Mumbai",
                               "PM2.5_Delhi"),
                 col_types = "ccnnnnn",
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
  select(- Date, - Time)

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
                                       "PM2.5_Delhi"))%>%
  mutate(PM2.5_Chennai = as.numeric(PM2.5_Chennai),
         PM2.5_Kolkata = as.numeric(PM2.5_Kolkata),
         PM2.5_Hyderabad = as.numeric(PM2.5_Hyderabad),
         PM2.5_Mumbai = as.numeric(PM2.5_Mumbai),
         PM2.5_Delhi = as.numeric(PM2.5_Delhi))


all_pm <- all_pm %>%
  mutate(datetime = seq(from = ymd_hms("2016-05-01 01:00:00", tz = "Asia/Kolkata"),
                        to = ymd_hms("2016-06-01 00:00:00", tz = "Asia/Kolkata"),
                        by = "1 hour"))
data_us <- bind_rows(data_us, all_pm)

#######
f <- "inst/extdata/aqm-june-2016.pdf"
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
                                       "PM2.5_Delhi"))%>%
  mutate(PM2.5_Chennai = as.numeric(PM2.5_Chennai),
         PM2.5_Kolkata = as.numeric(PM2.5_Kolkata),
         PM2.5_Hyderabad = as.numeric(PM2.5_Hyderabad),
         PM2.5_Mumbai = as.numeric(PM2.5_Mumbai),
         PM2.5_Delhi = as.numeric(PM2.5_Delhi))


all_pm <- all_pm %>%
  mutate(datetime = seq(from = ymd_hms("2016-06-01 01:00:00", tz = "Asia/Kolkata"),
                        to = ymd_hms("2016-07-01 00:00:00", tz = "Asia/Kolkata"),
                        by = "1 hour"))
data_us <- bind_rows(data_us, all_pm)



#######
f <- "inst/extdata/AQMJuly2016.pdf"
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
                                       "PM2.5_Delhi"))%>%
  mutate(PM2.5_Chennai = as.numeric(PM2.5_Chennai),
         PM2.5_Kolkata = as.numeric(PM2.5_Kolkata),
         PM2.5_Hyderabad = as.numeric(PM2.5_Hyderabad),
         PM2.5_Mumbai = as.numeric(PM2.5_Mumbai),
         PM2.5_Delhi = as.numeric(PM2.5_Delhi))


all_pm <- all_pm %>%
  mutate(datetime = seq(from = ymd_hms("2016-07-01 01:00:00", tz = "Asia/Kolkata"),
                        to = ymd_hms("2016-08-01 00:00:00", tz = "Asia/Kolkata"),
                        by = "1 hour"))
data_us <- bind_rows(data_us, all_pm)





