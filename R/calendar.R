#' Calendar plot for one city
#'
#' @import ggTimeSeries
#' @import viridis
#'
#' @importFrom dplyr "%>%" filter_ group_by summarize
#' @importFrom lazyeval interp
#'
#' @param cityplot the city, "Delhi", "Chennai", "Kolkata", "Hyderabad", "Mumbai".
#' @details For clarity a few values of 2000 are not shown for Delhi and Hyderabad.
#' @return
#' @export
#'
#' @examples
#' usaqmindia_calendar(cityplot = "Chennai")
usaqmindia_calendar <- function(cityplot = NULL){
  utils::data("pm25_india", package = "usaqmindia", envir = environment())
  pm25day <- dplyr::filter_(pm25_india,
                            lazyeval::interp(~conc < 1500)) %>%
    filter_(lazyeval::interp(~ city == cityplot)) %>%
    filter_(lazyeval::interp(~ !is.na(datetime))) %>%
    group_by(day = as.Date(datetime)) %>%
    summarize(conc = median(conc, na.rm = TRUE))
  # base plot
  p1 <- ggTimeSeries::ggplot_calendar_heatmap(
    pm25day,
    'day',
    'conc'
  )

  # adding some formatting
  p1 +
    xlab(NULL) +
    ylab(NULL)+
    scale_fill_viridis(option = "plasma",
                       limit = c(0, max(pm25day$conc)))  +
    facet_wrap(~Year, ncol = 1) +
    ggtitle(paste0("PM2.5 concentrations calendar for ", cityplot))
}
