library(dplyr)
library(tidyr)
library(stringr)

server <- function(input, output) {
  output$message <- renderText({
    msg <- paste0("You've chosen option #",
                  ". You've entered the following text: ")
    return(msg)
  })
  
  output$map <- renderLeaflet({
    
    hike_easy_1 <- read.csv("easy1csv.csv")
    hike_easy_2 <- read.csv("easy2csv.csv")
    hike_mod_1 <- read.csv("mod1csv.csv")
    hike_mod_2 <- read.csv ("mod2csv.csv")
    hike_hard_1 <- read.csv("hard1csv.csv")
    hike <- rbind(hike_easy_1, hike_easy_2, hike_mod_1, hike_mod_2, hike_hard_1)
    
    hike <- hike %>%
      mutate(
        lat = as.numeric(unlist(regmatches(hike$latitude,
                                           gregexpr("[[:digit:]]+\\.*[[:digit:]]*",
                                                    hike$latitude)))),
        long = as.numeric(paste0("-",as.numeric(unlist(regmatches(hike$longitude,
                                                                  gregexpr("[[:digit:]]+\\.*[[:digit:]]*",
                                                                           hike$longitude)))))),
        time = if_else(grepl("hour", hike$drive_time),
                       60.0 * as.numeric(unlist(regmatches(hike$drive_time,
                                                           gregexpr("[[:digit:]]+\\.*[[:digit:]]*", hike$drive_time)))),
                       as.numeric(str_extract(hike$drive_time, "[0-9]+"))
        ),
        info = paste0(hike_name, "<br/>", time, "<br/>", difficulty)
      ) %>%
      filter(!is.na(time)) %>%
      mutate(color = if_else(time <= 30, "#FFE077",
                     if_else(time <= 45, "#FFD889",
                     if_else(time <= 60, "#FFCAA5",
                     if_else(time <= 75, "#FFBCC0",
                     if_else(time <= 90, "#FFABE0",
                     if_else(time <= 120, "#FFB3CF",
                     if_else(time <= 150, "#E599FF",
                     if_else(time <= 180, "#C699FF",
                     if_else(time <= 240, "#B199FF",
                     if_else(time <= 300, "#A198FF",
                     if_else(time <= 420," #9D9AFF", "#9C99FF")))))))))))
      )
    
    
    leaflet(data = hike) %>%
      addProviderTiles("CartoDB.VoyagerLabelsUnder") %>% #"CartoDB.VoyagerLabelsUnder"
      addCircleMarkers(
        lat = ~lat,
        lng = ~long,
        stroke = TRUE,
        radius = 1,
        popup = ~info, 
        color = ~color
      )
  })
}


