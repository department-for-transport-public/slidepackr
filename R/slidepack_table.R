#' @export
#' @name table
#' @param data dataframe of data to be displayed in the table
#' @param ... other arguments to pass to the knitr::kable table
#' @title Create a css-formatted HTML table to include in your slidepack 
#' @importFrom knitr kable asis_output
#' @examples 
#' table(head(iris))

table <- function(data, ...){
  
  return(
    knitr::asis_output(
        knitr::kable(data, format = 'html', ...))
  )
  
}


