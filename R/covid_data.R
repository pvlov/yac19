#' Filter tibble with RKI data by date
#'
#' This function can be used to restrict a tibble with the data by RKI to
#' the specified time range.
#'
#' @param data Tibble with data
#' @param from_date From date (inclusive) in YYYYMMDD format
#' @param to_date To date (inclusive) in YYYYMMDD format
#'
#' @return a filtered [tibble][tibble::tibble-package]
#' @export
#'
#' @examples
#' filter_date(covrki, 20210101, 20210131)
filter_date <- function(data, from_date, to_date) {
  fdunix <- as.numeric(as.POSIXct(lubridate::ymd(from_date)))
  tdunix <- as.numeric(as.POSIXct(lubridate::ymd(to_date)))

  data %>% dplyr::filter(.data$Meldedatum >= fdunix, .data$Meldedatum <= tdunix)
}

#' Helper function to obtain the json from RKI API
#'
#' @param from_date Start date of data in YYYYMMDD format
#' @param to_date End date of data in YYYYMMDD format
#' @param out_fields Columns to include in response
#'
#' @return a [response][httr::response] to the HTTP GET request to the API
rki_json <- function(from_date, to_date, out_fields = "*") {
  date_query <- paste0("Meldedatum >= TIMESTAMP '",
                       lubridate::ymd(from_date),
                       " 00:00:00' ",
                       "AND Meldedatum <= TIMESTAMP '",
                       lubridate::ymd(to_date),
                       " 00:00:00'")
  ofields <- paste0(out_fields, collapse = ",")
  query <- list(where = date_query, time = "", resultType = "standard",
                outFields = ofields, outSR = 4326, f = "json")
  httr::GET("https://services7.arcgis.com",
            path = "mOBPykOjAyBO2ZKk/arcgis/rest/services/RKI_COVID19/FeatureServer/0/query",
            query = query,
            httr::accept_json())
}

#' Download data from RKI
#'
#' This downloads all data about COVID-19 infections in Germany from the RKI.
#' This should include data from January 1st, 2020 up to the current date (if
#' the pandemic is still ongoing). Unfortunately, the API caps the response at
#' 32000 rows which effectively makes this function only useful if you are
#' interested in data spanning one or two days.
#'
#' @param from_date Start date (inclusive) of data in YYYYMMDD format
#' @param to_date End date (inclusive) of data in YYYYMMDD format
#' @param out_fields Columns to include in response
#'
#' @return a [tibble][tibble::tibble-package] containing the requested data
#' @export
#'
#' @examples
#' rki_fetch(20210115, 20210115, c("Altersgruppe", "Geschlecht", "AnzahlFall",
#'                                 "AnzahlTodesfall", "Meldedatum", "NeuerFall",
#'                                 "NeuerTodesfall"))
rki_fetch <- function(from_date, to_date, out_fields = "*") {
  jdata <- rki_json(from_date, to_date, out_fields)
  data <- jsonlite::fromJSON(rawToChar(jdata$content))
  tibble::tibble(data$features$attributes)
}



#' Download all available data from RKI
#'
#' This downloads all data about COVID-19 infections in Germany from the RKI.
#' This should include data from January 1st, 2020 up to the current date (if
#' the pandemic is still ongoing).
#'
#' @return a [tibble][tibble::tibble-package] containing all data
#' @export
rki_fetch_all <- function() {
  print("Downloading and parsing all data. This may take a while...")
  jdata <- httr::GET("https://opendata.arcgis.com/datasets/dd4580c810204019a7b8eb3e0b329dd6_0.geojson")
  data <- jsonlite::fromJSON(rawToChar(jdata$content))
  tibble::tibble(data$features$properties) %>%
    dplyr::mutate(Meldedatum = as.numeric(as.POSIXct(.data$Meldedatum))) %>%
    dplyr::select(-dplyr::one_of("ObjectId"))
}
