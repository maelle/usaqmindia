usaqmindia
==========

The U.S. Embassy and Consulates General in India maintain an air quality monitoring program with on-site measuring instruments and put the corresponding data [on this website](http://newdelhi.usembassy.gov/airqualitydata.html). There are csv files for 2013 and 2014, for 2015 except December which is in a pdf, and various csv for the months of the beginning of 2016.

In this repository I have made a copy of these files and provide a R code for wrangling them to get a single csv with all measures for Delhi, Mumbai, Kolkata, Hyderabad and Chennai. Refer to original source for licensing questions.

You will find the raw data [in this folder](inst/extdata) and my wrangling code is [here](inst/pm25_consulate.R). The resulting csv is [here](inst/pm25USA.csv).

I have made a R package out of the data so that my fellow R users can easily play with the data.

``` r
library("usaqmindia")
library("ggplot2")
library("dplyr")
data(pm25_india)
knitr::kable(head(pm25_india))
```

| datetime            | city  |   conc|
|:--------------------|:------|------:|
| 2013-01-01 01:00:00 | Delhi |  324.4|
| 2013-01-01 02:00:00 | Delhi |  366.8|
| 2013-01-01 03:00:00 | Delhi |  290.7|
| 2013-01-01 04:00:00 | Delhi |  245.4|
| 2013-01-01 05:00:00 | Delhi |  220.3|
| 2013-01-01 06:00:00 | Delhi |  180.2|

``` r
ggplot(pm25_india) +
  geom_point(aes(datetime, conc)) +
  facet_grid(city ~ .) +
  ggtitle("US Air Quality Monitoring in India")+
  ylab(expression(paste("PM2.5 concentration (", mu, "g/",m^3,")")))
```

![](README_files/figure-markdown_github/unnamed-chunk-1-1.png)<!-- -->
