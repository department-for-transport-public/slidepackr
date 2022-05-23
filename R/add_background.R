#' Select a background image for a created slide
#'
#' @export
#' @name add_background
#' @param background_type string, choose whether the slide should have a title slide appearance "title_slide", or a default content slide appearance "main_slide"
#' @title Select a background image for a created slide
#' @return Returns a backgroud image to be added to your slide

add_background <- function(background_type){
  
  if(background_type == "main_slide"){
    link = "Images/main_slide.png"
  } else if(background_type == "divider"){
    link = "Images/divider_slide.png"
  } else if(background_type == "title_slide"){
    link = "Images/DfT_Overview.PNG"
  } else{
    stop("Background type not recognised. Please choose from: main_slide or title_slide")
  }
  
  ##Stop function if image file does not exist
  if(!file.exists(link)){
    stop("Image does not exist")
  }
  
    paste0("background-image: url(", 
           link, 
           ")\nbackground-size: contain\nbackground-position: 0 0")
  
}