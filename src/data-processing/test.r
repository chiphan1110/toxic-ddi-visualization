library(visNetwork)
library(readr)

get_unique_interaction_types <- function(data_path = "data/ddi_with_ddinter_info.csv") {
  library(readr)
  library(dplyr)

  read_csv(data_path, show_col_types = FALSE) %>%
    distinct(interaction_type_normalized) %>%
    filter(!is.na(interaction_type_normalized)) %>%
    arrange(interaction_type_normalized) %>%
    pull(interaction_type_normalized)
}

types <- get_unique_interaction_types()
print(types)

data <- readRDS("data/network_data.rds")
ddi <- read_csv("data/ddi_with_ddinter_info.csv", show_col_types = FALSE)
unique(ddi$ddinter_severity)
str(data)
# Visualize
# visNetwork(data$nodes, data$edges)

