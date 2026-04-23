#' Calculate the Mean
#'
#' Computes the mean of a numeric vector.
#' 
#' @param x A numeric input/vector.
#' @param na.rm Handles missing values by setting them to default to FALSE.
#' 
#' @examples
#' calc_mean(c(1, 2, 3, 4))
#' calc_mean(c(1, NA, 3), na.rm = TRUE)
#' 
#' @export
calc_mean <- function(x, na.rm = FALSE){
  validate_numeric(x)
  mean(x, na.rm = na.rm)
}