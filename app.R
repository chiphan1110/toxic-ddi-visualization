library(shiny)
library(dplyr)
library(readr)
library(visNetwork)
library(bslib)
library(shinycssloaders)


# Load data and shared scripts
source("src/data-processing/prepare_ddi_network.R")
source("src/build-app/color_map.R")
source("src/build-app/theme.R")
source("src/build-app/ui_main_network.R")       
source("src/build-app/ui_custom_query.R")
source("src/build-app/server_main_network.R")  
source("src/build-app/server_custom_query.R")

# Prepare static data
cat("→ Preparing data...\n")
ddi_graph <- prepare_ddi_network()

# Get all interaction types and apply colors
interaction_types <- unique(ddi_graph$edges$interaction_type)
color_map <- get_interaction_colors(interaction_types)

# Use full dataset with colors
nodes <- ddi_graph$nodes
edges <- ddi_graph$edges %>%
  mutate(color = color_map[interaction_type])

# Create plain list to pass to UI
initial_data <- list(
  nodes = nodes,
  edges = edges,
  interaction_types = interaction_types
)

# Define UI 
ui <- app_ui(global_data = initial_data)

# Define Server
server <- function(input, output, session) {
  global_data <- reactiveValues(
    nodes = initial_data$nodes,
    edges = initial_data$edges,
    interaction_types = initial_data$interaction_types
  )
  
  # Call server functions with correct parameter order
  server_main_network(global_data)(input, output, session)
  server_custom_query(input, output, session, global_data)
}

shinyApp(ui, server)
