#' Calculate Interquartile (IQR) Range
#'
#' Computes the interquartile range of a numerical vector
#'
#' @param x A numeric vector.
#' @param na.rm Handles missing values by setting them to default to FALSE.
#'
#' @return A single numeric value representing the interquartile range of the input.
#'     Returns NA if input is empty after NA removal.
#'
#' @details
#' This function re-uses calc_q3 and calc_q1 in order to calculate the two required quartiles.
#'     The interquartile range (IQR) is defined as the difference between the first and third
#'     quartiles.
#'
#' @examples
#' calc_iqr(c(1, 2, 2, 3))
#' calc_iqr(c(1, NA, 3), na.rm = TRUE)
#'
#' @export
calc_iqr <- function(x, na.rm = FALSE){
  # Logic handling interquartile range calculation, including edge case handling in used functions:
  calc_q3(x, na.rm) - calc_q1(x, na.rm)
}