
# Libraries ---------------------------------------------------------------
library(pharmaverseadam)
library(gtsummary)
library(dplyr)
library(gt)

# Data Loading ------------------------------------------------------------

adsl <- pharmaverseadam::adsl
adae <- pharmaverseadam::adae

# Table Creation ----------------------------------------------------------
# TEAE summary table:
# - Rows: AESOC -> AETERM
# - Columns: actual treatment arm
# - Denominator: all subjects in ADSL by treatment arm
# - Counts: unique subjects via USUBJID

# Denominator uses ADSL so percentages are based on all subjects in each treatment arm,
# not only subjects with TEAEs.
tbl <- adae %>% filter(TRTEMFL == "Y") %>% 
  tbl_hierarchical(
    variables = c(AESOC, AETERM),
    by = ACTARM,
    id = USUBJID,
    denominator = adsl,
    overall_row = TRUE,
    label = list(
      AESOC = "Primary System Organ Class",
      AETERM = "Reported Term for the Adverse Event",
      "..ard_hierarchical_overall.." ~ "Any TEAE"
    )
  )

tbl %>% as_gt() %>% 
  gt::gtsave(filename = "./question-4-TLG-adverse-events/outputs/ae_summary_table.html")