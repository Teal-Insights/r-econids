## code to prepare `country_codes` dataset goes here
## TODO: Construct the dataset anew rather than downloading CSV

# Download the CSV from the specified URL and save to a temporary file
url <- paste0("https://raw.githubusercontent.com/t-emery/wbhelpr/",
              "refs/heads/master/data-raw/wb_countrycode.csv")
temp_file <- tempfile(fileext = ".csv")
download.file(url, destfile = temp_file)

# Read the downloaded CSV file
country_codes <- read.csv(temp_file, fileEncoding = "UTF-8")

# Clean up the temporary file
unlink(temp_file)

# Set encoding for character columns to UTF-8
char_cols <- sapply(country_codes, is.character)
country_codes[char_cols] <- lapply(country_codes[char_cols], function(col) {
  Encoding(col) <- "UTF-8"
  col
})

# Validate patterns using Perl Compatible Regular Expressions
lapply(country_codes$country_name_en_regex, function(pattern) {
  tryCatch(
    grep(pattern, "test", value = TRUE, perl = TRUE),
    error = function(e) {
      stop("Invalid regex pattern: ", pattern, "\nError: ", e$message)
    }
  )
})

# Helper functions for fetching data from the World Bank API
perform_request <- function(
  resource,
  per_page = 1000,
  progress = FALSE,
  base_url = "https://api.worldbank.org/v2/sources/6/"
) {
  validate_per_page(per_page)

  req <- create_request(base_url, resource, per_page)
  resp <- httr2::req_perform(req)

  if (is_request_error(resp)) {
    handle_request_error(resp)
  }

  body <- httr2::resp_body_json(resp)
  pages <- extract_pages(body)

  if (pages == 1L) {
    out <- extract_single_page_data(body)
  } else {
    out <- fetch_multiple_pages(req, pages, progress)
  }
  out
}

validate_per_page <- function(per_page) {
  if (
    !is.numeric(per_page) || per_page %% 1L != 0 ||
      per_page < 1L || per_page > 32500L
  ) {
    cli::cli_abort("{.arg per_page} must be an integer between 1 and 32,500.")
  }
}

create_request <- function(base_url, resource, per_page) {
  httr2::request(base_url) |>
    httr2::req_url_path_append(resource) |>
    httr2::req_url_query(format = "json", per_page = per_page) |>
    httr2::req_user_agent(
      "wbids R package (https://github.com/teal-insights/r-wbids)"
    )
}

is_request_error <- function(resp) {
  status <- httr2::resp_status(resp)
  if (status >= 400L) {
    return(TRUE)
  }
  body <- httr2::resp_body_json(resp)
  if (length(body) == 1L && length(body[[1L]]$message) == 1L) {
    return(TRUE)
  }
  FALSE
}

handle_request_error <- function(resp) {
  error_body <- check_for_body_error(resp)
  cli::cli_alert_danger(paste(error_body, collapse = "\n"))
}

check_for_body_error <- function(resp) {
  content_type <- httr2::resp_content_type(resp)
  if (identical(content_type, "application/json")) {
    body <- httr2::resp_body_json(resp)
    message_id <- body[[1]]$message[[1]]$id
    message_value <- body[[1]]$message[[1]]$value
    error_code <- paste("Error code:", message_id)
    docs <- paste0(
      "Read more at <https://datahelpdesk.worldbank.org/",
      "knowledgebase/articles/898620-api-error-codes>"
    )
    c(error_code, message_value, docs)
  }
}

extract_pages <- function(body) {
  if (length(body) == 2) {
    body[[1L]]$pages
  } else {
    body$pages
  }
}

extract_single_page_data <- function(body) {
  if (length(body) == 2) {
    body[[2L]]
  } else {
    body$source
  }
}

fetch_multiple_pages <- function(req, pages, progress) {
  resps <- req |>
    httr2::req_perform_iterative(
      next_req = httr2::iterate_with_offset("page"),
      max_reqs = pages,
      progress = progress
    )
  out <- resps |>
    purrr::map(function(x) {
      httr2::resp_body_json(x)$source
    })
  unlist(out, recursive = FALSE)
}

# Fetch the counterpart-area data from the World Bank API
counterparts_raw <- perform_request("counterpart-area")

# Extract the counterpart_id and counterpart_name from the counterpart-area data
counterparts_ids <- counterparts_raw[[1]]$concept[[1]]$variable |>
  dplyr::bind_rows() |>
  dplyr::select(counterpart_id = id,
                counterpart_name = value)

# Match counterpart ids to country codes using regex patterns
country_codes <- country_codes |>
  dplyr::mutate(
    # For each country, find matching counterpart_id using regex
    wb_counterpart_id = sapply(country_name_en_regex, function(pattern) {
      matches <- grep(pattern, counterparts_ids$counterpart_name,
                      ignore.case = TRUE, value = FALSE, perl = TRUE)
      if (length(matches) == 1) {
        counterparts_ids$counterpart_id[matches]
      } else {
        NA_integer_
      }
    })
  )

# TODO: We still have >100 counterpart regions, institutions, and countries
# without matches


# Save the dataset to an .rda file for export using usethis::use_data
usethis::use_data(country_codes, overwrite = TRUE)
