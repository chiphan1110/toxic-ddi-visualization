ui_main_network <- function(id) {
  ns <- NS(id)

  div(
    class = "network-plot-container",
    # Use calc() to ensure it takes available height
    visNetworkOutput(ns("network_plot"), height = "calc(100vh - 120px)", width = "100%") |> withSpinner()
  )
}