server_custom_query <- function(input, output, session, global_data) {
  observeEvent(input$run_query, {
    req(input$custom_drugs)

    drug_list <- input$custom_drugs
    if (length(drug_list) < 2 || length(drug_list) > 5) {
      showNotification("Please select between 2 and 5 drugs.", type = "error")
      return()
    }

    node_subset <- global_data$nodes %>% filter(label %in% drug_list)
    edge_subset <- global_data$edges %>%
      filter(from %in% node_subset$id & to %in% node_subset$id)

    if (nrow(edge_subset) == 0) {
      showNotification("No direct interactions found between selected drugs.", type = "warning")
      return()
    }

    final_ids <- unique(c(edge_subset$from, edge_subset$to))
    node_subset <- global_data$nodes %>% filter(id %in% final_ids)

    output$custom_network <- renderVisNetwork({
      visNetwork(node_subset, edge_subset) %>%
        visEdges(color = list(color = edge_subset$color)) %>%
        visOptions(highlightNearest = TRUE) %>%
        visPhysics(stabilization = TRUE, solver = "barnesHut")
    })
  })
}
