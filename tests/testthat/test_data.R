context("pm25_india")

test_that("Test that the data seems correct", {
  data("pm25_india")
  expect_is(pm25_india, "tbl_df")
  expect_true(all(names(pm25_india) == c("datetime", "city", "conc")))
  expect_true(all(unique(pm25_india$city) == c("Delhi", "Chennai", "Kolkata", "Hyderabad", "Mumbai" )))
  expect_equal(sum(is.na(pm25_india$datetime)), 0)
  expect_is(pm25_india$datetime, "POSIXct")
  expect_is(pm25_india$city, "character")
  expect_is(pm25_india$conc, "numeric")
})
