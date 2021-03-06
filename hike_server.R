library(dplyr)

server <- function(input, output) {
  output$message <- renderText({
    msg <- paste0("You've chosen option #",
                  ". You've entered the following text: ")
    return(msg)
  })
  
  
  # makes interactive map
  output$map <- renderLeaflet({
    # loads a bunch of csv files
    hike_easy_1 <- read.csv("data/easy1csv.csv")
    hike_easy_2 <- read.csv("data/easy2csv.csv")
    hike_mod_1 <- read.csv("data/mod1csv.csv")
    hike_mod_2 <- read.csv ("data/mod2csv.csv")
    hike_hard_1 <- read.csv("data/hard1csv.csv")
    
    # combines all the csv files
    hike <- rbind(hike_easy_1, hike_easy_2, hike_mod_1, hike_mod_2, hike_hard_1)
    
    
    # creates new columns that are more usable
    hike <- hike %>%
      mutate(
        lat = as.numeric(unlist(regmatches(hike$latitude,
              gregexpr("[[:digit:]]+\\.*[[:digit:]]*", hike$latitude)))),
        long = as.numeric(paste0("-", as.numeric(unlist(regmatches(hike$longitude,
               gregexpr("[[:digit:]]+\\.*[[:digit:]]*", hike$longitude)))))),
        time = if_else(grepl("hour", hike$drive_time),
               60.0 * as.numeric(unlist(regmatches(hike$drive_time,
               gregexpr("[[:digit:]]+\\.*[[:digit:]]*", hike$drive_time)))),
               as.numeric(str_extract(hike$drive_time, "[0-9]+"))),
        hr_min = if_else(time %/% 60 == 0, paste0(time %% 60, " min"),
                 if_else(time %% 60 == 0, paste0(time %/% 60, " hr"),
                 paste0(time %/% 60, " hr ", time %% 60, " min"))),
        info = paste0(�..hike_name, "<br/>",
                      "Drive from Portland: ", hr_min,"<br/>",
                      difficulty, ", ", distance)
      ) %>%
      filter(!is.na(time)) %>%
      
      # applies a color gradient that I found manually; prob not the best way
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
      ) %>%
      filter(#hike$dist >= input$dist_slider[1] &
             #hike$dist <= input$dist_slider[2] &
             difficulty %in% input$checkGroup
             )
    
    hike <- hike[(hike$dist <= input$dist_slider[2] & hike$dist >= input$dist_slider[1]), ]
      
    
    # makes and returns map
    leaflet(data = hike) %>%
      addProviderTiles("CartoDB.VoyagerLabelsUnder") %>%
      addCircleMarkers(
        lat = ~lat,
        lng = ~long,
        stroke = TRUE,
        radius = 2,
        popup = ~info,
        color = ~color
      )
  })
  
}


