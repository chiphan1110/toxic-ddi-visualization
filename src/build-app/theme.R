theme <- tags$head(
  tags$style(HTML("
    html, body {
      height: 100%;
      margin: 0;
      padding: 0;
      overflow: hidden;
      font-family: 'Segoe UI', sans-serif;
      background-color: #f3f6fb;
      color: #1b1b1b;
    }

    .app-container {
      height: 100vh;
      display: flex;
      flex-direction: column;
    }
    
    /* HEADER STYLING */
      .app-header {
        background: linear-gradient(90deg, #00695c, #26c6da);
        color: white;
        padding: 20px 32px;
        font-family: 'Segoe UI', sans-serif;
        display: flex;
        align-items: center;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
        border-bottom-left-radius: 12px;
        border-bottom-right-radius: 12px;
      }

      .header-left {
        display: flex;
        align-items: center;
        gap: 16px;
      }

      .header-text-block {
        display: flex;
        flex-direction: column;
      }

      .header-title {
        font-size: 24px;
        font-weight: 700;
        letter-spacing: 0.5px;
      }

      .header-subtitle {
        font-size: 14px;
        opacity: 0.85;
        margin-top: 2px;
        font-weight: 400;
      }


    /* MAIN LAYOUT */
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
      background-color: #ffffff;
      border-right: 1px solid #d0d7de;
      box-shadow: 2px 0 6px rgba(0,0,0,0.04);
      border-top-right-radius: 12px;


    }

    .main-content {
      flex: 1;
      display: flex;
      flex-direction: column;      
      overflow: auto;
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
      background-color: #e6fafa;
      box-shadow: 0 2px 6px rgba(0, 0, 0, 0.06);
      border-radius: 12px;
      padding: 12px;
      border: 1px solid #e1e4e8;
      margin-bottom: 8px !important
    }

    /* FILTER CARDS */

    .filters-card {
      margin-top: 20px;
      background-color: #e6fafa;
      box-shadow: 0 2px 6px rgba(0, 0, 0, 0.06);
      border-radius: 12px;
      padding: 16px;
      border: 1px solid #e1e4e8;
    }

    .filters-card label {
      font-size: 14px;
      font-weight: 500;
      color: #1e2a34;
      margin-bottom: 4px;
      display: block;
    }

    .filter-panel {
      display: flex;
      flex-direction: column;
      gap: 12px;
      margin-top: 12px;
      width: 100%;              
    }
    .filter-panel > * {
      margin-bottom: 12px;
    }
    
    .filters-card > .ms-Text {
      font-weight: 600;
      font-size: 15px;
      margin-bottom: 10px;
      color: #1e2a34;
    }

     /* Sidebar Text (Navigation Links etc.) */
      .app-sidebar .ms-Nav-link {
        font-size: 14px;
        font-weight: 500;
        color: #1e2a34;
      }

      /* Hover State */
      .app-sidebar .ms-Nav-link:hover {
        background-color: #cbecec;
        color: #00796b;
      }

      /* Selected Link */
      .app-sidebar .ms-Nav-link.is-selected {
        background-color: #b2dfdb;
        font-weight: 600;
        color: #004d40;
      }

    .ms-Icon {
      color: #1e2a34;;
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

    .card-container {
      background-color: #ffffff;
      border-radius: 12px;
      box-shadow: 0 2px 6px rgba(0,0,0,0.06);
      width: 100%;
      overflow: visible;
    }

    .single-drug-layout h4 {
      font-size: 18px;
      font-weight: 600;
      color: #1a1a1a;
    }

    .query-card-container {
      transition: box-shadow 0.3s ease;
      border-top-left-radius: 12px;
      border-top-right-radius: 12px;
    }

    .query-card-container:hover {
      box-shadow: 0 2px 8px rgba(0,0,0,0.05);
    }


    /* Interaction Card */
    .interaction-card {
      background-color: #ffffff;
      border-radius: 12px;
      padding: 20px;
      margin-top: 10px;
      box-shadow: 0 2px 6px rgba(0, 0, 0, 0.06);
      border-left: 5px solid #1976d2;
      transition: box-shadow 0.3s ease;
    }

    .interaction-card:hover {
      box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
    }

    .interaction-title {
      font-size: 18px;
      font-weight: 600;
      display: flex;
      align-items: center;
      gap: 8px;
      margin-bottom: 10px;
    }

    .interaction-severity {
      font-weight: 600;
    }

  "))
)
