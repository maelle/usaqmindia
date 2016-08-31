usaqmindia
==========

[![Build Status](https://travis-ci.org/masalmon/usaqmindia.svg?branch=master)](https://travis-ci.org/masalmon/usaqmindia) [![Build status](https://ci.appveyor.com/api/projects/status/lujc2gn88smyvhrq?svg=true)](https://ci.appveyor.com/project/masalmon/usaqmindia) [![codecov.io](https://codecov.io/github/masalmon/usaqmindia/coverage.svg?branch=master)](https://codecov.io/github/masalmon/usaqmindia?branch=master)

The U.S. Embassy and Consulates General in India maintain an air quality monitoring program with on-site measuring instruments and put the corresponding data [on this website](http://newdelhi.usembassy.gov/airqualitydata.html). There are csv files for 2013 and 2014, for 2015 except December which is in a pdf, and various csv/pdf for the months of the beginning of 2016.

In this repository I have made a copy of these files and provide a R code for wrangling them to get a single csv with all measures for Delhi, Mumbai, Kolkata, Hyderabad and Chennai. Refer to original source for licensing questions.

*Useful even for non R users: You will find the raw data [in this folder](inst/extdata) and my wrangling code is [here](inst/pm25_consulate.R). The resulting csv is [here](inst/pm25USA.csv). I will try to update the repository as new data comes in on the embassy website.*

I have made a R package out of the data so that my fellow R users can easily play with the data. The package imports [`ggTimeSeries`](https://github.com/Ather-Energy/ggTimeSeries) for doing the calendar plot. It can be installed this way:

``` r
devtools::install_github("Ather-Energy/ggTimeSeries")
devtools::install_github("masalmon/usaqmindia")
```

The data is in a long format:

``` r
library("usaqmindia")
library("dplyr")
data("pm25_india")
pm25_india %>% head(n = 20) %>% knitr::kable()
```

| datetime            | city  |   conc|
|:--------------------|:------|------:|
| 2013-01-01 01:00:00 | Delhi |  324.4|
| 2013-01-01 02:00:00 | Delhi |  366.8|
| 2013-01-01 03:00:00 | Delhi |  290.7|
| 2013-01-01 04:00:00 | Delhi |  245.4|
| 2013-01-01 05:00:00 | Delhi |  220.3|
| 2013-01-01 06:00:00 | Delhi |  180.2|
| 2013-01-01 07:00:00 | Delhi |  140.0|
| 2013-01-01 08:00:00 | Delhi |  125.0|
| 2013-01-01 09:00:00 | Delhi |  111.0|
| 2013-01-01 10:00:00 | Delhi |  112.0|
| 2013-01-01 11:00:00 | Delhi |  129.4|
| 2013-01-01 00:00:00 | Delhi |  184.1|
| 2013-01-01 01:00:00 | Delhi |  284.8|
| 2013-01-01 02:00:00 | Delhi |  372.3|
| 2013-01-01 03:00:00 | Delhi |  456.7|
| 2013-01-01 04:00:00 | Delhi |  404.8|
| 2013-01-01 05:00:00 | Delhi |  328.1|
| 2013-01-01 06:00:00 | Delhi |  274.4|
| 2013-01-01 07:00:00 | Delhi |  285.0|
| 2013-01-01 08:00:00 | Delhi |  354.9|

Below is an example plot of concentrations (see the code [here](R/redo_plot.R)). Check out the Diwali peaks!

``` r
library("usaqmindia")
usaqmindia_plot()
```

![](README_files/figure-markdown_github/unnamed-chunk-3-1.png)

And this is a calendar plot of daily median concentrations in one city using the [`ggTimeSeries`](https://github.com/Ather-Energy/ggTimeSeries) package (see the code [here](R/calendar.R)):

``` r
usaqmindia_calendar(cityplot = "Delhi")
```

![](README_files/figure-markdown_github/unnamed-chunk-4-1.png)
