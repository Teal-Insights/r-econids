# Load the dataset
data("standardized_geographies", package = "stdgeography")

test_that("standardized_geographies dataset has correct columns and no NAs", {
  # Check if the dataset has the required columns
  required_columns <- c("country_name", "country_group", "group_type")
  expect_true(all(required_columns %in% colnames(standardized_geographies)))

  # Check if there are no NAs in the dataset
  expect_true(all(complete.cases(standardized_geographies)))
})
