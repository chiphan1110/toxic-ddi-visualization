library(tidyr)
library(dplyr)
library(scales)
library(visNetwork)

source("src/data-processing/color_map.R")


# === Load pre-processed network data ===
# This contains: 
#   - nodes: each drug with id and label
#   - edges: each interaction with precomputed color, width, title, interaction_category
ddi_network_data <- readRDS("data/network_data.rds")

# Define severity order for filtering UI
severity_order <- c("Minor", "Moderate", "Major")

# === Main server logic for the Network tab ===
server_main_network <- function(input, output, session, type_filter, severity_filter) {

  # --- 1. Filter edges reactively based on input filters ---
  filtered_edges <- reactive({
    type <- type_filter()
    severity <- severity_filter()
    edges <- ddi_network_data$edges

    # Filter by interaction type (i.e., toxicity type)
    if (!is.null(type) && type != "All") {
      edges <- edges[edges$interaction_category == type, ]
    }

    # Filter by severity 
    if (!is.null(severity) && severity != "All") {
      severity_map <- c(Minor = 2, Moderate = 4, Major = 6)
      target_width <- severity_map[[severity]]
      edges <- edges[edges$width == target_width, ]
    }

    edges
  })

  # --- 2. Filter nodes based on what edges are shown ---
    filtered_nodes <- reactive({
    edges <- filtered_edges()
    involved_ids <- unique(c(edges$from, edges$to))

    # Calculate degree
    degree_table <- table(c(edges$from, edges$to))
    nodes <- ddi_network_data$nodes %>% filter(id %in% involved_ids)

    nodes <- nodes %>%
        mutate(
        degree = degree_table[as.character(id)] %>% replace_na(1)  # fallback if missing
        )

    nodes
    })


  # --- 3. Render the network visualization ---
  output$network_plot <- renderVisNetwork({
        edges <- filtered_edges()
        nodes <- filtered_nodes()

        if (nrow(edges) == 0 || nrow(nodes) == 0) {
        showNotification("No interactions match the selected filters.", type = "warning")
        return(NULL)
        }

        # === Visual enhancements===
        nodes$color <- lapply(nodes$color, function(hex_color) {
        # Convert HEX to RGB
        rgb <- grDevices::col2rgb(hex_color)
        rgba <- sprintf("rgba(%d, %d, %d, 0.7)", rgb[1], rgb[2], rgb[3])

        list(
            background = rgba,      # soft semi-transparent center
            border = "#FFFFFF",     # white halo ring
            highlight = "#FFFFFF"   # hover effect
        )
        })

        nodes <- as.data.frame(nodes)
        nodes$degree <- as.numeric(nodes$degree)  # ← convert from table to numeric
        nodes$degree[is.na(nodes$degree)] <- 0    # ← fallback for NA values

        nodes$title <- paste0("Drug: ", nodes$label)
        nodes$shape <- "dot"
        nodes$size <- rescale(log(nodes$degree + 1), to = c(30, 80))
        nodes$font <- replicate(nrow(nodes), list(size = 16, color = "#FFFFFF"), simplify = FALSE)
        
        edges$color <- sapply(edges$color, function(hex) {
          rgb <- col2rgb(hex)
          sprintf("rgba(%d, %d, %d, 0.4)", rgb[1], rgb[2], rgb[3])  # translucent glow
        })

        nodes$size <- as.numeric(nodes$size)

        # === Render the graph ===
        visNetwork(nodes = nodes, edges = edges) %>%
        # visIgraphLayout(layout = "layout_on_sphere") %>%
        visNodes(borderWidth = 0.5, borderWidthSelected = 2) %>%
        visEdges(smooth = list(enabled = TRUE, type = "dynamic")) %>%
        visOptions(
            highlightNearest = list(enabled = TRUE, degree = 1, hover = TRUE),
        ) %>%
        visLayout(hierarchical = FALSE) %>%
        visPhysics(
        solver = "forceAtlas2Based",
        forceAtlas2Based = list(
            gravitationalConstant = -80,     # more negative = more spread
            centralGravity = 0.005,          # lower = looser center
            springLength = 100,              # longer springs = looser clusters
            springConstant = 0.08,           # lower = more flexible
            damping = 0.2,                   # stabilizes movement
            avoidOverlap = 1                 # avoid overlap between nodes
        ),
        stabilization = list(
            enabled = TRUE,
            iterations = 300,
            updateInterval = 50
        )
        )
    })
}
