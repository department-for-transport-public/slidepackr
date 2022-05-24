### Uneven column function
#'
#' @export
#' @name uneven_cols
#' @param left string, text content to appear in the smaller left column
#' @param right any R studio object (chart, table, text) to appear in the larger right column
#' @title Create a column structure for a slide with a large right column (75\% width) and small left column (25\% width)
#' @importFrom knitr asis_output
#' @examples 
#' uneven_cols("This is text", plot(mtcars))
uneven_cols <- function(left, right){
  
  if(ggplot2::is.ggplot(right)){
    right <- print(right)[0]
  }
  
  knitr::asis_output(
    paste(
      ".left-column[<br>",
      left,
      "<br>]",
      "<br><br>",
      ".right-column[ <br>",
      right,
      "<br>","]"))
 
}



##Even column function

#' @export
#' @name even_cols
#' @param left content to appear in the left column
#' @param right content to appear in the right column
#' @title Create a column structure for a slide with equal right and left columns
#' @importFrom knitr asis_output opts_current
#' @importFrom ggplot2 is.ggplot
#' @examples 
#' even_cols("This is text", plot(mtcars))
even_cols <- function(left, right){
  
  if(knitr::opts_current$get("fig.show") != "hide"){
    stop("Chunk option fig.show must be set to 'hide'")
  }
  
  ##Set starting image number
  img_no <- 1
  
  if(ggplot2::is.ggplot(left)){
    left <- convert_ggplot(left)
    img_no <- img_no + 1 #Imcrement image number
  }
  
  if(ggplot2::is.ggplot(right)){
    right <- convert_ggplot(right)
    img_no <- img_no + 1
    
  }
  
  
  
  
  knitr::asis_output(paste(
    ".pull-left[",
    left,
    "]",
    "<br><br>",
    ".pull-right[",
    right,
    "]"
  ))
}