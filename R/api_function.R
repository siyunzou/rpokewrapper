library(jsonlite)
library(httr)
library(tidyverse)
library(stringr)
library(dplyr)
library(urltools)
library(re2)
library(devtools)

poke_api <- function(path){
  out <- tryCatch(
    {
      url <- modify_url("https://pokeapi.co", path=paste("/api/v2",path, sep=""))
      response <- GET(url, timeout(10))
      if (http_error(response)){
        if (round(status_code(response)/100,0)==5 | path==500){ # NOTE: all path==500 checks are for testing purposes only (allows simulation of inability to reach API)
          if (path == 500){
            # If 500 was passed in set the response to 500 so that the while loop can be tested
            response = 500
          }
          # If the error status code is in the 500 range attempt to call the API up to 5 more times, with a timed delay between calls
          delayTime <- 1
          while (round(status_code(response)/100,0)==5 & delayTime<=16){
            Sys.sleep(delayTime) # Delay time between calls
            response <- GET(url, timeout(10)) # Attempting to reach the API again
            # Exponential backoff of request time +/- randomly selected value between 0+5% of current delay time
            delayTime = delayTime*2+runif(1, -delayTime*0.05, delayTime*0.05)
            # For Testing when the API can't be reached
          }
          if (round(status_code(response)/100,0)==5 | path==500){
            stop("Unable to reach API", call. = FALSE)
          }
        } else if (round(status_code(response)/100,0)==4){
          stop("Invalid Input Path", call. = FALSE)
        }
      }
      return(response)
    },
    error=function(cond){
      print(gsub("\n","",gettext(cond)))
    })
}

# pokemon_df <- data.frame()
# ids <- 1:151
# for (i in ids){
#   res <- poke_api(paste0('/pokemon/', i))
#   df = fromJSON(rawToChar(res$content))
#
#   ability <- df$abilities[,1, drop = FALSE] %>%
#     reframe(abilities = paste(ability$name, collapse= ","))
#
#   pokemon <- df$name
#   height <- df$height
#   weight <- df$weight
#   id <- df$id
#
#   type <- df$types[,2,drop = FALSE] %>%
#     reframe(type = paste(type$name, collapse= ","))
#
#   moves <- head(df$moves[,1,drop=FALSE],5) %>%
#     reframe(moves = paste(move$name, collapse= ","))
#
#   data <- data.frame(id, pokemon, height, weight, ability, type, moves)
#   pokemon_df <- rbind(pokemon_df, data)
# }

# usethis::use_data(pokemon_df)

# devtools::test()
