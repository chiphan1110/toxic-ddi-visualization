ui_main_network <- function(global_data) {
  fluidPage(
    titlePanel("Toxic Drug-Drug Interaction Network"),
    sidebarLayout(
      sidebarPanel(
        selectInput("type_filter", "Select Interaction Type:",
                    choices = c("All", global_data$interaction_types),
                    selected = "neurotoxicity")
      ),
      mainPanel(
        shinycssloaders::withSpinner(
          visNetworkOutput("ddi_network", height = "700px"),
          type = 4,
          color = "#0078d4"
        )
      )
    )
  )
}
