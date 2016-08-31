context("usaqmindia_plot")

test_that("The function returns a ggplot",{
  expect_is(usaqmindia_plot(), "ggplot")
})
