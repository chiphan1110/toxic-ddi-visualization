ui_pair_query <- function() {
  Stack(
    tokens = list(childrenGap = 20),
    Text(variant = "xLarge", "Drug Pair Query"),
    Stack(
      tokens = list(childrenGap = 10),
      Text("selectInput('drug1') and selectInput('drug2') go here"),
      Text("visNetworkOutput('pair_network')"),
      Text("DTOutput('interaction_table')")
    )
  )
}
