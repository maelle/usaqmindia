#' Re-do the time series plot for all cities
#'
#' @import ggplot2
#' @import viridis
#'
#' @return a ggplot graph
#' @export
#'
#' @details For clarity a few values of 2000 are not shown for Delhi and Hyderabad.
#'
#' @examples
#' usaqmindia_plot()
usaqmindia_plot <- function(){
  utils::data("pm25_india", package = "usaqmindia", envir = environment())

  p <- ggplot(dplyr::filter_(pm25_india,
                             lazyeval::interp(~conc < 1500))) +
    geom_vline(xintercept = as.numeric(lubridate::ymd_hms("2013 11 03 20 00 00",
                                                          tz = "Asia/Kolkata"))) +
    geom_vline(xintercept = as.numeric(lubridate::ymd_hms("2014 10 23 20 00 00",
                                                          tz = "Asia/Kolkata"))) +
    geom_vline(xintercept = as.numeric(lubridate::ymd_hms("2015 11 11 20 00 00",
                                                          tz = "Asia/Kolkata"))) +
      geom_point(aes_string("datetime", "conc", col = "city")) +
      facet_grid(city ~ ., scales = "free_y") +
      ggtitle("US Air Quality Monitoring in India",
              subtitle = "The vertical lines represent 8pm on Diwali each year.")+
      ylab(expression(paste("PM2.5 hourly concentration (", mu, "g/",m^3,")")))+
      scale_x_datetime(date_labels = "%Y-%b-%d",
                 date_breaks = "2 month")+
    theme(axis.text.x = element_text(angle = 45, hjust = 1))+
    theme(strip.text.y = element_text(size = 16, angle = 0)) +
    scale_color_viridis(discrete = TRUE)+
    theme(legend.position = "none")+
    xlab("Local time")

  p
}
