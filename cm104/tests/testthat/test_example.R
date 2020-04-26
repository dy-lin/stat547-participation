library(testthat)

# Prints context of this test
context("Demonstrating the testing library")

# Test equality of same numbers
test_that("Testing a number with itself", {
  expect_equal(0, 0)
  expect_equal(-1, -1)
  expect_equal(Inf, Inf)
})

# Test equality of different numbers
test_that("Testing different numbers", {
  expect_equal(0, 1)
})

# Testing using tolerance
# Tolerance (from all.equal): numeric ≥ 0. Differences smaller than tolerance are not reported. The default value is close to 1.5e-8.

# Scale (from all.equal): NULL or numeric > 0, typically of length 1 or length(target).

# If scale is numeric (and positive), absolute comparisons are made after scaling (dividing) by scale.

test_that("Testing with a tolerance", {
  # Following line passes due to tolerance:
  expect_equal(0, 0.01, tolerance = 0.05, scale = 1)
  
  # Following line fails due to tolerance
  expect_equal(0, 0.01, tolerance = 0.005, scale = 1)
})
