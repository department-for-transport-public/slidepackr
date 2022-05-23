#' @export
#' @name image
#' @param filepath string, filepath of image to use (must be inside the same project as the Markdown document)
#' @param alt_text string, alt text to be used if image cannot be displayed or for screen readers. Defaults to empty
#' @param align string, alignment of image on slide. Options are left, middle and right. Defaults to left.
#' @param size integer, size of image as a percentage of the original. Default as NULL, image will display as full size
#' @title Insert an image into a markdown document
#' @importFrom knitr asis_output

image <- function(filepath, alt_text = "", size = NULL, align = "left"){
  
  ##Create height and width if required
  if(!is.null(size)){
    hw <- paste0(" style='width: ", size, "%'")
  } else{
    hw <- ""
  }

  
  knitr::asis_output(
    paste0("<img src='",filepath, "' alt=", alt_text, 
           " align=", align, hw, " />")
  )
}