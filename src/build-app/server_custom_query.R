server_custom_query <- function(input, output, session, global_data) {
  # Cache the filtered data
  filtered_data <- reactive({
    req(input$custom_drugs)
    
    drug_list <- input$custom_drugs
    if (length(drug_list) < 2 || length(drug_list) > 5) {
      showNotification("Please select between 2 and 5 drugs.", type = "error")
      return(NULL)
    }

    node_subset <- global_data$nodes %>% filter(label %in% drug_list)
    edge_subset <- global_data$edges %>%
      filter(from %in% node_subset$id & to %in% node_subset$id)

    if (nrow(edge_subset) == 0) {
      showNotification("No direct interactions found between selected drugs.", type = "warning")
      return(NULL)
    }

    final_ids <- unique(c(edge_subset$from, edge_subset$to))
    node_subset <- global_data$nodes %>% filter(id %in% final_ids)

    list(nodes = node_subset, edges = edge_subset)
  }) %>% bindCache(input$custom_drugs)

  # Cache the network layout
  network_layout <- reactive({
    req(filtered_data())
    data <- filtered_data()
    
    visNetwork(data$nodes, data$edges) %>%
      visPhysics(
        stabilization = list(
          enabled = TRUE,
          iterations = 50,
          updateInterval = 25,
          fit = TRUE
        ),
        solver = "forceAtlas2Based",
        forceAtlas2Based = list(
          gravitationalConstant = -100,
          centralGravity = 0.005,
          springLength = 200,
          springConstant = 0.04,
          damping = 0.4,
          avoidOverlap = 0.5
        )
      ) %>%
      visLayout(randomSeed = 123)
  }) %>% bindCache(filtered_data())

  observeEvent(input$run_query, {
    req(network_layout())
    
    output$custom_network <- renderVisNetwork({
      network_layout() %>%
        visEdges(
          smooth = list(
            enabled = TRUE,
            type = "continuous",
            forceDirection = "none"
          ),
          width = 0.5,
          color = list(
            inherit = FALSE,
            color = "#848484",
            highlight = "#ff0000"
          )
        ) %>%
        visOptions(
          highlightNearest = list(
            enabled = TRUE,
            degree = 1,
            hover = TRUE,
            algorithm = "hierarchical"
          ),
          nodesIdSelection = TRUE
        ) %>%
        visInteraction(
          dragNodes = TRUE,
          dragView = TRUE,
          zoomView = TRUE,
          navigationButtons = TRUE,
          keyboard = TRUE,
          tooltipDelay = 200
        ) %>%
        visEvents(
          type = "once",
          startStabilizing = "function() {
            document.getElementById('custom_network').style.cursor = 'wait';
          }",
          stabilizationIterationsDone = "function() {
            document.getElementById('custom_network').style.cursor = 'default';
          }"
        )
    })
  })
}
