# Tests for crukRounding()
#
# Expected values for the 1M+, 10M+ and 100M+ ranges are hand-derived from the
# rule used in the 100k+ block: with `step` the 3 s.f. step for the range and
# `r` = number %% step,
#   r >= 90% of step -> "around"    <signif(number, 3)>
#   r >= 70% of step -> "nearly"    <signif(number, 3)>
#   r >= 20% of step -> "more than" <number floored to step>
#   otherwise        -> "around"    <number floored to step>
# They have NOT been run against the function; run them before merging.


# Helper: run a table of number/expected pairs through crukRounding()
expect_rounding <- function(cases) {
  actual <- purrr::map_chr(cases$number, crukRounding)
  expect_equal(actual, cases$expected)
}

test_that("1M+ range uses thresholds scaled to a 10,000 step", {
  tibble::tribble(
    ~number,  ~expected,
    1090747,  "around 1,090,000",    # regression: was "nearly 1,090,000"
    1091999,  "around 1,090,000",    # just under 20% of the step
    1092000,  "more than 1,090,000", # 20% boundary
    1095000,  "more than 1,090,000", # exact half step (tie tweak)
    1096999,  "more than 1,090,000", # just under 70%
    1097000,  "nearly 1,100,000",    # 70% boundary
    1098000,  "nearly 1,100,000",
    1098999,  "nearly 1,100,000",    # just under 90%
    1099000,  "around 1,100,000",    # 90% boundary
    1099500,  "around 1,100,000",
    1100000,  "around 1,100,000",    # exact multiple of the step
    1909747,  "around 1,910,000",
    1234567,  "more than 1,230,000"
  ) |>
    expect_rounding()
})

test_that("10M+ range uses thresholds scaled to a 100,000 step", {
  tibble::tribble(
    ~number,   ~expected,
    12301000,  "around 12,300,000",
    12319999,  "around 12,300,000",
    12320000,  "more than 12,300,000",
    12345678,  "more than 12,300,000",
    12350000,  "more than 12,300,000",  # exact half step (tie tweak)
    12370000,  "nearly 12,400,000",
    12380000,  "nearly 12,400,000",
    12390000,  "around 12,400,000",
    12395000,  "around 12,400,000"
  ) |>
    expect_rounding()
})

test_that("100M+ range uses a 1,000,000 step and floors rather than rounds", {
  tibble::tribble(
    ~number,    ~expected,
    123100000,  "around 123,000,000",
    123200000,  "more than 123,000,000",
    123500000,  "more than 123,000,000",  # exact half step (tie tweak)
    123600000,  "more than 123,000,000",  # regression: signif() made this 124,000,000
    123700000,  "nearly 124,000,000",
    123800000,  "nearly 124,000,000",
    123900000,  "around 124,000,000",
    123950000,  "around 124,000,000"
  ) |>
    expect_rounding()
})

test_that("100k+ range is unchanged", {
  tibble::tribble(
    ~number,  ~expected,
    123100,   "around 123,000",
    123456,   "more than 123,000",
    123500,   "more than 123,000",
    156789,   "nearly 157,000",   # matches the corrected roxygen example
    123950,   "around 124,000",
    999999,   "around 1,000,000"
  ) |>
    expect_rounding()
})

test_that("smaller ranges are unchanged", {
  tibble::tribble(
    ~number,  ~expected,
    50000,    "around 50,000",
    5000,     "around 5,000",
    1200,     "around 1,200",
    500,      "around 500",
    25,       "around 25",
    8,        "around 10",
    6,        "around 5",
    3,        "less than 5"
  ) |>
    expect_rounding()
})

test_that("crukRounding is vectorised across ranges", {
  expect_equal(
    crukRounding(c(1090747, 123600000, 156789, 1200)),
    c("around 1,090,000", "more than 123,000,000", "nearly 157,000", "around 1,200")
  )
})

test_that("case = 'upper' capitalises only the first letter", {
  expect_equal(crukRounding(1200, case = "upper"), "Around 1,200")
  expect_equal(crukRounding(1090747, case = "upper"), "Around 1,090,000")
  expect_equal(crukRounding(123600000, case = "upper"), "More than 123,000,000")
})

test_that("input validation works", {
  expect_error(crukRounding(1200, case = "title"), "`case` must be")
  expect_error(crukRounding("abc"), "must be numeric")
  expect_warning(crukRounding(-5), "Negative values")
})
