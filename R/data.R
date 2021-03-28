#' RKI Dataset about COVID-19 Cases in Germany
#'
#' A dataset containing the publicly available data about COVID-19 cases in
#' Germany provided by the RKI. It spans all cases from January 1st, 2020 up to
#' February 10th, 2021 that were recorded by February 12th, 2021.
#'
#' @format A data frame with 1229166 rows and 17 variables:
#' \describe{
#'   \item{IdBundesland}{The case's state's ID}
#'   \item{Bundesland}{Name of state}
#'   \item{IdLandkreis}{The case's county's ID}
#'   \item{Landkreis}{Name of county}
#'   \item{Altersgruppe}{Case's age group. Groups are 0-4, 5-14, 15-34, 35-59,
#'   60-79, 80+ or unknown.}
#'   \item{Altersgruppe2}{Case's age group. Groups are 0-4, 5-9, 10-14, ...,
#'   75-79, 80+ or unknown.}
#'   \item{Geschlecht}{Cases gender. Either M (male), W (female) or unknown.}
#'   \item{AnzahlFall}{Number of cases in group}
#'   \item{AnzahlTodesfall}{Number of deaths in group}
#'   \item{Meldedatum}{Date when the case was reported}
#'   \item{Datenstand}{Date of last update of dataset}
#'   \item{NeuerFall}{
#'     \describe{
#'       \item{0}{Case is included in both the current day and the last day}
#'       \item{1}{Case is only included in the current day}
#'       \item{-1}{Case is only included in last day}
#'     }
#'     The number of cases can be calculated with sum(AnzahlFall) if NeuerFall
#'     is 0 or 1. The difference to the last day can be calculated with
#'     sum(AnzahlFall) if NeuerFall is -1 or 1.
#'   }
#'   \item{NeuerTodesfall}{
#'     \describe{
#'       \item{0}{Case counts towards the number of deaths on both the current
#'       and the last day}
#'       \item{1}{Case only counts towards the number of deaths on the current
#'       day}
#'       \item{-1}{Case doesn't counts towards the number of deaths on the
#'       current day but on the
#'         last}
#'       \item{-9}{Case neither counts towards the number of deaths on the
#'       current day nor on the
#'         last}
#'     }
#'     The number of deaths can be calculated with sum(AnzahlTodesfall) if
#'     NeuerTodesfall is 0 or 1. The difference to the last day can be
#'     calculated with sum(AnzahlTodesfall) if NeuerTodesfall is -1 or 1.
#'   }
#'   \item{Refdatum}{Date of onset of symptoms or, if unknown, date of report}
#'   \item{AnzahlGenesen}{Number of recovered cases in group}
#'   \item{NeuGenesen}{
#'     \describe{
#'       \item{0}{Case counts towards the number of recovered cases on both the
#'       current and the last day}
#'       \item{1}{Case only counts towards the number of recovered cases on the
#'       current day}
#'       \item{-1}{Case doesn't counts towards the number of recovered cases on
#'       the current day but on the last}
#'       \item{-9}{Case neither counts towards the number of recovered cases on
#'       the current day nor on the last}
#'     }
#'     The number of recovered cases can be calculated with sum(AnzahlGenesen)
#'     if NeuGenesen is 0 or 1. The difference to the last day can be calculated
#'     with sum(AnzahlGenesen) if NeuGenesen is -1 or 1.
#'   }
#'   \item{IstErkrankungsbeginn}{1 if Refdatum is date of onset of symptoms
#'   otherwise 0}
#' }
#' @source \url{https://npgeo-corona-npgeo-de.hub.arcgis.com/datasets/dd4580c810204019a7b8eb3e0b329dd6_0}
"covrki"
