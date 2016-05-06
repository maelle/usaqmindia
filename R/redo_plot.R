#' Re-do the time series plot for all cities
#'
#' @import ggplot2
#' @import ggiraph
#' @importFrom dplyr group_by "%>%" summarize
#'
#' @return a ggplot graph
#' @export
#'
#' @examples
#' p <- redo_plot()
#' ggiraph::ggiraph(code = {print(p)})
redo_plot <- function(){
  utils::data("pm25_india", package = "usaqmindia", envir = environment())
  p <- pm25_india %>%
    group_by(day = as.Date(datetime), city) %>%
               summarize(conc = mean(conc, na.rm = TRUE)) %>%
               ggplot() +
      geom_point_interactive(aes(day, conc,
                                 tooltip = paste(round(conc, digits = 2), as.character(day)))) +
      facet_grid(city ~ ., scales = "free_y") +
      ggtitle("US Air Quality Monitoring in India")+
      ylab(expression(paste("Daily average PM2.5 concentration (", mu, "g/",m^3,")")))
  p
}
