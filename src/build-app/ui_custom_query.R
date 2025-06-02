ui_custom_query <- function(global_data) {
  tabPanel("🔬 Query Drug Interactions",
    fluidRow(
      column(
        width = 3,
        h4("Custom Selection"),
        selectizeInput(
          inputId = "custom_drugs",
          label = "Select 2–5 Drugs",
          choices = sort(unique(global_data$nodes$label)),
          multiple = TRUE,
          options = list(maxItems = 5, placeholder = 'Start typing drug names...')
        ),
        actionButton("run_query", "Show Interactions", class = "btn btn-primary")
      ),
      column(
        width = 9,
        h4("Subnetwork Visualization"),
        visNetworkOutput("custom_network", height = "700px")
      )
    )
  )
}
