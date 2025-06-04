library(shiny.fluent)
library(dplyr)
library(stringr)
library(rlang) 

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
    `Description` = filtered_named$title,
    `Management` = filtered_named$ddinter_management
  )
})


  output$table_ui <- renderUI({
  data <- pair_data()

  if (is.null(data) || nrow(data) == 0) {
    return(Text("No interaction found between selected drugs."))
  }

  interaction_cards <- lapply(seq_len(nrow(data)), function(i) {
    row <- data[i, , drop = FALSE]

    drug1 <- row[[1]] %||% "N/A"
    drug2 <- row[[2]] %||% "N/A"
    type <- row[[3]] %||% "N/A"
    severity <- row[[4]] %||% "N/A"
    description <- row[[5]] 
    management <- row[[6]]
    if (is.null(description) || !nzchar(description)) {
      description <- "N/A"
    }
    if (is.null(management) || !nzchar(management)) {
      management <- "N/A"
    }

    # Normalize severity (case-insensitive)
    severity_clean <- tolower(trimws(severity))
    severity_text <- if (severity_clean %in% c("major", "moderate", "minor")) {
      str_to_title(severity_clean)
    } else {
      "Unknown"
    }

    sev_color <- case_when(
      severity_clean == "major"    ~ "#d9534f",
      severity_clean == "moderate" ~ "#f0ad4e",
      severity_clean == "minor"    ~ "#5cb85c",
      TRUE                         ~ "#999999"
    )

    # Handle empty or null descriptions
    if (is.null(description) || !nzchar(description)) {
      description <- "N/A"
    }


    Stack(
      styles = list(root = list(
        width = "100%",
        padding = 24,
        backgroundColor = "#ffffff",
        border = "1px solid #e0e0e0",
        borderRadius = 12,
        boxShadow = "0 4px 12px rgba(0,0,0,0.05)",
        marginBottom = 24
      )),
      children = list(
        Stack(
          horizontal = TRUE,
          tokens = list(childrenGap = 8),
          verticalAlign = "center",
          children = list(
            Icon(iconName = "Info", styles = list(root = list(fontSize = 22, color = "#0078D4"))),
            Text(variant = "xLarge", style = list(fontWeight = 600), paste("Interaction", i))
          )
        ),
        div(
          style = list(
            display = "grid",
            gridTemplateColumns = "150px 1fr",
            rowGap = "10px",
            columnGap = "16px",
            marginTop = "12px",
            fontSize = "16px"
          ),
          Text(style = list(fontWeight = 600), "Drug 1:"), Text(style = list(fontWeight = 400), drug1),
          Text(style = list(fontWeight = 600), "Drug 2:"), Text(style = list(fontWeight = 400), drug2),
          Text(style = list(fontWeight = 600), "Type:"), Text(style = list(fontWeight = 400), type),
          Text(style = list(fontWeight = 600), "Severity:"),
          Text(style = list(color = sev_color, fontWeight = 600), severity_text),
          Text(style = list(fontWeight = 600), "Description:"),
          Text(style = list(whiteSpace = "pre-line", fontWeight = 400), description),
          Text(style = list(fontWeight = 600), "Management:"),
          Text(style = list(whiteSpace = "pre-line", fontWeight = 400), management)

        )
      )
    )

  })

  Stack(tokens = list(childrenGap = 24), children = interaction_cards)
})



}
