#' Calculate death count by age and gender
#'
#' @param data [tibble][tibble::tibble-package] with RKI data
#' @param age age group of which the death count is calculated
#' @param sex sex of which the death count is calculated
#'
#' @return death count
death_count <- function(data, age, sex) {
  data %>%
    dplyr::filter(.data$NeuerTodesfall %in% c(0, 1),
                  .data$Geschlecht == sex,
                  .data$Altersgruppe == age) %>%
    dplyr::summarise(count = sum(.data$AnzahlTodesfall)) %>%
  .$count
  }

#' Calculate infection count by age and gender
#'
#' @param data [tibble][tibble::tibble-package] with RKI data
#' @param age age group of which the infection count is calculated
#' @param sex sex of which the infection count is calculated
#'
#' @return infection count
#'
infection_count <- function(data, age, sex) {
  data %>%
    dplyr::filter(.data$NeuerFall %in% c(0, 1),
                  .data$Geschlecht == sex,
                  .data$Altersgruppe == age) %>%
    dplyr::summarise(count = sum(.data$AnzahlFall)) %>%
  .$count
}

#' Calculate rate of death by age and gender
#'
#' @param data [tibble][tibble::tibble-package] with RKI data
#' @param age age group of which the rate of death is calculated
#' @param sex sex of which the rate of death is calculated
#'
#' @return rate of death
rate <- function(data, age, sex) {
  tot_inf <- infection_count(data, age, sex)
  tot_dead <- death_count(data, age, sex)
  tot_dead / tot_inf
}

#' Summarize deaths by gender and state
#'
#' Provides a tibble with the deaths for each state by gender based on
#' the given data.
#'
#' @param data [tibble][tibble::tibble-package] with RKI data
#'
#' @return a [tibble][tibble::tibble-package]
#' @export
#'
#' @examples
#' table_deaths_by_state(covrki)
table_deaths_by_state <- function(data) {
  data %>%
    dplyr::select(.data$Bundesland, .data$Geschlecht,
                  .data$AnzahlFall, .data$AnzahlTodesfall,
                  .data$NeuerFall, .data$NeuerTodesfall) %>%
    dplyr::group_by(.data$Bundesland, .data$Geschlecht) %>%
    dplyr::filter(.data$NeuerTodesfall %in% c(0, 1),
                  .data$Geschlecht %in% c("M", "W")) %>%
    dplyr::summarise(Todesfälle = sum(.data$AnzahlFall))
}

#' Summarize infections by gender and state
#'
#' Provides a tibble with the infections for each state by gender based on
#' the given data.
#'
#' @param data [tibble][tibble::tibble-package] with RKI data
#'
#' @return a [tibble][tibble::tibble-package]
#' @export
#'
#' @examples
#' table_infections_by_state(covrki)
table_infections_by_state <- function(data) {
  data %>%
    dplyr::select(.data$Bundesland, .data$Geschlecht,
                  .data$AnzahlFall, .data$AnzahlTodesfall,
                  .data$NeuerFall, .data$NeuerTodesfall) %>%
    dplyr::group_by(.data$Bundesland, .data$Geschlecht) %>%
    dplyr::filter(.data$NeuerFall %in% c(0, 1),
                  .data$Geschlecht %in% c("M", "W")) %>%
    dplyr::summarise(Infektionen = sum(.data$AnzahlFall))
}

#' Summarize rate of death by gender and state
#'
#' Provides a tibble with the rate of death for each state by gender based on
#' the given data.
#'
#' @param data [tibble][tibble::tibble-package] with RKI data
#'
#' @return a [tibble][tibble::tibble-package]
#' @export
#'
#' @examples
#' table_rate_of_deaths_by_state(covrki)
table_rate_of_deaths_by_state <- function(data) {
  tdf <- tibble::add_column(table_infections_by_state(data),
                            Todesfälle = table_deaths_by_state(data)$Todesfälle)
  tdf %>%
    dplyr::group_by(.data$Bundesland, .data$Geschlecht) %>%
    dplyr::summarise(Sterberate = .data$Todesfälle / .data$Infektionen)
}
