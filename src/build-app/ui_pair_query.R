ui_pair_query <- function(id) {
  ns <- NS(id)

  div(
    class = "pair-query-layout",
    style = "
      height: 100vh;
      margin: 0;
      padding: 0;
      display: flex;
      flex-direction: column;
      background-color: #f7f9fc;
    ",

    # Full-width & full-height white card container
    div(
      class = "query-card-container",
      style = "
        flex: 1;
        width: 100%;
        height: 100%;
        display: flex;
        flex-direction: column;
        padding: 32px 40px;
        background-color: white;
        box-sizing: border-box;
      ",

      # Top filter section with full-width input
      div(
        class = "drug-query-selector",
        style = "
          display: flex;
          flex-direction: column;
          gap: 8px;
          margin-bottom: 24px;
          width: 100%;
        ",
        Text(variant = "mediumPlus", "\U1F517 Select 2–5 Drugs:"),
        selectizeInput(
          inputId = ns("multi_drug_select"),
          label = NULL,
          choices = NULL,
          multiple = TRUE,
          width = "100%",  # makes the input span full width
          options = list(
            placeholder = "Type to search for drugs...",
            maxItems = 5
          )
        )
      ),

      # Scrollable results section (fills remaining height)
      div(
        style = "flex: 1; overflow-y: auto; padding-right: 4px;",
        uiOutput(ns("table_ui"))
      )
    )
  )
}
