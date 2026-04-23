#' Calculate Third Quartile (Q3)
#'
#' Computes the third quartile (75th percentile) of a numerical vector.
#'
#' @param x A numeric vector.
#' @param na.rm Handles missing values by setting them to default to FALSE.
#'
#' @return A single numeric value representing the third quartile of the input.
#'     Returns NA if input is empty after NA removal.
#'
#' @details
#' This function is a wrapper around base R's quantile function, with additional
#'     input validation for increased robustness.
#'
#' @examples
#' calc_q3(c(1, 2, 2, 3))
#' calc_q3(c(1, NA, 3), na.rm = TRUE)
#'
#' @export
calc_q3 <- function(x, na.rm = FALSE){
  # Use of a helper function designed to validate if input is numeric:
  validate_numeric(x)
  
  # If missing values are detected, then remove them from the input:
  x <- handle_na(x, na.rm)
  
  # Checks to see if input, after missing values are handled, is reduced to 
  # length of 0. If so, then exit function prematurely with NA value.
  if (length(x) == 0) {
    return(NA)
  }
  
  # Logic handling third quartile calculation:
  as.numeric(quantile(x, 0.75, names = FALSE, na.rm = na.rm))
}