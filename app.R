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
nodes <- ddi_graph$nodes %>% mutate(title = label)
edges_raw <- ddi_graph$edges
interaction_types <- unique(edges_raw$interaction_type)

color_map <- get_interaction_colors(interaction_types)
# edges <- edges_raw %>%
#   mutate(color = color_map[interaction_type])

# Limit to 300 edges to test performance
edges <- edges_raw %>%
  filter(row_number() <= 300) %>%
  mutate(color = color_map[interaction_type])



# Create plain list to pass to UI
cat("→ Creating initial data...\n")
initial_data <- list(
  nodes = nodes,
  edges = edges,
  interaction_types = interaction_types
)
cat("Initial data ready: ", nrow(nodes), " nodes, ", nrow(edges), " edges\n")

# Define UI 
ui <- app_ui(global_data = initial_data)

# Define Server
server <- function(input, output, session) {
  global_data <- reactiveValues(
    nodes = initial_data$nodes,
    edges = initial_data$edges,
    interaction_types = initial_data$interaction_types
  )
app_server <- function(global_data) {
  function(input, output, session) {
    server_main_network(global_data)(input, output, session)
    server_custom_query(input, output, session, global_data)
  }
}

server <- function(input, output, session) {
  global_data <- reactiveValues(
    nodes = initial_data$nodes,
    edges = initial_data$edges,
    interaction_types = initial_data$interaction_types
  )
  app_server(global_data)(input, output, session)
}}

shinyApp(ui, server)
