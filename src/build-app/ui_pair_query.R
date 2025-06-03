ui_pair_query <- function(id) {
  ns <- NS(id)

  Stack(
    tokens = list(childrenGap = 20),
    style = list(padding = 20, height = "100%"),
    
    Text(variant = "large", "Drug Pair Query (Coming Soon)")
    # TODO: Add inputs and outputs later
  )
}
