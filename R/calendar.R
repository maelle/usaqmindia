#' Calendar plot for one city (daily median concentration)
#'
#' @import ggTimeSeries
#' @import viridis
#' @importFrom stats median
#'
#' @importFrom dplyr "%>%" filter_ group_by summarize
#' @importFrom lazyeval interp
#'
#' @param cityplot the city, "Delhi", "Chennai", "Kolkata", "Hyderabad", "Mumbai".
#' @details For clarity a few values of 2000 are not shown for Delhi and Hyderabad.
#' @return a ggplot graph
#' @export
#'
#' @examples
#' usaqmindia_calendar(cityplot = "Chennai")
usaqmindia_calendar <- function(cityplot = NULL){
  if(is.null(cityplot)){
    stop("Please provide a city for the plot, \'Delhi\', \'Chennai\', \'Kolkata\', \'Hyderabad\', or \'Mumbai\'.")
  }

  utils::data("pm25_india", package = "usaqmindia", envir = environment())
  pm25day <- dplyr::filter_(pm25_india,
                            lazyeval::interp(~conc < 1500)) %>%
    dplyr::filter_(lazyeval::interp(~ city == cityplot)) %>%
    dplyr::filter_(lazyeval::interp(~ !is.na(datetime))) %>%
    dplyr::group_by_(day = lazyeval::interp(~as.Date(datetime))) %>%
    dplyr::summarize_(conc = lazyeval::interp(~median(conc, na.rm = TRUE)))
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
