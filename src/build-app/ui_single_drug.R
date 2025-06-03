ui_single_drug <- function(id) {
  ns <- NS(id)

  div(
    class = "single-drug-layout",
    style = "
      display: flex; 
      flex-direction: column; 
      padding: 20px; 
      gap: 20px; 
      background-color: #f7f9fc;
    ",

    # --- Network Card ---
    div(
      class = "card-container",
      style = "height: 400px; padding: 20px; display: flex; flex-direction: column;",
      h4("Drug Interaction Network", style = "font-weight: 600; margin-bottom: 10px;"),
      div(
        style = "flex: 1; min-height: 0;",
        visNetworkOutput(ns("drug_network"), height = "360px") |> withSpinner()
      )
    ),

    # --- Pie Chart Card ---
    div(
      class = "card-container",
      style = "height: 400px; padding: 20px; display: flex; flex-direction: column;",
      h4("Interaction Severity Distribution", style = "font-weight: 600; margin-bottom: 10px;"),
      div(
        style = "flex: 1; min-height: 0;",
        plotlyOutput(ns("interaction_pie"), height = "100%")
      )
    )
  )
}
