ui_single_drug <- function() {
  Stack(
    tokens = list(childrenGap = 20),
    Text(variant = "xLarge", "Single Drug View"),
    Stack(
      tokens = list(childrenGap = 10),
      Text("selectInput() and drug-specific network will go here"),
      Text("plotlyOutput('interaction_pie') will go here")
    )
  )
}
