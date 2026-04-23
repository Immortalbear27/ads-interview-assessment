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
Computes the mean of a numeric vector:
```r
# Inline code usage:
calc_mean(x, na.rm = FALSE)

# Example Inputs:
calc_mean(c(1, 2, 3, 4))
calc_mean(c(1, NA, 3), na.rm = TRUE)
```

#### calc_median()
Computes the median value:
```r
# Inline code usage:
calc_median(x, na.rm = FALSE)

# Example Inputs:
calc_median(c(1, 2, 3, 4))
calc_median(c(1, NA, 3), na.rm = TRUE)
```

#### calc_mode()
Returns the most frequent value/s in a numeric vector:
```r
# Inline code usage:
calc_mode(x, na.rm = FALSE)

# Example Inputs:
calc_mode(c(1, 2, 3, 4)
calc_mode(c(1, NA, 3), na.rm = TRUE)
```

