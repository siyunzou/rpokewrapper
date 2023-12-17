library(jsonlite)
library(httr)
library(tidyverse)
library(stringr)
library(dplyr)
library(urltools)
library(re2)
library(devtools)

check_internet <- function(){
  stop_if_not(.x = has_internet(), msg = "Please check your internet connexion")
}

check_status <- function(res){
  stop_if_not(.x = status_code(res),
              .p = ~ .x == 200,
              msg = "The API returned an error")
}

