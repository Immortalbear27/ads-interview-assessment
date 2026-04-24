
# Libraries ---------------------------------------------------------------
library(pharmaverseadam)
library(gtsummary)

# Data Loading ------------------------------------------------------------

adsl <- pharmaverseadam::adsl
adae <- pharmaverseadam::adae

# Table Creation ----------------------------------------------------------

tbl <- adae %>% filter(TRTEMFL == "Y", ordered = TRUE) %>% 
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

tbl %>% as_gt() %>% gt::gtsave(filename = "ae_summary_table.html")