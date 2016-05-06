#' Re-do the time series plot for all cities
#'
#' @import ggplot2
#'
#' @return a ggplot graph
#' @export
#'
#' @examples
#' usaqmindia_plot()
usaqmindia_plot <- function(){
  utils::data("pm25_india", package = "usaqmindia", envir = environment())
  p <- ggplot(pm25_india) +
      geom_point(aes(datetime, conc)) +
      facet_grid(city ~ ., scales = "free_y") +
      ggtitle("US Air Quality Monitoring in India")+
      ylab(expression(paste("PM2.5 concentration (", mu, "g/",m^3,")")))
  p
}
