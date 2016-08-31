context("usaqmindia_calendar")

test_that("The function returns a ggplot",{
  expect_is(usaqmindia_calendar(cityplot = "Chennai"), "ggplot")
})

test_that("The function returns an error if no city is provided",{
  expect_error(usaqmindia_calendar(), "Please provide a city for the plot")
})
