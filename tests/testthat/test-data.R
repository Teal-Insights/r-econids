# Load the dataset
data("country_aggregates", package = "economies")

test_that("country_aggregates dataset has correct columns and no NAs", {
  # Check if the dataset has the required columns
  required_columns <- c("country_name", "country_group", "group_type")
  expect_true(all(required_columns %in% colnames(country_aggregates)))

  # Check if there are no NAs in the dataset
  expect_true(all(complete.cases(country_aggregates)))
})

test_that("country_codes dataset has correct columns and no NAs", {
  # Check if the dataset has the required columns
  required_columns <- c("country", "is_wb_country", "wb_name", "cldr_short_en",
                        "iso2c", "iso3c", "iso3n", "imf", "continent",
                        "country_name_en_regex")
  expect_true(all(required_columns %in% colnames(country_codes)))
})
