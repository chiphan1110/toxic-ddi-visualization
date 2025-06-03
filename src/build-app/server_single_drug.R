library(dplyr)
library(tidyr)
library(plotly)  
library(shiny.fluent)

interaction_color_map <- list(
  cardiotoxicity       = "#F1948A",  # soft rose
  nephrotoxicity       = "#85C1E9",  # pastel blue
  hepatotoxicity       = "#F8C471",  # peach
  neurotoxicity        = "#C39BD3",  # lavender
  ototoxicity          = "#F9E79F",  # light lemon
  `pulmonary toxicity` = "#A3E4D7",  # mint/teal
  unknown              = "#D5D8DC"   # soft gray
)
severity_color_map <- list(
  Minor    = "#A9DFBF",  # pastel green
  Moderate = "#FAD7A0",  # pastel orange
  Major    = "#F5B7B1",  # pastel red
  Unknown  = "#D5DBDB"   # light gray
)


map_interaction_color <- function(type) {
  color <- interaction_color_map[[tolower(type)]]
  if (is.null(color)) "#95A5A6" else color
}

server_single_drug <- function(input, output, session, ddi_network_data, selected_drug) {
  ns <- session$ns

  filtered_data <- reactive({
    req(selected_drug())
    drug <- selected_drug()

    # Get node ID(s) for the selected drug name
    drug_ids <- ddi_network_data$nodes$id[ddi_network_data$nodes$label == drug]
    if (length(drug_ids) == 0) {
      warning(paste("No node found for drug:", drug))
      return(list(nodes = data.frame(), edges = data.frame()))
    }

    # Filter edges where drug ID appears
    selected_edges <- ddi_network_data$edges %>%
      filter(from %in% drug_ids | to %in% drug_ids)
    if (nrow(selected_edges) == 0) {
      warning(paste("No interactions found for drug:", drug))
      return(list(nodes = data.frame(), edges = data.frame()))
    }

    # Nodes involved
    node_ids <- unique(c(selected_edges$from, selected_edges$to))
    nodes <- ddi_network_data$nodes %>% filter(id %in% node_ids)

    # Determine node interaction type
    node_types <- selected_edges %>%
      select(from, to, interaction_category) %>%
      pivot_longer(cols = c(from, to), names_to = "edge_side", values_to = "node_id") %>%
      mutate(interaction_category = ifelse(is.na(interaction_category), "unknown", interaction_category)) %>%
      group_by(node_id) %>%
      summarise(interaction_category = first(interaction_category), .groups = "drop")

    styled_edges <- selected_edges %>%
      mutate(
        severity_label = dplyr::case_when(
          width == 2 ~ "Minor",
          width == 4 ~ "Moderate",
          width == 6 ~ "Major",
          TRUE       ~ "Unknown"
        ),
        title = paste0(
          "<div style='padding:6px;background:#fff0f5;border-radius:4px;'>",
          "<b>Severity:</b> ", severity_label, "<br>",
          "<b>Interaction Type:</b><br><i>", interaction_category, "</i></div>"
        )
      )


    styled_nodes <- nodes %>%
      left_join(node_types, by = c("id" = "node_id")) %>%
      mutate(
        color = sapply(tolower(interaction_category), function(x) interaction_color_map[[x]] %||% "#666666"),
        shape = ifelse(label == drug, "star", "dot"),
        size  = ifelse(label == drug, 30, 15),
        title = paste0(
          "<div style='padding:6px;background:#f8f8f8;border-radius:6px;'>",
          "<b>Drug:</b> ", label, "</div>"
        )
  )
    list(nodes = styled_nodes, edges = styled_edges)
  })

  output$drug_network <- renderVisNetwork({
    data <- filtered_data()
    if (nrow(data$nodes) == 0 || nrow(data$edges) == 0) return(NULL)

    visNetwork(data$nodes, data$edges) %>%
      visEdges(
        smooth = FALSE,
      ) %>%
      visNodes(
        font = list(
          color = "#333333",
          size = 18,
          face = "Arial",
          strokeWidth = 2,
          background = "rgba(255,255,255,0.8)",
          shapeProperties = list(useImageSize = TRUE)

        ),
        shadow = TRUE
        ) %>%
      visOptions(
        highlightNearest = list(enabled = TRUE, degree = 1, hover = TRUE),
        selectedBy = NULL
      ) %>%

      visInteraction(
        dragNodes = TRUE,
        dragView = TRUE,
        zoomView = TRUE,
        tooltipDelay = 100
      ) %>%
      visPhysics(
        solver = "forceAtlas2Based",
        forceAtlas2Based = list(gravitationalConstant = -50),
        stabilization = list(enabled = TRUE, iterations = 150)
      ) %>%
      visLayout(randomSeed = 123, improvedLayout = TRUE)
  })

  output$interaction_pie <- renderPlotly({
    req(selected_drug())
    data <- filtered_data()$edges
    if (nrow(data) == 0) return(NULL)

    # Prepare data
    df <- data %>%
      mutate(
        interaction_category = tolower(coalesce(interaction_category, "unknown")),
        severity = dplyr::case_when(
          width == 2 ~ "Minor",
          width == 4 ~ "Moderate",
          width == 6 ~ "Major",
          TRUE       ~ "Unknown"
        )
      )

    # Outer ring (severity-level per interaction type)
    outer <- df %>%
      count(interaction_category, severity) %>%
      mutate(
        ids    = paste(interaction_category, severity, sep = " - "),
        labels = severity,
        parents = interaction_category,
        color = sapply(severity, function(x) severity_color_map[[x]] %||% "#cccccc")
      )

    # Inner ring (interaction types)
    inner <- df %>%
      count(interaction_category) %>%
      mutate(
        ids = interaction_category,
        labels = interaction_category,
        parents = "",
        color = sapply(interaction_category, function(x) interaction_color_map[[x]] %||% "#cccccc")
      )

    full_data <- bind_rows(inner, outer)

    plot_ly(
      data = full_data,
      ids = ~ids,
      labels = ~labels,
      parents = ~parents,
      values = ~n,
      type = "sunburst",
      branchvalues = "total",
      maxdepth = 2,
      marker = list(colors = full_data$color),
      hovertemplate = "<b>%{label}</b><br>Count: %{value}<extra></extra>"
    ) %>%
    layout(
      margin = list(t = 30, b = 30, l = 10, r = 10),
      autosize = TRUE,
      uniformtext = list(minsize = 10, mode = "hide")
    )
  })


}
