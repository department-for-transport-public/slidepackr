
#' Imports the background slide images
#' Copies the images into a folder in your project directory
#' @param folder_name Specify the path to import the images into 
#' @name import_images
#' @title Import background images needed to create slidepacks into your project
#'    
#' 


import_images <- function(folder_name){

  if(!file.exists(paste(folder_name, "Images", sep = "/"))){
    dir.create(paste(folder_name, "Images", sep = "/"))}
  # copy the folder
  file.copy(system.file("Images", package = "slidepackR"), folder_name, recursive = TRUE, overwrite = TRUE)
}



#' Imports the required JS library
#' @param folder_name Specify the path to import the library into 
#' @name import_js_libs
#' @title Import required javascript library into your project

import_js_libs <- function(folder_name){
  
  file.copy(system.file("libs.zip", package = "slidepackR"), folder_name, overwrite = TRUE)
  unzip(paste0(folder_name, "/libs.zip"))
  unlink(paste0(folder_name, "/libs.zip"))
}


##General function to start up project
#' @export
#' @param folder_name Specify the path to import the images into (default is the current working directory)
#' @name setup_project
#' @title Import required background images and javascript libraries into your project. This only needs to be done once for any project.

setup_project <- function(folder_name = getwd()){
  
  import_images(folder_name = folder_name)
  import_js_libs(folder_name = folder_name)
  
}
