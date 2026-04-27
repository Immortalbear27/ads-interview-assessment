# ADS Assessment: Clinical Trial Data Engineering & AI
My personal submission for the ADS position within Roche Products Ltd, as per the requirements from the DSX Assessment document.

# Overview
This repository presents an end-to-end solution to a clinical data engineering assessment, covering statistical programming, SDTM/ADaM transformations, safety reporting, API development, and applied generative AI.

This implementation focuses on:
- Statistical package development in R
- SDTM -> ADSL derivations using open source packages such as Pharmaverse/Admiral
- RESTful API design for clinical data access
- A Generative AI assistant for natural language querying

The implementation emphasises robustness, reproducibility and defensible design decisions, reflecting the typical constraints seen within regulated clinical environments.

## Repository Structure
```
C:.
│   ads-interview-assessment.Rproj
│   ae_severity_distribution.png
│   README.md
│   README.Rmd
│   
├───question-1-descriptiveStatsPackage
│   └───descriptiveStats
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
│   │   01_create_ae_summary.R
│   │   02_create_visualisations.R
│   │   03_create_listings.R
│   │   
│   └───outputs
│           ae_listing.html
│           ae_severity_distribution.png
│           ae_summary_table.html
│           top10_ae_ci_plot.png
│           
├───question-5-clinical-data-API
│       adae.csv
│       API_file.py
│           
└───question-6-GenAI-Assistant
        adae.csv
        gen-ai-agent.py
        test.py
```

## Descriptive Stats Package - Question 1
A structured R package implementing core statistical functions with full documentation and test coverage.

### Functions
- Mean, Median and Mode
- Quartiles (Q1, Q3)
- Interquartile Range (IQR)

### Engineering Approach
- Centralised validation (`validate_numeric`) to enforce input
- Consistent NA handling via a dedicated helper function (`handle_na`)
- Explicit handling of edge cases (empty vectors, all-NA inputs)
- Clean numeric outputs

### Testing
- Built using `testthat`
- Covers correctness, edge cases and functional relationships e.g. IQR consistency

### How to Run
Use the following commands, in the order they appear:
```
devtools::document()
devtools::load_all()
testthat::test_dir("tests/testthat")
```

## ADSL Construction & Derivations (Pharmaverse/Admiral)
Construction of an analysis-ready ADSL dataset from SDTM sources.

### Key Derivations
- AGEGR9/AGEGR9N - Age Categorisation
- TRTSDTM/TRTEDTM - Treatment exposure windows
- ITTFL - Intent-to-treat population
- ABNSBPFL - Abnormal systolic blood pressure flag
- LSTALVDT - Last known alive date (Calculated through multi-source derivations)
- CARPOPFL - Cardiac disorders population flag

### Design Decisions
- Pre-aggregation of VS to the initial ADSL, before merging other data, to avoid row inflation due to dataset row discrepancy
- Use of `derive_vars_merged()` for controlled joins
- Use of `derive_vars_extreme_event()` to consolidate multi-domain date logic

This design flow and approach is an attempt at mirroring production patterns in clinical pipelines where traceability and dataset integrity are critical.

## TEAE Summary Table
FDA-style summary of Treatment-Emergent Adverse Events

### Implementation
- Dataset: `pharmaverseadam::adae`
- Filter: `TRTEMFL == "Y"`
- Hierarchy: `AESOC -> AETERM`
- Columns: Treatment arms (`ACTARM`)
- Output: Count (n) and percentage with overall population

### Notes
- Subject-level aggregation avoids double counting
- Output aligns with standard regulatory table structures

## Visualisations
### Plot 1: AE Severity Distribution
- Severity (AESEV) by treatment arm
- Displays subject-level AE severity distribution by treatment arm

### Plot 2: Top 10 Adverse Events
- Ranked by frequency (`AETERM`)
- Includes 95% confidence intervals for incidence rates

### Plot 3: AE Listing
A detailed subject-level listing of Treatment-Emergent Adverse Events
Features:
- Filtered for TEAEs (`TRTEMFL == "Y"`)
- Includes:
  - Subject ID (`USUBJID`)
  - Treatment Arm (`ACTARM`)
  - AE Term (`AETERM`)
  - Severity (`AESEV`)
  - Relationship to Drug (`AEREL`)
  - Start/End Dates (`ASTDT`, `AENDT`)
 
### Design Considerations
- Sorted by subject and event start date for chronological traceability
- Dates handled using `admiral` utilities to ensure consistency with clinical standards
- Output formatted using `gt` to approximate regulatory-style listings, mimicking SAS-like output

### Output
- Visualisation 1: `ae_summary_table.html`
- Visualisation 2: `ae_severity_distribution.png` & `top10_ae_ci_plot.png`
- Visualisation 3: `ae_listing.html`

## RESTful API (Using FastAPI)
Provides programmatic access to AE data with dynamic filtering and derived risk scoring.

### Endpoints
#### GET /
Health check endpoint

#### POST /ae_query
Dynamic cohort filtering
- Accepts optional filters, such as severity and treatment arm
- Ignores unspecified fields
- Returns:
  - Record count
  - Unique subject IDs

#### GET /subject-risk/{subject_id}
Computes a Safety Risk Score
Risk classification:
- Low (<5)
- Medium (5-14)
- High (≥15)
Includes validation and 404 handling for invalid subjects

#### How to Run
To run the API, use this command in the terminal, after navigating to the working directory where the API is based:
- `python -m uvicorn API_file:app --reload`

## Generative AI Assistant
Translate natural language queries into structured Pandas operations without hard-coded mappings

### Architecture
Query -> LLM -> Structured JSON -> Validation -> Execution
If Structured JSON fails, then it navigates to a fallback routine.

### Implementation
- Local LLM (`distilgpt2`) used due to API constraints
- Schema-driven prompt defines mapping space (`AESEV, AETERM, AESOC`)

#### Key Challenge
Lightweight local models are not fully reliable for structured extraction tasks

### Solution: Hybrid Parsing Strategy
1. Attempt LLM-based parsing
2. Validate output against schema
3. Apply deterministic fallback if invalid

This ensures:
- Consistent behaviour
- Resilience to malformed outputs
- Alignment with expected schema

### Execution Logic
- Case-insensitive filtering
- Uses partial matching (`str.contains`) to reflect real-world clinical data
  - e.g. `"HEADACHE"` correctly matches `"HEADACHE NOS"`

### Example Queries
```
"Give me subjects with moderate severity adverse events"
"Which patients had headaches?"
"Show subjects with cardiac disorders"
```

### How to Run
Once navigated to the local directory, use this command:
`python gen-ai-agent.py`

### Assumptions and Constraints
- No external LLM APIs used: Opted for a local model with an integrated fallback strategy
- Data sourced from `pharmaversesdtm` and `pharmaverseadam`
- Focus placed on correctness, robustness and reproducibility over optimisation

## Key Takeaways
- Clinical data pipelines require strict validation and controlled transformations
- Aggregation strategy is critical to avoid corrupting subject-level datasets
- LLM-based systems must be defensive and validated, not blindly trusted
- Reproducibility and traceability are essential in regulated environments

# Summary
This project demonstrates the integration of statistical programming, clinical data standards, backend engineering, and applied AI within a single workflow.

The solutions are designed to reflect real-world clinical data practices, where correctness, traceability, and robustness are critical.
