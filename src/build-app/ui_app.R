app_ui <- function(global_data) {
  fluidPage(
    titlePanel("Toxic Drug-Drug Interaction Network"),
    tabsetPanel(
      tabPanel("Main Network", ui_main_network(global_data)),
      tabPanel("Custom Query", ui_custom_query(global_data))
    )
  )
} 