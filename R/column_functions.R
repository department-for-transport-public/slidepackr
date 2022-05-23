### Uneven column function
#'
#' @export
#' @name uneven_cols
#' @param text string, text content to appear in the smaller left column
#' @param content any R studio object (chart, table, text) to appear in the larger right column
#' @title Create a column structure for a slide with a large right column (75\% width) and small left column (25\% width)
#' @importFrom knitr asis_output
#' @examples 
#' uneven_cols("This is text", plot(mtcars))
uneven_cols <- function(text, content){
  
  if(ggplot2::is.ggplot(content)){
    content <- print(content)[0]
  }
  
  knitr::asis_output(
    paste(
      ".left-column[<br>",
      text,
      "<br>]",
      "<br><br>",
      ".right-column[ <br>",
      content,
      "<br>","]"))
 
}



##Even column function

#' @export
#' @name even_cols
#' @param text string, text content to appear in the smaller left column
#' @param content any R studio object (chart, table, text) to appear in the larger right column
#' @title Create a column structure for a slide with equal right and left columns
#' @importFrom knitr asis_output
#' @importFrom ggplot2 is.ggplot
#' @examples 
#' even_cols("This is text", plot(mtcars))
even_cols <- function(text, content){
  
  if(ggplot2::is.ggplot(content)){
    content <- print(content)[0]
  }
  
  knitr::asis_output(
    paste(
      ".pull-left[<br>",
      text,
      "<br>]",
      "<br><br>",
      ".pull-right[ <br>",
      content,
      "<br>","]"))
  
}