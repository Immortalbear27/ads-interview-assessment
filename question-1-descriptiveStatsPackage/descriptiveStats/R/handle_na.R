#' Handle NA
#'
#' A helper function that handles missing values in the input vector by removing NA values.
#'
#' @param x A numeric vector.
#' @param na.rm Handles missing values by setting them to default to FALSE.
#'
#' @return The original input, but with empty NA values removed.
#'
#' @details
#' This function is a helper function that handles the management of NA values in the input.
handle_na <- function(x, na.rm){
  if (na.rm) {
    x <- x[!is.na(x)]
  }
  as.numeric(x)
}