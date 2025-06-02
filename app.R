library(shiny)
library(shiny.fluent)
library(shinycssloaders)
library(visNetwork)
library(shinyjs)

# Load modular components
source("src/build-app/theme.R")                
source("src/build-app/ui_main_network.R")      # Network Overview page UI
source("src/build-app/ui_single_drug.R")       # Single Drug View page UI
source("src/build-app/ui_pair_query.R")        # Drug Pair Query page UI
source("src/build-app/server_main_network.R")  # Network Overview server logic
source("src/build-app/server_single_drug.R")   # Single Drug View server logic
source("src/build-app/server_pair_query.R")    # Drug Pair Query server logic

# Load network data
ddi_network_data <- readRDS("data/network_data.rds")
severity_order <- c("Minor", "Moderate", "Major")

# ==========================================
# UI
ui <- fluidPage(
  theme,
  div(
    class = "app-container",

    # ---------- HEADER ----------
    div(
      class = "app-header",
      div(
        class = "header-content",
        div(
          class = "header-text",
          Text(variant = "xxLarge", "Toxic Drug-Drug Interaction Dashboard"),
        )
      )
    ),

    # ---------- MAIN LAYOUT ----------
    div(
      class = "main-layout",

      # ----- LEFT PANEL: Sidebar + Filters -----
      div(
        class = "left-panel",

        # Sidebar
        div(
          class = "app-sidebar",
          Nav(
            selectedKey = "network",
            groups = list(
              list(
                links = list(
                  list(name = "Network Overview", key = "network", url = "javascript:void(0)", icon = "Globe"),
                  list(name = "Single Drug View", key = "single", url = "javascript:void(0)", icon = "SingleBookmark"),
                  list(name = "Drug Pair Query", key = "query", url = "javascript:void(0)", icon = "Search")
                )
              )
            ),
            onLinkClick = JS("function(ev, item) {
              var selectedKey = item.key;
              Shiny.setInputValue('selected_tab', selectedKey, {priority: 'event'});
              if (ev && ev.nativeEvent) {
                ev.nativeEvent.stopImmediatePropagation();
              }
              if (ev) {
                ev.stopPropagation();
                ev.preventDefault();
              }
              return false;
            }")
          )
        ),

        # Filter panel (only for Network Overview tab)
        conditionalPanel(
          condition = "input.selected_tab === 'network'",
          div(
            class = "filters-card",
            Text(variant = "mediumPlus", "Filters", block = TRUE),
            div(
              class = "filter-panel",
              Dropdown.shinyInput(
                inputId = "type_filter",
                label = "Interaction Type",
                options = list()  # populated in server
              ),
              Dropdown.shinyInput(
                inputId = "severity_filter",
                label = "Severity",
                options = list()  # populated in server
              )
            )
          )
        )
      ),

      # ----- MAIN CONTENT AREA -----
      div(
        class = "main-content",
        uiOutput("mainContent")
      )
    )
  )
)

# ==========================================
# SERVER
server <- function(input, output, session) {
  # Track selected tab
  current_tab <- reactiveVal("network")

  observeEvent(input$selected_tab, {
    isolate({
      current_tab(input$selected_tab)
    })
  }, ignoreInit = TRUE)

  # Update filter dropdown choices dynamically
  observe({
    updateDropdown.shinyInput(
      session = session,
      inputId = "type_filter",
      options = unique(na.omit(ddi_network_data$edges$interaction_category)) |>
        sort() |>
        (\(x) c("All", x))() |>
        lapply(function(opt) list(key = opt, text = opt)),
      value = "All"  # Set default value
    )

    updateDropdown.shinyInput(
      session = session,
      inputId = "severity_filter",
      options = c("All", severity_order) |>
        lapply(function(opt) list(key = opt, text = opt)),
      value = "All"  # Set default value
    )
  })

  # Render the appropriate UI for each tab
  output$mainContent <- renderUI({
    switch(current_tab(),
           "network" = ui_main_network("main_network"),
           "single"  = ui_single_drug("single_drug"),
           "query"   = ui_pair_query("pair_query"),
           h2("Page not found"))
  })

  # Call server modules
  callModule(server_main_network, "main_network", 
    type_filter = reactive(input$type_filter %||% "All"),
    severity_filter = reactive(input$severity_filter %||% "All")
  )
  # callModule(server_single_drug, "single_drug")
  # callModule(server_pair_query, "pair_query")
}

# Run the app
shinyApp(ui, server)
