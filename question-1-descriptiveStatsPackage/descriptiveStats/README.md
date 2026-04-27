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
calc_mode(c(1, 2, 3, 4))
calc_mode(c(1, NA, 3), na.rm = TRUE)
```

#### calc_q1()
Computes the first quartile (25th percentile):
```r
# Inline code usage:
calc_q1(x, na.rm = FALSE)

# Example Inputs:
calc_q1(c(1, 2, 3, 4))
calc_q1(c(1, NA, 3), na.rm = TRUE)
```

#### calc_q3()
Computes the third quartile (75th percentile):
```r
# Inline code usage:
calc_q3(x, na.rm = FALSE)

# Example Inputs:
calc_q3(c(1, 2, 3, 4))
calc_q3(c(1, NA, 3), na.rm = TRUE)
```

#### calc_iqr()
Computes the interquartile range, using the previous two functions' outputs:
```r
# Inline code usage:
calc_iqr(x, na.rm = FALSE)

# Example Inputs:
calc_iqr(c(1, 2, 3, 4))
calc_iqr(c(1, NA, 4), na.rm = TRUE)
```

## Input Validation
All functions include strict validation:
- Input must be numeric
- Empty inputs are rejected or return 'NA' after 'NA' removal
- 'NA' handling is controlled via 'na.rm'
```r
# Example:
calc_mean("a") # Error would occur
```

## Design Philosophy
The package prioritises:
- Consistency across statistical functions
- Reproducibility of outputs using base R quantile behaviour
- Robust edge-case handling
- Modular design using helper functions where possible and applicable
Key internal helpers:
- 'validate_numeric()' - Ensures valid numeric input
- 'handle_na()' - Centralised 'NA' handling logic

## Example Workflow
```r
x <- c(1, 2, 3, NA)

calc_mean(x, na.rm = TRUE)
calc_median(x, na.rm = TRUE)
calc_mode(x, na.rm = TRUE)
calc_q1(x, na.rm = TRUE)
calc_q3(x, na.rm = TRUE)
calc_iqr(x, na.rm = TRUE)
```
## Final Notes
- Quartile calculations use R's default quantile method (Type = 7)
- NA handling is explicitly controlled per function call
- Empty vectors after NA removal return 'NA'

#### Author
Joshua Carey-Young
