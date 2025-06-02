server_main_network <- function(global_data) {
  function(input, output, session) {
    # Cache the filtered edges with size limit
    filtered_edges <- reactive({
      req(input$type_filter)
      if (input$type_filter == "All") {
        global_data$edges
      } else {
        global_data$edges %>% filter(interaction_type == input$type_filter)
      }
    }) %>% bindCache(input$type_filter, cache = "app")

    # Cache the filtered nodes with size limit
    filtered_nodes <- reactive({
      req(filtered_edges())
      ids <- unique(c(filtered_edges()$from, filtered_edges()$to))
      global_data$nodes %>% filter(id %in% ids)
    }) %>% bindCache(filtered_edges(), cache = "app")

    # Cache the network layout
    network_layout <- reactive({
      req(filtered_edges(), filtered_nodes())
      if (nrow(filtered_edges()) == 0 || nrow(filtered_nodes()) == 0) {
        return(NULL)
      }
      
      # Pre-calculate node positions for better performance
      visNetwork(filtered_nodes(), filtered_edges()) %>%
        visPhysics(
          stabilization = list(
            enabled = TRUE,
            iterations = 100,  # Increased for better layout with more nodes
            updateInterval = 25,
            fit = TRUE
          ),
          solver = "forceAtlas2Based",
          forceAtlas2Based = list(
            gravitationalConstant = -200,  # Increased repulsion for more nodes
            centralGravity = 0.01,        # Adjusted for more nodes
            springLength = 100,           # Reduced for more nodes
            springConstant = 0.08,        # Adjusted for more nodes
            damping = 0.4,
            avoidOverlap = 0.5
          )
        ) %>%
        visLayout(randomSeed = 123)  # Fixed seed for consistent layouts
    }) %>% bindCache(filtered_nodes(), filtered_edges(), cache = "app")

    output$ddi_network <- renderVisNetwork({
      req(network_layout())
      
      if (is.null(network_layout())) {
        showNotification("No network found for this interaction type.", type = "warning")
        return(NULL)
      }

      network_layout() %>%
        visEdges(
          smooth = list(
            enabled = TRUE,
            type = "continuous",
            forceDirection = "none"
          ),
          width = 0.5,  # Thinner edges for better visibility
          color = list(
            inherit = TRUE,  # Use the color from the data
            highlight = "#ff0000"  # Only specify highlight color
          ),
          arrows = list(
            to = list(enabled = FALSE)  # Disable arrows
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
            document.getElementById('ddi_network').style.cursor = 'wait';
          }",
          stabilizationIterationsDone = "function() {
            document.getElementById('ddi_network').style.cursor = 'default';
          }"
        )
    })
  }
}
