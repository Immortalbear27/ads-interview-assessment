
# Libraries ---------------------------------------------------------------
library(pharmaverseadam)
library(ggplot2)
library(dplyr)
library(binom)

# Data Loading ------------------------------------------------------------

adae <- pharmaverseadam::adae

# Plot 1 ------------------------------------------------------------------

plot_data <- adae %>%
  filter(TRTEMFL == "Y") %>%   # Ensure TEAEs only
  mutate(
    AESEV = factor(AESEV, levels = c("MILD", "MODERATE", "SEVERE"))
  )

p <- ggplot(plot_data, aes(x = ACTARM, fill = AESEV)) +
  geom_bar(position = "stack") +
  labs(
    title = "AE severity distribution by treatment",
    x = "Treatment Arm",
    y = "Count of AEs",
    fill = "Severity/Intensity"
  ) +
  theme_minimal()

ggsave(
  filename = "ae_severity_plot.png",
  plot = p,
  width = 8,
  height = 6,
  dpi = 300
)

# Plot 2 ------------------------------------------------------------------

n_total <- n_distinct(adsl$USUBJID)

ae_summary <- adae %>%
  filter(TRTEMFL == "Y") %>%  # TEAEs only
  distinct(USUBJID, AETERM) %>%  # subject-level incidence
  count(AETERM, name = "n") %>%
  mutate(
    prop = n / n_total
  )

ae_top10 <- ae_summary %>%
  arrange(desc(n)) %>%
  slice_head(n = 10)

ci <- binom::binom.confint(
  x = ae_top10$n,
  n = n_total,
  methods = "exact"
)

ae_top10 <- ae_top10 %>%
  mutate(
    lower = ci$lower,
    upper = ci$upper
  )

p <- ggplot(ae_top10, aes(
  x = prop * 100,
  y = reorder(AETERM, prop)
)) +
  geom_point() +
  geom_errorbar(aes(
    xmin = lower * 100,
    xmax = upper * 100
  ), height = 0.2) +
  labs(
    title = paste0(
      "Top 10 Most Frequent Adverse Events\n",
      "n = ", n_total, " subjects; 95% Clopper-Pearson CIs"
    ),
    x = "Percentage of Patients (%)",
    y = NULL
  ) +
  theme_minimal()

ggsave(
  filename = "ae_severity_plot_2.png",
  plot = p,
  width = 8,
  height = 6,
  dpi = 300
)