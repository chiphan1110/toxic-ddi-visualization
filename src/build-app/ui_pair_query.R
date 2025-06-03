ui_pair_query <- function(id) {
  ns <- NS(id)

  div(
    class = "pair-query-layout",
    style = "padding: 12px; display: flex; flex-direction: column; gap: 16px;",

    # Replace two selects with one
    selectizeInput(
      ns("multi_drug_select"),
      label = "Select 2–5 Drugs:",
      choices = NULL,
      multiple = TRUE,
      options = list(
        placeholder = "Type to search for drugs...",
        maxItems = 5
      )
    ),

    # Output container for cards
    uiOutput(ns("table_ui"))
  )
}
