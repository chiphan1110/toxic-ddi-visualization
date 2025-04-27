# ToxicDDI Explorer: Visualizing Toxic Drug-Drug Interactions by Type and Severity

## 1. Project High-Level Goal:

Develop an interactive dashboard that visualizes toxic drug-drug interactions using network-based diagrams, heatmaps of pairwise toxicity risk, and detailed tables for mechanism insights and severity filtering.

---

## 2. Project Description and Motivation  
### ❓Research Question

***How can we effectively visualize toxic drug-drug interactions (DDIs) to support safer prescribing practices and improve understanding of toxicity risks across different drug combinations?***

This project focuses specifically on toxic DDIs—interactions between drugs that lead to harmful toxicological outcomes such as hepatotoxicity (liver damage), nephrotoxicity (kidney damage), cardiotoxicity (QT prolongation, arrhythmias), and neurotoxicity. The question seeks to address how visualization techniques can be used to make complex toxic interaction data more accessible, interpretable, and clinically meaningful.

---

### 🧭 Motivation and Significance

Drug-drug interactions are a well-known source of adverse drug reactions (ADRs), which contribute significantly to patient morbidity, hospitalizations, and even fatalities (Jiang et al., 2022). However, despite the availability of large DDI datasets, the information is often presented in static, text-based formats that are difficult to navigate and interpret, especially when considering multiple drugs, toxicity types, and interaction mechanisms (Payne et al., 2015). Currently available drug interaction checkers primarily focus on general adverse effects or binary warnings (e.g., “avoid combination” or “monitor closely”) without providing a deeper breakdown of the specific toxicological outcomes or mechanistic pathways involved. Few existing tools offer interactive, visual exploration of toxic DDIs by toxicity category (e.g., liver, kidney, heart, nervous system) and severity. This lack of user-centered, visual interfaces poses a challenge for healthcare professionals, researchers, and students who need to understand and assess the risks of harmful drug combinations.

By developing an interactive dashboard to visualize toxic DDIs through network graphs, pairwise heatmaps, and detailed data tables, this project aims to bridge that gap—providing a tool that is not only informative but also engaging and easy to use. The visual approach allows for multi-dimensional exploration of DDIs: users can filter by drugs of interest, toxicity type, and severity level, uncovering complex relationships that are otherwise buried in static text reports. This tool could be useful for healthcare professionals, researchers, and students in pharmacology or public health by supporting safer prescribing practices and improving understanding of toxicity risks.

### 📂 Data Source and Collection Method
The dataset for this project will be assembled from publicly available drug interaction and side effect resources, focusing specifically on toxic outcomes. The primary data sources include:

- [**DrugBank Open Data**](https://go.drugbank.com/releases/latest#open-data): 
  Drug-drug interactions, mechanisms, and affected enzymes.  
 
- [**TwoSIDES Database**](https://tatonettilab.org/offsides/): Side effects associated with drug pairs, mined from FDA Adverse Event Reporting System.  

Data Preparation Steps:
1.	Crawl/download the datasets from the above sources.
2.	Filter for interactions with documented toxicological outcomes.
3.	Standardize drug names and map toxicity types into defined categories (hepatotoxicity, nephrotoxicity, cardiotoxicity, neurotoxicity, etc.).
4.	Assign severity levels (mild, moderate, severe) based on dataset annotations where available.
5.	Clean and preprocess the data to support effective visualization and user interaction.

---

## 3. Weekly Plan and Task Assignment  

| Week              | Task Description                                                    | Deliverable                                      | Assigned To   |
|-------------------|-----------------------------------------------------------------------|--------------------------------------------------|---------------|
| Week 1 (Apr 21–27) | Finalize project scope, create public GitHub repo, collect initial DDI and toxicity datasets | Repository with proposal (`proposal.md`) and data uploaded | All Members (Chi, Hiep, Hung) |
| Week 2 (Apr 28–May 4) | Data cleaning and preprocessing (drug name normalization, toxicity type and severity standardization) | Cleaned dataset ready for use                   | Hiep |
| Week 3 (May 5–11)  | Develop Shiny app structure: implement sidebar inputs (drug selection, toxicity type, severity filters) | Functional input panel with user controls       | All Members |
| Week 4 (May 12–18) | Implement network visualization using `visNetwork`, enable tooltips and coloring by toxicity type/severity | Interactive network graph integrated into app   | Chi|
| Week 5 (May 19–25) | Add pairwise toxicity heatmap and interactive data table of interactions | Heatmap and data table available in dashboard tabs | Hung |
| Week 6 (May 26–30) | Polish dashboard UI/UX, add legends, filtering functions, optional download feature | Finalized app layout with polished design       | All Members |
| Week 7 (May 31–June 6) | Final testing, debugging, write-up, and presentation preparation | Completed dashboard, well-documented code, final report, presentation slides | All Members  |

---
## Team Members:
- Phan Thi Hien Chi  
- Nguyen Mau Hoang Hiep
- Thai Ba Hung

## References
Jiang, H., Lin, Y., Ren, W., Fang, Z., Liu, Y., Tan, X., Lv, X., & Zhang, N. (2022). Adverse drug reactions and correlations with drug-drug interactions: A retrospective study of reports from 2011 to 2020. Frontiers in pharmacology, 13, 923939. https://doi.org/10.3389/fphar.2022.923939

Payne, T. H., Hines, L. E., Chan, R. C., Hartman, S., Kapusnik-Uner, J., Russ, A. L., Chaffee, B. W., Hartman, C., Tamis, V., Galbreth, B., Glassman, P. A., Phansalkar, S., van der Sijs, H., Gephart, S. M., Mann, G., Strasberg, H. R., Grizzle, A. J., Brown, M., Kuperman, G. J., Steiner, C., … Malone, D. C. (2015). Recommendations to improve the usability of drug-drug interaction clinical decision support alerts. Journal of the American Medical Informatics Association : JAMIA, 22(6), 1243–1250. https://doi.org/10.1093/jamia/ocv011