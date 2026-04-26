# ADS Assessment: Clinical Trial Data Engineering & AI
My personal submission for the ADS position within Roche Products Ltd, as per the requirements from the DSX Assessment document.

# Ovewrview:
This repository contains an end-to-end solution a clinical data engineering assessment, covering:
- Statistical package development in R
- SDTM -> ADSL derivations using open source packages such as Pharmaverse/Admiral
- RESTful API design for clinical data access
- A Generative AI assistant for natural language querying

The implementation emphasises robustness, reproducibility and defensible design decisions, reflecting the typical constraints seen within regulated clinical environments.

## Repository Structure:
```
├───question-1-descriptiveStatsPackage
│   └───descriptiveStats
│       │   .gitignore
│       │   .Rbuildignore
│       │   .Rhistory
│       │   DESCRIPTION
│       │   descriptiveStats.Rproj
│       │   NAMESPACE
│       │   README.md
│       │   README.Rmd
│       │   
│       ├───man
│       │       calc_iqr.Rd
│       │       calc_mean.Rd
│       │       calc_median.Rd
│       │       calc_mode.Rd
│       │       calc_q1.Rd
│       │       calc_q3.Rd
│       │       handle_na.Rd
│       │       validate_numeric.Rd
│       │       
│       ├───R
│       │       calc_iqr.R
│       │       calc_mean.R
│       │       calc_median.R
│       │       calc_mode.R
│       │       calc_q1.R
│       │       calc_q3.R
│       │       handle_na.R
│       │       validate_numeric.R
│       │       
│       └───tests
│           └───testthat
│                   testthat.R
│                   
├───question-2-SDTM-DS-Creation
│       02_create_ds_domain.R
│       sdtm_ct.csv
│       
├───question-3-ADaM-ADSL-Creation
│       create_adsl.R
│       
├───question-4-TLG-adverse-events
│       01_create_ae_summary.R
│       02_create_visualisations.R
│       03_create_listings.R
│       ae_listing.html
│       ae_severity_plot.png
│       ae_severity_plot_2.png
│       ae_summary_table.html
│       
├───question-5-clinical-data-API
│   │   adae.csv
│   │   API_file.py
│           
└───question-6-GenAI-Assistant
        adae.csv
        gen-ai-agent.py
        test.py
```
