#' Calculate Mode
#'
#' Computes the mode(s) of a numeric vector.
#'
#' @param x A numeric vector.
#' @param na.rm Handles missing values by setting them to default to FALSE.
#'
#' @return A numeric vector containing the mode value(s). Returns NA if no mode exists.
#'
#' @details
#' If multiple values share the highest frequency, all are returned.
#' If all values occur only once, the function returns NA to indicate no mode.
#'
#' @examples
#' calc_mode(c(1, 2, 2, 3))
#' calc_mode(c(1, 1, 2, 2))  # multiple modes
#' calc_mode(c(1, 2, 3, 4))  # no mode
#'
#' @export
calc_mode <- function(x, na.rm = FALSE){
  # Use of a helper function designed to validate if input is numeric:
  validate_numeric(x)
  
  # If missing values are detected, then remove them from the input:
  handle_na(x, na.rm)
  
  # Checks to see if input, after missing values are handled, is reduced to 
  # length of 0. If so, then exit function prematurely with NA value.
  if (length(x) == 0) {
    return(NA)
  }
  
  # Logic handling mode calculation:
  freq <- table(x)
  max_freq <- max(freq)
  
  modes <- as.numeric(names(freq[freq == max_freq]))
  
  # No mode case: all values occur once
  if (max_freq == 1) {
    return(NA)
  }
  
  return(modes)
}
