library(shiny)
library(shinydashboard)

app_ui <- function(global_data) {
  dashboardPage(
    skin = "blue",
    dashboardHeader(title = "💊 Toxic-DDI Viz"),
    dashboardSidebar(
      sidebarMenu(
        menuItem("Main Network", tabName = "main_network", icon = icon("project-diagram")),
        menuItem("Custom Query", tabName = "custom_query", icon = icon("search"))
      )
    ),
    dashboardBody(
      tabItems(
        tabItem(tabName = "main_network", ui_main_network(global_data)),
        tabItem(tabName = "custom_query", ui_custom_query(global_data))
      )
    )
  )
}
