###############################################################
# 2013 and 2014 files
###############################################################
for(name in c("inst/extdata/aqm2013.csv", "inst/extdata/aqm2014.csv")){
  file <- read_csv(name, skip = 2,
                   na = c("", "NA", "NoData", "-999"),
                   col_names = FALSE,
                   col_types = "ccnnnnnnnnnnn")
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
