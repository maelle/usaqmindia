usaqmindia
==========

The U.S. Embassy and Consulates General in India maintain an air quality monitoring program with on-site measuring instruments and put the corresponding data [on this website](http://newdelhi.usembassy.gov/airqualitydata.html). There are csv files for 2013 and 2014, for 2015 except December which is in a pdf, and various csv/pdf for the months of the beginning of 2016.

In this repository I have made a copy of these files and provide a R code for wrangling them to get a single csv with all measures for Delhi, Mumbai, Kolkata, Hyderabad and Chennai. Refer to original source for licensing questions.

You will find the raw data [in this folder](inst/extdata) and my wrangling code is [here](inst/pm25_consulate.R). The resulting csv is [here](inst/pm25USA.csv).

I have made a R package out of the data so that my fellow R users can easily play with the data.

The data is in a long format:

``` r
library("usaqmindia")
library("dplyr")
data("pm25_india")
pm25_india %>% head(n = 20) %>% knitr::kable()
```

| datetime | city  |   conc|
|:---------|:------|------:|
| NA       | Delhi |  324.4|
| NA       | Delhi |  366.8|
| NA       | Delhi |  290.7|
| NA       | Delhi |  245.4|
| NA       | Delhi |  220.3|
| NA       | Delhi |  180.2|
| NA       | Delhi |  140.0|
| NA       | Delhi |  125.0|
| NA       | Delhi |  111.0|
| NA       | Delhi |  112.0|
| NA       | Delhi |  129.4|
| NA       | Delhi |  184.1|
| NA       | Delhi |  284.8|
| NA       | Delhi |  372.3|
| NA       | Delhi |  456.7|
| NA       | Delhi |  404.8|
| NA       | Delhi |  328.1|
| NA       | Delhi |  274.4|
| NA       | Delhi |  285.0|
| NA       | Delhi |  354.9|

Here is an example plot of concentrations (see the code [here](R/redo_plot.R)):

``` r
library("usaqmindia")
usaqmindia_plot()
```

![](README_files/figure-markdown_github/unnamed-chunk-2-1.png)

And this is a calendar plot of daily median concentrations in one city using the [`ggTimeSeries`](https://github.com/Ather-Energy/ggTimeSeries) package (see the code [here](R/calendar.R)):

``` r
usaqmindia_calendar(cityplot = "Chennai")
```

![](README_files/figure-markdown_github/unnamed-chunk-3-1.png)
