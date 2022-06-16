### Uneven column function
#'
#' @export
#' @name uneven_cols
#' @param left string, text content to appear in the smaller left column; multiple string objects can be passed as a list.
#' @param right any R studio object (chart, table, text) to appear in the larger right column; multiple objects can be passed as a list.
#' @title Create a column structure for a slide with a large right column (75\% width) and small left column (25\% width)
#' @importFrom knitr asis_output opts_current
#' @examples 
#' uneven_cols("This is text", plot(mtcars))
uneven_cols <- function(left, right){
  
  if(knitr::opts_current$get("fig.show") != "hide"){
    stop("Chunk option fig.show must be set to 'hide'")
  }
  
  ##Set starting image number
  img_no <- 1
  
  ##Fix problem of ggplots being lists (why does R hate me?)
 
   if("ggplot" %in% class(right)){
    right <- convert_ggplot(right, img_no)
    
  } else if(class(right) == "list"){
  
  for(i in 1:length(right)){
    
    if("ggplot" %in% class(right[[i]])){
      right[[i]] <- convert_ggplot(right[[i]], img_no)
      img_no <- img_no + 1
      
    }
  }
  }
  
  ##Collapse lists into vectors
  left <- paste(left, collapse = "\n")
  right <- paste(right, collapse = "\n")
  
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
#' @param left content to appear in the left column; multiple objects can be passed as a list. 
#' @param right content to appear in the right column; multiple objects can be passed as a list.
#' @title Create a column structure for a slide with equal right and left columns
#' @importFrom knitr asis_output opts_current
#' @examples 
#' even_cols("This is text", plot(mtcars))
even_cols <- function(left, right){
  
  if(knitr::opts_current$get("fig.show") != "hide"){
    stop("Chunk option fig.show must be set to 'hide'")
  }
  
  ##Set starting image number
  img_no <- 1
  
  ##Fix problem of ggplots being lists
  
  if("ggplot" %in% class(left)){
    left <- convert_ggplot(left, img_no)
    
  } else if(class(left) == "list"){
    ##Loop over and convert all objects for left and right
    for(i in 1:length(left)){
      
      if("ggplot" %in% class(left[[i]])){
        left[[i]] <- convert_ggplot(left[[i]], img_no)
        img_no <- img_no + 1 #Imcrement image number
      }
    }
  }
  
  if("ggplot" %in% class(right)){
    right <- convert_ggplot(right, img_no)
    
  }else if(class(right) == "list"){
  for(i in 1:length(right)){
    
    if("ggplot" %in% class(right[[i]])){
      right[[i]] <- convert_ggplot(right[[i]], img_no)
      img_no <- img_no + 1
      
    }
  }
}
  
  ##Collapse lists into vectors
  left <- paste(left, collapse = "\n")
  right <- paste(right, collapse = "\n")
  
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