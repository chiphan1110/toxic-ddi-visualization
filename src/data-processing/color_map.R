# === Color for interaction types ===
interaction_color_map <- list(
  cardiotoxicity = "#FF4C4C",
  nephrotoxicity = "#00CFFF",
  hepatotoxicity = "#FFA947",
  neurotoxicity = "#B266FF",
  ototoxicity = "#FFD700",
  `pulmonary toxicity` = "#3CFFB3",
  unknown = "#666666"
)


# === Weight for severity levels ===
severity_weight_map <- list(
  Minor = 5,
  Moderate = 8,
  Major = 10,
  Unknown = 2,
  None = 2
)


# Utility functions
map_interaction_color <- function(type) {
  type <- tolower(type)  # normalize input
  interaction_color_map[[type]] %||% interaction_color_map$unknown
}


map_severity_weight <- function(sev) {
  severity_weight_map[[sev]] %||% severity_weight_map$Unknown
}

get_interaction_color_map <- function() {
  interaction_color_map
}