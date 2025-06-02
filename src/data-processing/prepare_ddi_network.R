library(dplyr)
library(readr)
library(tidyr)

prepare_ddi_network <- function(data_path = "data/toxicity_ddi_normalized.csv") {
  
  # Read in the dataset
  ddi_data <- read_csv(data_path, show_col_types = FALSE)
  
  # Generate node list (unique drug names with IDs)
  nodes <- ddi_data %>%
    select(drug1_name, drug2_name) %>%
    pivot_longer(cols = everything(), values_to = "drug") %>%
    distinct(drug) %>%
    arrange(drug) %>%
    mutate(id = row_number()) %>%
    select(id, label = drug)

  # Generate edge list (joining with node IDs)
  edges <- ddi_data %>%
    left_join(nodes, by = c("drug1_name" = "label")) %>%
    rename(from = id) %>%
    left_join(nodes, by = c("drug2_name" = "label")) %>%
    rename(to = id) %>%
    select(from, to, interaction_type = interaction_type_normalized)

  list(nodes = nodes, edges = edges)
}