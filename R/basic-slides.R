#' @export
#' @name title_slide
#' @param title String, contents of title field in slide. Defaults to an empty string.
#' @param footer String, contents of footer field of slide. Defaults to an empty string.
#' @param content String, text content of slide. Defaults to an empty string.
#' @title Create a new basic title slide containing a title, footer and text content


title_slide <- function(title = "", footer = "", content = ""){

  knitr::asis_output(
    paste0("class: left, middle \n\n",
            "background-image: url(Images/DfT_Overview.PNG) \n\n",
            "#", 
            title, 
            "\n", 
            content,
           "\n", 
            ".class-footer_grey[", footer, "]")
  )
  
}

#' @export
#' @name section_slide
#' @param title String, contents of title field in slide. Defaults to an empty string.
#' @title Create a new section divider slide with header and divider background 


section_slide <- function(title = ""){
  
  knitr::asis_output(
    paste0("\n---\n", 
         "class: right, middle \n\n",
         "background-image: url(Images/divider_slide.png) \n",
           format_text(title, 
                       size = 40, 
                       colour = "white",
                       weight = "bolder")
    )
  )
  
  
}


#' @export
#' @name content_slide
#' @title Create a new content slide with main slide background 


content_slide <- function(){
  
  knitr::asis_output(
      paste0("\n---\n", 
             add_background("main_slide")
    )
  )
  
  
}

