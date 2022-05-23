###Create helpful message when package is loaded
.onAttach <- function(libname, pkgname){
  
  packageStartupMessage("Welcome to the DfT slidepackR package!\n
  If this is the first time you are using this package in your project,
  run setup_project() to save the slidepack resources to your working directory")

  }