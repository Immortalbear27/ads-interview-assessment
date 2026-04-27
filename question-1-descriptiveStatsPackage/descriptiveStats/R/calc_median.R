#' Calculate the Median
#'
#' Computes the median of a numeric vector.
#' 
#' @param x A numeric input/vector.
#' @param na.rm Handles missing values by setting them to default to FALSE.
#' 
#' @return A single numeric value representing the median of the input vector.
#' 
#' @details
#' This function is a wrapper around base R's median function, with additional
#' input validation for increased robustness.
#' 
#' @examples
#' calc_median(c(1, 2, 3, 4))
#' calc_median(c(1, NA, 3), na.rm = TRUE)
#' 
#' @export
calc_median <- function(x, na.rm = FALSE){
  # Use of a helper function designed to validate if input is numeric:
  validate_numeric(x)
  # Compute the median of the numeric vector:
  median(x, na.rm = na.rm)
}
