#' @title Hello function
#'
#' @description
#' This function does things
#'
#'
#' @param x
#'
#' @importFrom tibble as_data_frame
#' @import dplyr
#'
#' @return Hell to name
#' @export
#'
#' @examples
#' hello(youssef)
nio <- function(x) {
  tibble:as_data_frame(print(paste0("Hello",x, "world!")))
}
