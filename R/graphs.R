#' Help function to calculate points for plot function
#'
#' @param data [tibble][tibble::tibble-package]
#' @param age Range of age
#' @param number_timesteps Width of domain
#' @param days Number of days over which we will take the average
#'
#' @return Tibble containing points
calc_points <- function(data, age, number_timesteps, days) {
  dc <- tibble::tibble(1:number_timesteps) %>%
    dplyr::rename(t = 1) %>%
    tibble::add_column(M = 0, W = 0)

  for (i in 1:number_timesteps) {
    x <- filter_date(data, lubridate::ymd(20200501) + i - days, lubridate::ymd(20200501) + i)
    dc$M[i] <- rate(x, age, "M")
    dc$W[i] <- rate(x, age, "W")
  }
  dc
}

#' Plot the evolution of the rate of death
#'
#' Draws the evolution of the rate of death of COVID-19 infections based on the
#' data given. For each gender one graph is shown.
#'
#' The value at a single point is calculated as the average relative death rate
#' from the last number of days. The time span which will be used is provided
#' through the first registered date in the dataframe and number of time steps.
#'
#' @param data [tibble][tibble::tibble-package] with RKI data
#' @param age Range of age of subgroup
#' @param number_timesteps Time span
#' @param days Number of days over which the average is taken
#'
#' @export
#'
#' @examples
#' data <- filter_date(covrki, 20200501, 20201001)
#'
#' plot_rate_death(data, "A05-A14", 30, 7)
#' # creates a plot for the subgroup of 5 - 14 year children with a time span of
#' # 30 days (01.05.2020 - 31.05.2020). The value at a given point is calculated
#' # as the average rate of death from the last 7 days.
#'
plot_rate_death <- function(data, age, number_timesteps, days) {
  dc <- calc_points(data, age, number_timesteps, days)

  ggplot2::ggplot(data = dc, ggplot2::aes(x = t)) +
    ggplot2::geom_line(ggplot2::aes(y = .data$M, colour = "Männlich")) +
    ggplot2::geom_line(ggplot2::aes(y = .data$W, colour = "Weiblich")) +
    ggplot2::labs(x = "t", y = "Relative Sterberate", color = "Legende",
                  title = paste0("Sterberate gemittelt über die letzten ", days, " Tage")) +
    ggplot2::theme_bw()
}
