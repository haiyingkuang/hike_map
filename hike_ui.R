# trash with trash layout
page_one_main <- mainPanel(
  "My hike map", #better title?
  leafletOutput(
    outputId = "map"
  )
)

page_one_side <- sidebarPanel(
  checkboxGroupInput("checkGroup",
                     label = h3("Select difficulty"), 
                     choices = list("Easy" = "Easy",
                                    "Moderate" = "Moderate",
                                    "Difficult" = "Difficult"),
                     selected = "Easy"
  ), 
  hr(),
  sliderInput("dist_slider",
              label = h3("Choose hike distance"),
              min = 0, 
              max = 60,
              value = c(0, 25)),
  hr(),
  "She doesn't always refresh correctly when you mess with the slider but that's not my fault"
)


page_one <- tabPanel (
  "Page one",
  sidebarLayout(
    page_one_side,
    page_one_main
  )
)

ui <- navbarPage(
  "Hiking things",
  page_one
)
