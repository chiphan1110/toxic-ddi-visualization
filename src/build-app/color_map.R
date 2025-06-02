get_interaction_colors <- function(interaction_types) {
  # Create a named color vector (1 unique color per interaction type)
  palette <- RColorBrewer::brewer.pal(n = max(3, min(8, length(interaction_types))), "Set2")
  if (length(interaction_types) > length(palette)) {
    # Repeat colors if not enough
    palette <- rep(palette, length.out = length(interaction_types))
  }
  
  names(palette) <- interaction_types
  return(palette)
}
