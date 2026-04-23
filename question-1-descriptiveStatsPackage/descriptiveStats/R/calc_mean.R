#' Calculate the Mean
#'
#' Computes the mean of a numeric vector.
#' 
#' @param x A numeric input/vector.
#' @param na.rm Handles missing values by setting them to default to FALSE.
#' 
#' @return A single numeric value representing the mean of the input vector.
#'
#' @details
#' This function is a wrapper around Base R's mean function, with additional
#' input validation for increased robustness.
#'
#' @examples
#' calc_mean(c(1, 2, 3, 4))
#' calc_mean(c(1, NA, 3), na.rm = TRUE)
#' 
#' @export
calc_mean <- function(x, na.rm = FALSE){
  # Use of a helper function designed to validate if input is numeric:
  validate_numeric(x)
  # Compute the mean of the numeric vector:
  mean(x, na.rm = na.rm)
}
