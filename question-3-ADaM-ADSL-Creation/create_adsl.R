
# Libraries ---------------------------------------------------------------

library(admiral)
library(dplyr, warn.conflicts = FALSE)
library(pharmaversesdtm)
library(lubridate)
library(stringr)

# Data Loading ------------------------------------------------------------
dm <- pharmaversesdtm::dm
ds <- pharmaversesdtm::ds
ex <- pharmaversesdtm::ex
ae <- pharmaversesdtm::ae
vs <- pharmaversesdtm::vs

dm <- convert_blanks_to_na(dm)
ds <- convert_blanks_to_na(ds)
ex <- convert_blanks_to_na(ex)
ae <- convert_blanks_to_na(ae)
vs <- convert_blanks_to_na(vs)

# Load the ADSL, and compute an aggregated version of VS suitable for merging:
adsl <- dm %>% select(-DOMAIN)

# Extra Note: ABNSBPFL is also derived as part of the VS aggregation:
vs_flag <- vs %>%
  filter(VSTESTCD == "SYSBP", VSSTRESU == "mmHg") %>%
  group_by(USUBJID) %>%
  summarise(
    ABNSBPFL = ifelse(any(VSSTRESN >= 140 | VSSTRESN < 100, na.rm = TRUE), "Y", "N"),
    .groups = "drop"
  )

adsl <- derive_vars_merged(
  adsl,
  dataset_add = vs_flag,
  by_vars = exprs(USUBJID)
)

# Deriving AGEGR9:

adsl <- adsl %>% mutate(AGEGR9 = case_when(
  AGE < 18 ~ "<18",
  AGE >= 18 & AGE <= 50 ~ "18 - 50",
  AGE > 50 ~ ">50",
  TRUE ~ NA
))

# Deriving AGEGR9N:

adsl <- adsl %>% mutate(AGEGR9N = case_when(
  AGEGR9 == "<18" ~ 1,
  AGEGR9 == "18 - 50" ~ 2,
  AGEGR9 == ">50" ~ 3
))

# Deriving TRTSDTM:
# Impute start and end time of exposure to first and last respectively,
# Do not impute date
ex_ext <- ex %>%
  derive_vars_dtm(
    dtc = EXSTDTC,
    new_vars_prefix = "EXST"
  ) %>%
  derive_vars_dtm(
    dtc = EXENDTC,
    new_vars_prefix = "EXEN",
    time_imputation = "last"
  )

adsl <- adsl %>%
  derive_vars_merged(
    dataset_add = ex_ext,
    filter_add = (EXDOSE > 0 |
                    (EXDOSE == 0 &
                       str_detect(EXTRT, "PLACEBO"))) & !is.na(EXSTDTM),
    new_vars = exprs(TRTSDTM = EXSTDTM, TRTSTMF = EXSTTMF),
    order = exprs(EXSTDTM, EXSEQ),
    mode = "first",
    by_vars = exprs(STUDYID, USUBJID)
  ) %>%
  derive_vars_merged(
    dataset_add = ex_ext,
    filter_add = (EXDOSE > 0 |
                    (EXDOSE == 0 &
                       str_detect(EXTRT, "PLACEBO"))) & !is.na(EXENDTM),
    new_vars = exprs(TRTEDTM = EXENDTM, TRTETMF = EXENTMF),
    order = exprs(EXENDTM, EXSEQ),
    mode = "last",
    by_vars = exprs(STUDYID, USUBJID)
  )

# Deriving ITTFL:
adsl <- adsl %>% mutate(ITTFL = case_when(
  !is.na(ARM) ~ "Y",
  TRUE ~ "N"
))

# Deriving LSTALVDT:

adsl <- adsl %>%
  derive_vars_extreme_event(
    by_vars = exprs(STUDYID, USUBJID),
    events = list(
      
      # VS — last valid vital:
      event(
        dataset_name = "vs",
        order = exprs(VSDTC, VSSEQ),
        condition = !(is.na(VSSTRESN) & is.na(VSSTRESC)) & !is.na(VSDTC),
        set_values_to = exprs(
          LSTALVDT = convert_dtc_to_dt(VSDTC),
          seq = VSSEQ
        )
      ),
      
      # AE — onset only:
      event(
        dataset_name = "ae",
        order = exprs(AESTDTC, AESEQ),
        condition = !is.na(AESTDTC),
        set_values_to = exprs(
          LSTALVDT = convert_dtc_to_dt(AESTDTC),
          seq = AESEQ
        )
      ),
      
      # DS — disposition:
      event(
        dataset_name = "ds",
        order = exprs(DSSTDTC, DSSEQ),
        condition = !is.na(DSSTDTC),
        set_values_to = exprs(
          LSTALVDT = convert_dtc_to_dt(DSSTDTC),
          seq = DSSEQ
        )
      ),
      
      # Treatment — from ADSL:
      event(
        dataset_name = "adsl",
        condition = !is.na(TRTEDTM),
        set_values_to = exprs(
          LSTALVDT = as.Date(TRTEDTM),
          seq = 0
        )
      )
      
    ),
    # Specify the source datasets:
    source_datasets = list(
      vs = vs,
      ae = ae,
      ds = ds,
      adsl = adsl
    ),
    # Add the new variable, LSTALVDT, to ADSL:
    tmp_event_nr_var = event_nr,
    
    order = exprs(LSTALVDT, seq, event_nr),
    
    mode = "last",
    
    new_vars = exprs(LSTALVDT)
  )

# Deriving CARPOPFL:

# Aggregate AE dataset, due to row difference to ADSL.
# Also, derive CARPOPFL due to it only requiring AE information:
ae_flag <- ae %>%
  mutate(AESOC_UP = toupper(AESOC)) %>%
  group_by(USUBJID) %>%
  summarise(
    CARPOPFL = ifelse(
      any(AESOC_UP == "CARDIAC DISORDERS", na.rm = TRUE),
      "Y",
      NA_character_
    ),
    .groups = "drop"
  )

# Merge the above aggregation into ADSL:
adsl <- adsl %>%
  derive_vars_merged(
    dataset_add = ae_flag,
    by_vars = exprs(USUBJID)
  )




