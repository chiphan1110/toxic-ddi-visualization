library(dplyr)
library(readr)
library(tidyr)
library(visNetwork)

source("src/data-processing/color_map.R")

# Load data
ddi_raw <- read_csv("data/ddi_with_ddinter_info.csv")

# Clean and deduplicate
ddi_clean <- ddi_raw %>%
  filter(!is.na(interaction_type_normalized), !is.na(drug1_id), !is.na(drug2_id)) %>%
  distinct(drug1_id, drug2_id, .keep_all = TRUE)

# Create edge list with color + width and include severity
edges <- ddi_clean %>%
  mutate(
    color = sapply(interaction_type_normalized, map_interaction_color),
    width = sapply(ddinter_severity, map_severity_weight)
  ) %>%
  select(
    from = drug1_id,
    to = drug2_id,
    title = ddinter_interaction,
    interaction_category = interaction_type_normalized,
    ddinter_severity, 
    ddinter_management,    
    width,
    color
  )

# === Node color logic ===
node_edge_counts <- edges %>%
  select(from, to, interaction_category) %>%
  pivot_longer(cols = c(from, to), names_to = "direction", values_to = "node_id") %>%
  group_by(node_id, interaction_category) %>%
  summarise(count = n(), .groups = "drop")

dominant_interaction <- node_edge_counts %>%
  group_by(node_id) %>%
  slice_max(order_by = count, n = 1, with_ties = FALSE) %>%
  ungroup() %>%
  mutate(color = sapply(interaction_category, map_interaction_color))

# Create node list
nodes <- ddi_clean %>%
  select(id = drug1_id, label = drug1_name) %>%
  bind_rows(ddi_clean %>% select(id = drug2_id, label = drug2_name)) %>%
  distinct()

# Join color to nodes
nodes <- nodes %>%
  left_join(dominant_interaction %>% select(id = node_id, color), by = "id") %>%
  mutate(color = replace_na(color, "#999999"))  # fallback color

# Save result
saveRDS(list(nodes = nodes, edges = edges), file = "data/network_data.rds")
