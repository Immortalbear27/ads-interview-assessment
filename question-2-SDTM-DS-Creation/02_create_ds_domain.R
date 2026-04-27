
# Libraries ---------------------------------------------------------------

library(sdtm.oak)
library(pharmaverseraw)
library(dplyr)
library(pharmaversesdtm)



# Reading in Data ---------------------------------------------------------

# Read in the raw DS data:
ds_raw <- pharmaverseraw::ds_raw

# Read in the raw DM domain data:
dm <- pharmaversesdtm::dm

# Read in the Controlled Terminology:
study_ct <- read.csv("./question-2-SDTM-DS-Creation/sdtm_ct.csv")


# Derivation of Variables -------------------------------------------------

# Create_oak_id_vars:
ds_raw <- ds_raw %>% generate_oak_id_vars(
  pat_var = "PATNUM",
  raw_src = "ds_raw"
) %>% mutate(
  DSDECOD = IT.DSDECOD
)

# Derive topic variable - DSTERM:
ds <- assign_no_ct(
  raw_dat = ds_raw,
  raw_var = "IT.DSTERM",
  tgt_var = "DSTERM",
  id_vars = oak_id_vars()
)

# Carry through required raw variables for later derivations:
ds <- ds %>%
  assign_no_ct(
    raw_dat = ds_raw,
    raw_var = "IT.DSDECOD",
    tgt_var = "DSDECOD",
    id_vars = oak_id_vars()
  ) %>%
  assign_no_ct(
    raw_dat = ds_raw,
    raw_var = "OTHERSP",
    tgt_var = "OTHERSP",
    id_vars = oak_id_vars()
  ) %>%
  assign_no_ct(
    raw_dat = ds_raw,
    raw_var = "STUDY",
    tgt_var = "STUDYID",
    id_vars = oak_id_vars()
  )

# Derive DSDTC, DSSTDTC:
ds <- ds %>% assign_datetime(
  raw_dat = ds_raw,
  raw_var = c("DSDTCOL", "DSTMCOL"),
  tgt_var = "DSDTC",
  raw_fmt = c("m-d-y", "H:M"),
  raw_unk = c("UN", "UNK"),
  id_vars = oak_id_vars()
) %>% assign_datetime(
  raw_dat = ds_raw,
  raw_var = "IT.DSSTDAT",
  tgt_var = "DSSTDTC",
  raw_fmt = c("m-d-y"),
  id_vars = oak_id_vars()
)

# Derive DSCAT using OTHERSP & DSDECOD:
ds <- ds %>%
  mutate(DSCAT = case_when(
    DSDECOD == "Randomized" ~ "PROTOCOL MILESTONE",
    !is.na(OTHERSP) ~ "OTHER EVENT",
    TRUE ~ "DISPOSITION EVENT"
  ))

# Derive VISIT & VISITNUM:
ds <- ds %>% assign_ct(
  raw_dat = ds_raw,
  raw_var = "INSTANCE",
  tgt_var = "VISIT",
  ct_spec = study_ct,
  ct_clst = "VISIT",
  id_vars = oak_id_vars()
) %>% assign_ct(
  raw_dat = ds_raw,
  raw_var = "INSTANCE",
  tgt_var = "VISITNUM",
  ct_spec = study_ct,
  ct_clst = "VISITNUM",
  id_vars = oak_id_vars()
)

# Final combination of the finished ADaM, including derivation of variables such as:
# - STUDYID
# - DOMAIN
# - USUBJID
# - DSDECOD
# - DSSEQ
# - DSSTDY

# Also includes ordering of variables and removal of unnecessary variables:
ds <- ds %>% 
  dplyr::mutate(
    STUDYID = ds_raw$STUDY,
    DOMAIN = "DS",
    USUBJID = paste0(STUDYID, patient_number, sep = "-"),
    DSDECOD = ds_raw$IT.DSDECOD
  ) %>% derive_seq(
    tgt_var = "DSSEQ",
    rec_vars = c("USUBJID")
  ) %>% derive_study_day(
    sdtm_in = .,
    dm_domain = dm,
    tgdt = "DSSTDTC",
    refdt = "RFXSTDTC",
    study_day_var = "DSSTDY"
  ) %>% select(
    "STUDYID", "DOMAIN", "USUBJID", "DSSEQ", 
    "DSTERM", "DSDECOD", "DSCAT", "VISITNUM", "VISIT", 
    "DSDTC", "DSSTDTC", "DSSTDY")