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
            selectedKey = NULL, 
            groups = list(
              list(
                links = list(
                  list(name = "Network Overview", key = "network", url = "#", icon = "Globe"),
                  list(name = "Single Drug View", key = "single", url = "#", icon = "SingleBookmark"),
                  list(name = "Drug Pair Query", key = "query", url = "#", icon = "Search")
                )
              )
            ),
            onLinkClick = JS("
              function(ev, item) {
                if (item && item.key) {
                  Shiny.setInputValue('selected_tab', item.key, {priority: 'event'});
                }
                if (ev) ev.preventDefault();
                return false;
              }
            ")
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
        ),
        # Single Drug (only for Single Drug View tab)
        conditionalPanel(
          condition = "input.selected_tab === 'single'",
          div(
            class = "filters-card",
            Text(variant = "mediumPlus", "Drug Selection", block = TRUE),
            selectizeInput(
              inputId = "single_drug_select",
              label = NULL,
              choices = NULL,
              selected = NULL,
              options = list(
                placeholder = 'Type a drug name...',
                maxOptions = 10
              ),            )
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

  observe({
    req(input$selected_tab == "single")  # optional but safer

    drug_names <- sort(unique(ddi_network_data$nodes$label))

    updateSelectizeInput(
      session = session,
      inputId = "single_drug_select",
      choices = drug_names,
      server = TRUE
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
  callModule(server_single_drug, "single_drug", 
           ddi_network_data = ddi_network_data,
           selected_drug = reactive(input$single_drug_select))

  # callModule(server_pair_query, "pair_query")
}

# Run the app
shinyApp(ui, server)
