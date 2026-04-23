#' Validate Numeric Input
#'
#' Internal helper function to validate whether an input is numeric or not.
#'
#' @param x Input vector to check.
#'
#' @return Returns TRUE if validation passes.
#' @keywords internal
validate_numeric <- function(x) {
  if (!is.numeric(x)) {
    stop("Input must be numeric", call. = FALSE)
  }
  if (length(x) == 0) {
    stop("Input vector must not be empty", call. = FALSE)
  }
  invisible(TRUE)
}