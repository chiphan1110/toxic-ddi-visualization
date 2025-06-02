server_main_network <- function(global_data) {
  function(input, output, session) {

    filtered_edges <- reactive({
      if (input$type_filter == "All") {
        global_data$edges
      } else {
        global_data$edges %>% filter(interaction_type == input$type_filter)
      }
    })

    filtered_nodes <- reactive({
      ids <- unique(c(filtered_edges()$from, filtered_edges()$to))
      global_data$nodes %>% filter(id %in% ids)
    })

    output$ddi_network <- renderVisNetwork({
      if (nrow(filtered_edges()) == 0 || nrow(filtered_nodes()) == 0) {
        showNotification("No network found for this interaction type.", type = "warning")
        return(NULL)
      }

      visNetwork(filtered_nodes(), filtered_edges()) %>%
        visEdges(smooth = FALSE) %>%
        visOptions(highlightNearest = TRUE, nodesIdSelection = TRUE) %>%
        visPhysics(stabilization = TRUE, solver = "barnesHut")
    })

  }
}
