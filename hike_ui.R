ui <- navbarPage(
  "Hiking things",
  page_one
)

page_one <- tabPanel (
  "Page one",
  sidebarLayout(
    page_one_side,
    page_one_main
  )
)

page_one_main <- mainPanel(
  "My hike map", #better title?
  leafletOutput(
    outputId = "map"
  )
)

page_one_side <- sidebarPanel(
  checkboxGroupInput("checkGroup",
                     label = h3("Select Difficulty"), 
                     choices = list("Easy" = "Easy",
                                    "Moderate" = "Moderate",
                                    "Difficult" = "Difficult"),
                     selected = "Easy"
  )
)

