ui <- navbarPage(
  "Hiking things",
  page_one
)



page_one <- mainPanel(
  "My hike map", #better title?
  leafletOutput(
    outputId = "map"
  )
)
