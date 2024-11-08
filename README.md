
<a href="https://teal-insights.github.io/r-econid"><img src="man/figures/logo.png" align="right" height="40" alt="r-econid website" /></a>

# econid

<!-- badges: start -->

[![R-CMD-check](https://github.com/Teal-Insights/r-econid/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/Teal-Insights/r-econid/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

## Installation

``` r
remotes::install_github("Teal-Insights/r-econid")
```

## Usage

``` r
library(econid)
head(country_aggregates)
```

    ##   country_name      country_group group_type
    ## 1    Australia Advanced Economies        IMF
    ## 2      Austria Advanced Economies        IMF
    ## 3      Belgium Advanced Economies        IMF
    ## 4       Canada Advanced Economies        IMF
    ## 5  Switzerland Advanced Economies        IMF
    ## 6       Cyprus Advanced Economies        IMF

``` r
head(country_codes)
```

    ##          country is_wb_country        wb_name  cldr_short_en iso2c iso3c iso3n
    ## 1    Afghanistan          TRUE    Afghanistan    Afghanistan    AF   AFG     4
    ## 2  Åland Islands         FALSE           <NA>  Åland Islands    AX   ALA   248
    ## 3        Albania          TRUE        Albania        Albania    AL   ALB     8
    ## 4        Algeria          TRUE        Algeria        Algeria    DZ   DZA    12
    ## 5 American Samoa          TRUE American Samoa American Samoa    AS   ASM    16
    ## 6        Andorra          TRUE        Andorra        Andorra    AD   AND    20
    ##   imf continent country_name_en_regex wb_counterpart_id
    ## 1 512      Asia                afghan               625
    ## 2  NA    Europe                 åland              <NA>
    ## 3 914    Europe               albania               071
    ## 4 612    Africa               algeria               130
    ## 5 859   Oceania  ^(?=.*americ).*samoa              <NA>
    ## 6  NA    Europe               andorra               025

## Development Workflow

### Create functions and tests

- `usethis::use_r(name=)` creates a pair of source and test files with
  the selected filename
- If the source file already exists and is open in your IDE, you can
  instead do `usethis::use_test()` to create an appropriately named test
  file

### Add dependencies

- `usethis::use_package(package)` adds the named package to DESCRIPTION
  dependencies
- `usethis::use_dev_package(package, type="Suggests")` adds a
  development dependency (won’t be installed for end-users)
- `pak::pkg_install("github::username/package")` to add a Github
  dependency (since
  `usethis::use_package(package, remote="github::username/package")`
  seems not to work, even though it should)
- `usethis::use_import_from(package, fun=)` adds a single function
  import to the roxygen2 docs

### Install and update dependencies

- `renv::init()` sets up the project’s file system for dependency
  management with renv
- `renv::install()` installs all dependencies listed in DESCRIPTION,
  *including Suggests/development dependencies*
- `renv::snapshot()` regenerates the lockfile to match currently
  installed dependencies, *excluding Suggests/development dependencies*
- `renv::update()` updates all package dependencies to latest versions
- `renv::restore()` installs all dependencies declared in the lockfile

### Add Data

- `usethis::use_data(some_dataframe, name="filename")` saves a data
  object to “data/filename.rda” for use as a package export
- `usethis::use_data_raw("dataset_name")` creates an empty R script in
  the “data-raw” directory—this is where you put any automation scripts
  that are used for generating/updating the exported dataset but that
  you *don’t* want to export to the end-user

### Add Documentation

- `usethis::use_vignette("vignette_name")` creates a new vignette
  template in the “vignettes” directory
- `usethis::use_article("article_name")` creates a new article template
  in the “vignettes/articles” directory
- `usethis::use_package_doc()` creates a package-level documentation
  file

### Build and Check Package

- `devtools::document()` generates documentation files from roxygen2
  comments
- `devtools::build_readme()` renders the .md README from the .Rmd README
- `devtools::build()` builds the package into a .tar.gz file
- `devtools::install()` installs the package locally
- `devtools::check()` runs R CMD check on the package
- `devtools::test()` runs all tests in the package

### Build Documentation

- `pkgdown::build_site()` builds a documentation website for the package
- `devtools::build_manual()` builds a PDF manual for the package
- `devtools::build_vignettes()` builds all vignettes in the package

### Increment Version

`usethis::use_version(which=NULL,push=NULL)` updates your package’s
version number in DESCRIPTION and commits the change.

- `which`: Controls which part of the version number to increment
  - “major”: First number (0.0.1 -\> 1.0.0)
  - “minor”: Second number (0.0.1 -\> 0.1.0)
  - “patch”: Third number (0.0.1 -\> 0.0.2)
  - “dev”: Adds development suffix (0.0.1 -\> 0.0.1.9000)
- `push`: When TRUE, automatically pushes the version bump commit to
  remote

### CRAN Submission

- `devtools::release()` guides you through the CRAN submission process
- Update `cran-comments.md` with any necessary explanations for CRAN
  maintainers
- Use `devtools::check_rhub()` to test on R-hub before submission
