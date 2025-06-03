library(shiny.fluent)
library(dplyr)
library(stringr)

server_pair_query <- function(input, output, session) {
  ns <- session$ns

  # Access preloaded node and edge data
  nodes <- ddi_network_data$nodes
  edges <- ddi_network_data$edges

  # Process drug pair selection and extract interaction data
    pair_data <- reactive({
    req(input$multi_drug_select)
    drugs <- input$multi_drug_select
    if (length(drugs) < 2) return(NULL)

    selected_nodes <- nodes %>% filter(label %in% drugs)

    all_pairs <- expand.grid(
        drug1 = selected_nodes$id,
        drug2 = selected_nodes$id
    ) %>%
        filter(drug1 != drug2) %>%
        distinct()

    filtered <- edges %>%
        filter(
        (from %in% all_pairs$drug1 & to %in% all_pairs$drug2) |
        (from %in% all_pairs$drug2 & to %in% all_pairs$drug1)
        )

    if (nrow(filtered) == 0) return(NULL)

    named_nodes <- nodes %>% select(id, name = label)

    filtered_named <- filtered %>%
        left_join(named_nodes, by = c("from" = "id")) %>%
        rename(drug1_name = name, drug1_id = from) %>%
        left_join(named_nodes, by = c("to" = "id")) %>%
        rename(drug2_name = name, drug2_id = to)

    tibble::tibble(
        `Drug 1` = paste0(filtered_named$drug1_id, " (", filtered_named$drug1_name, ")"),
        `Drug 2` = paste0(filtered_named$drug2_id, " (", filtered_named$drug2_name, ")"),
        `Interaction Type` = str_to_sentence(filtered_named$interaction_category),
        `Severity` = filtered_named$ddinter_severity,
        `Description` = filtered_named$title
    )
    })


  output$table_ui <- renderUI({
  data <- pair_data()

  if (is.null(data) || nrow(data) == 0) {
    return(Text("No interaction found between selected drugs."))
  }

  interaction_cards <- lapply(seq_len(nrow(data)), function(i) {
    row <- data[i, , drop = FALSE]

    drug1 <- row[[1]]
    drug2 <- row[[2]]
    type <- row[[3]]
    severity <- row[[4]]
    description <- row[[5]]

    sev_color <- if (severity == "Major") "#d9534f"
      else if (severity == "Moderate") "#f0ad4e"
      else if (severity == "Minor") "#5cb85c"
      else "#999"

    Stack(
      styles = list(root = list(
        width = "100%",
        padding = 24,
        border = "1px solid #e0e0e0",
        borderRadius = 10,
        backgroundColor = "#ffffff",
        marginBottom = 20,
        boxShadow = "0 2px 6px rgba(0,0,0,0.06)"
      )),
      children = list(
        Text(variant = "large", paste("Interaction", i)),
        div(
          style = list(
            display = "grid",
            gridTemplateColumns = "150px 1fr",
            rowGap = "8px",
            columnGap = "16px",
            marginTop = "12px"
          ),
          Text(style = list(fontWeight = 600), "Drug 1:"), Text(drug1),
          Text(style = list(fontWeight = 600), "Drug 2:"), Text(drug2),
          Text(style = list(fontWeight = 600), "Type:"), Text(type),
          Text(style = list(fontWeight = 600), "Severity:"),
          Text(style = list(color = sev_color, fontWeight = 600), severity),
          Text(style = list(fontWeight = 600), "Description:"), Text(description)
        )
      )
    )
  })

  Stack(tokens = list(childrenGap = 24), children = interaction_cards)
})



}
