#' Standardized Country and Aggregate Mappings to IMF and World Bank Areas
#'
#' A dataset containing geographic groupings mapped to area names used by the
#' IMF and World Bank.
#'
#' @format A data frame with 2587 rows and 3 columns:
#' \describe{
#'   \item{country_name}{Standardized country name}
#'   \item{country_group}{Standardized aggregate name}
#'   \item{group_type}{Either "IMF" or "World Bank"}
#' }
#' @source \url{https://github.com/t-emery/sais-susfin_data/blob/main/datasets/
#' imf_wb_country_groups.csv}
"country_aggregates"

#' Country Data with ISO Codes and World Bank Information
#'
#' A dataset containing country information, including ISO codes and World Bank
#' status.
#'
#' @format A data frame with columns:
#' \describe{
#'   \item{country}{Country name}
#'   \item{is_wb_country}{Logical indicating if the country is recognized by the
#'      World Bank}
#'   \item{wb_name}{World Bank name for the country}
#'   \item{cldr_short_en}{CLDR short name for the country}
#'   \item{iso2c}{ISO 3166-1 alpha-2 code}
#'   \item{iso3c}{ISO 3166-1 alpha-3 code}
#'   \item{iso3n}{ISO 3166-1 numeric code}
#'   \item{imf}{IMF code}
#'   \item{continent}{Continent name}
#'   \item{country_name_en_regex}{Standardized country name}
#' }
#' @source \url{https://github.com/t-emery/wbhelpr/blob/master/data-raw/
#' wb_countrycode.csv}
"country_codes"
