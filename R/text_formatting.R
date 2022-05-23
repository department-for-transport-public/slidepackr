#' Formats text on a line-by-line basis
#' @export
#' @param text String, text to format according to the specified style
#' @param size numeric, font size of formatted text in pixels. Default is 12
#' @param colour string, colour of formatted text. Name of a pre-defined HTML colour, or a hex code. Defaults to "black"
#' @param weight string, weight of formatted text. Can be "normal", "bold", or "bolder". Default is "normal.  
#' @importFrom knitr asis_output
#' @name format_text
#' @title Format individual lines of text beyond the styles specified in the CSS file
#' 


format_text <- function(text, size = 12, colour = "black", weight = "normal")
  knitr::asis_output(
    paste0('<p style="font-size: ',
           size, 'px; 
           font-weight: ', weight, '; ',
           'color: ', colour, '">',
           text)
)