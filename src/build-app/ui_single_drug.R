ui_single_drug <- function(id) {
  ns <- NS(id)

  div(
    class = "single-drug-layout",
    style = "height: calc(100vh - 60px); display: flex; flex-direction: column; padding: 10px; gap: 12px;",

    # === Top Section: Network ===
    div(
      style = "flex: none;",
      h4("Drug Interaction Network", style = "font-weight: 600; margin: 0 0 6px 0;"),
      visNetworkOutput(ns("drug_network"), height = "42vh") |> withSpinner()
    ),

    # === Bottom Section: Pie ===
    div(
      style = "flex: none;",
      h4("Interaction Severity Distribution", style = "font-weight: 600; margin: 0 0 6px 0;"),
      plotlyOutput(ns("interaction_pie"), height = "42vh", width = "100%") |> withSpinner()
    )
  )
}
