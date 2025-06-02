library(dplyr)
library(readr)
library(tidyr)
library(memoise)
library(RColorBrewer)

# Cache the data preparation function
prepare_ddi_network <- memoise(function(data_path = "data/toxicity_ddi_normalized.csv") {
  # Read in the dataset with optimized settings
  ddi_data <- read_csv(
    data_path,
    show_col_types = FALSE,
    col_types = cols(
      drug1_name = col_character(),
      drug2_name = col_character(),
      interaction_type_normalized = col_character()
    )
  )
  
  # Generate node list (unique drug names with IDs) - optimized
  nodes <- ddi_data %>%
    select(drug1_name, drug2_name) %>%
    pivot_longer(
      cols = everything(),
      values_to = "drug",
      names_to = NULL
    ) %>%
    distinct(drug) %>%
    arrange(drug) %>%
    mutate(
      id = row_number(),
      title = drug,  # Add title for tooltips
      group = "drug"  # Add group for styling
    ) %>%
    select(id, label = drug, title, group)

  # Get unique interaction types and their colors
  interaction_types <- unique(ddi_data$interaction_type_normalized)
  color_map <- get_interaction_colors(interaction_types)

  # Generate edge list (joining with node IDs) - optimized
  edges <- ddi_data %>%
    left_join(
      nodes %>% select(id, label),
      by = c("drug1_name" = "label")
    ) %>%
    rename(from = id) %>%
    left_join(
      nodes %>% select(id, label),
      by = c("drug2_name" = "label")
    ) %>%
    rename(to = id) %>%
    select(from, to, interaction_type = interaction_type_normalized) %>%
    # Add edge attributes for better visualization
    mutate(
      color = color_map[interaction_type]
    )

  # Return processed data
  list(
    nodes = nodes,
    edges = edges,
    metadata = list(
      total_drugs = nrow(nodes),
      total_interactions = nrow(edges),
      unique_interaction_types = interaction_types,
      color_map = color_map
    )
  )
})