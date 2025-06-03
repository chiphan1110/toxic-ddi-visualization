theme <- tags$head(
  tags$style(HTML("
    html, body {
      height: 100%;
      margin: 0;
      padding: 0;
      overflow: hidden;
    }

    .app-container {
      height: 100vh;
      display: flex;
      flex-direction: column;
    }

    .app-header {
      height: 80px;
      flex-shrink: 0;
      background-color: #e0f0ff;
      padding: 12px 20px;
      display: flex;
      align-items: center;
    }

    .main-layout {
      flex: 1;
      display: flex;
      overflow: hidden;
      width: 100%;
    }

    .left-panel {
      width: 240px;
      flex-shrink: 0;
      display: flex;
      flex-direction: column;
      padding: 12px;
    }

    .main-content {
      flex: 1;
      display: flex;
      flex-direction: column;      overflow: hidden;
      background-color: #ffffff;
    }

    .network-plot-container {
      flex: 1;
      display: flex;
      background-color: #1b1a19;
      border-radius: 8px;
      overflow: hidden;
    }

    .vis-network {
      flex: 1;
    }

    .app-sidebar {
      background-color: #ffffff;
      box-shadow: 0 2px 6px rgba(0, 0, 0, 0.06);
      border-radius: 12px;
      padding: 12px;
    }

    .filters-card {
      background-color: #ffffff;
      box-shadow: 0 2px 6px rgba(0, 0, 0, 0.06);
      border-radius: 12px;
      padding: 16px;
    }

    .filter-panel {
      display: flex;
      flex-direction: column;
      gap: 12px;
      margin-top: 12px;
      width: 100%;              
    }

    .ms-Nav-link {
      font-size: 14px;
      padding: 8px 12px;
      border-left: 3px solid transparent;
      color: #333333;
    }

    .ms-Nav-link:hover {
      background-color: #e6f0fb;
      border-left: 3px solid #0078D4;
    }

    .ms-Nav-link.is-selected {
      background-color: #d9ecfd;
      border-left: 3px solid #0078D4;
      font-weight: 600;
    }

    .ms-Icon {
      color: #004e92;
    }

    /* Style for select inputs */
    .selectize-input {
      border-radius: 4px !important;
      border: 1px solid #d1d1d1 !important;
      padding: 6px 8px !important;
    }

    .selectize-input:focus {
      border-color: #0078D4 !important;
      box-shadow: 0 0 0 2px rgba(0, 120, 212, 0.2) !important;
    }

    /* Styles for Single Drug View layout */
    .single-drug-layout {
      display: flex;
      flex-direction: column;
      height: 100%; /* Matches the height from the Stack */
      background-color: #ffffff; /* Matches the background color from the Stack */
      flex: 1; /* Matches the flex property from the Stack */
    }

    .network-plot-container {
      flex: 1;
      display: flex;
      background-color: #1b1a19;
      border-radius: 8px;
      overflow: hidden;
    }
  "))
)
