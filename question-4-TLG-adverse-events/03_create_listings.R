
# Libraries ---------------------------------------------------------------
library(dplyr)
library(gtsummary)
library(pharmaverseadam)
library(admiral)
library(gt)

# Data Loading ------------------------------------------------------------

adae <- pharmaverseadam::adae

listing_data <- adae %>%
  filter(TRTEMFL == "Y") %>% 
  
  # Select only required columns
  select(
    USUBJID,
    ACTARM,
    AETERM,
    AESEV,
    AEREL,
    ASTDT,
    AENDT
  ) %>%
  
  # Sort correctly
  arrange(USUBJID, ASTDT)

tbl <- listing_data %>%
  gt(groupname_col = "USUBJID") %>%
  cols_label(
    ACTARM = "Treatment Arm",
    AETERM = "Reported Term for the Adverse Event",
    AESEV = "Severity/Intensity",
    AEREL = "Causality",
    ASTDT = "Start Date/Time of Adverse Event",
    AENDT = "End Date/Time of Adverse Event"
  )

tbl <- tbl %>%
  fmt_date(
    columns = c(ASTDT, AENDT),
    date_style = 3   # e.g. 01-Jan-2011
  )

tbl <- tbl %>%
  cols_align(
    align = "left",
    everything()
  ) %>%
  cols_width(
    AETERM ~ px(250),   # widen long text column
    everything() ~ px(120)
  )

tbl <- tbl %>%
  tab_header(
    title = md("**Listing of Treatment-Emergent Adverse Events by Subject**"),
    subtitle = "Showing Adverse Events Balance"
  )

tbl <- tbl %>%
  tab_options(
    table.font.size = px(12),
    data_row.padding = px(2),
    heading.title.font.size = px(14)
  )

tbl

gtsave(tbl, "ae_listing.html")