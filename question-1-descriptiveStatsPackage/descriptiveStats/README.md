# DescriptiveStats
A lightweight R package providing robust implementations of common descriptive statistics functions with consistent input validation and NA handling.

## Overview

`descriptiveStats` implements core descriptive statistical measures including:

- Mean
- Median
- Mode
- First Quartile (Q1)
- Third Quartile (Q3)
- Interquartile Range (IQR)

All functions are designed with:
- strict input validation
- optional NA handling
- consistent behaviour across the API

# Installation

```r
# Install and Load:
devtools::install("question-1-descriptiveStatsPackage/descriptiveStats")
library(descriptiveStats)
```

## Functions
#### calc_mean()
```r
# Inline code usage:
calc_mean(x, na.rm = FALSE)
```

Computes the mean of a numeric vector:
```r
# Examples:
calc_mean(c(1, 2, 3, 4))
calc_mean(c(1, NA, 3), na.rm = TRUE)
```

