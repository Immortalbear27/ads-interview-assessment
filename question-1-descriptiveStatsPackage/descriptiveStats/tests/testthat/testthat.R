
# Calc_mean Tests ---------------------------------------------------------

test_that("calc_mean computes correct mean", {
  expect_equal(calc_mean(c(1, 2, 3, 4)), 2.5)
})

test_that("calc_mean handles NA correctly", {
  expect_equal(calc_mean(c(1, NA, 3), na.rm = TRUE), 2)
})

test_that("calc_mean errors on non-numeric input", {
  expect_error(calc_mean("a"))
})

test_that("calc_mean errors on empty input", {
  expect_error(calc_mean(numeric(0)))
})


# Calc_median Tests -------------------------------------------------------

test_that("calc_median computes correct median", {
  expect_equal(calc_median(c(1, 2, 3)), 2)
})

test_that("calc_median handles NA correctly", {
  expect_equal(calc_median(c(1, NA, 3), na.rm = TRUE), 2)
})

test_that("calc_median errors on invalid input", {
  expect_error(calc_median("invalid"))
})


# Calc-mode Tests ---------------------------------------------------------

test_that("calc_mode returns correct mode", {
  expect_equal(calc_mode(c(1, 2, 2, 3)), 2)
})

test_that("calc_mode handles multiple modes", {
  expect_equal(sort(calc_mode(c(1, 1, 2, 2))), c(1, 2))
})

test_that("calc_mode returns NA when no mode exists", {
  expect_true(is.na(calc_mode(c(1, 2, 3, 4))))
})

test_that("calc_mode handles NA correctly", {
  expect_equal(calc_mode(c(1, NA, 1), na.rm = TRUE), 1)
})


# Calc_q1 Tests -----------------------------------------------------------

test_that("calc_q1 computes correct first quartile", {
  expect_equal(calc_q1(c(1, 2, 3, 4)), 1.75, tolerance = 1e-8)
})

test_that("calc_q1 handles NA correctly", {
  expect_equal(calc_q1(c(1, NA, 3, 4), na.rm = TRUE), 2, tolerance = 1e-8)
})

# Calc_q3 Tests -----------------------------------------------------------
test_that("calc_q3 computes correct third quartile", {
  expect_equal(calc_q3(c(1, 2, 3, 4)), 3.25)
})

test_that("calc_q3 handles NA correctly", {
  expect_equal(calc_q3(c(1, NA, 3, 4), na.rm = TRUE), 3.5)
})


# Calc_iqr Tests ----------------------------------------------------------

test_that("calc_iqr computes correct IQR", {
  expect_equal(calc_iqr(c(1, 2, 3, 4)), 1.5)
})

test_that("calc_iqr matches Q3 - Q1", {
  x <- c(1, 2, 3, 4, 5)
  expect_equal(calc_iqr(x), calc_q3(x) - calc_q1(x))
})

test_that("calc_iqr handles NA correctly", {
  expect_equal(calc_iqr(c(1, NA, 3, 4), na.rm = TRUE), 1.5)
})

