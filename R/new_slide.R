#' @export
#' @name new_slide
#' @title Create a new slide in a slidepack


new_slide <- function(){
  knitr::asis_output(paste("\n\n---\n"))
}