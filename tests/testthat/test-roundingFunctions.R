# Tests for crukRounding()
#
# Expected values are hand-derived from the rules in the function. For the
# 1M+ range, with `r` = number %% 100,000 (a 0.1 million step):
#   r >= 90,000 -> "around"    <number rounded UP to the step, in millions, 1 d.p.>
#   r >= 70,000 -> "nearly"    <number rounded UP to the step>
#   r >= 20,000 -> "more than" <number floored to the step>
#   otherwise   -> "around"    <number floored to the step>
# For the 100k+ range the same thresholds apply with a 1,000 step (3 s.f.).
#
# They have NOT been run against the function; run them before merging.


# Helper: run a table of number/expected pairs through crukRounding()
expect_rounding <- function(cases) {
  actual <- purrr::map_chr(cases$number, crukRounding)
  expect_equal(actual, cases$expected)
}

test_that("1M+ range is expressed in millions to 1 d.p. with a 100,000 step", {
  tibble::tribble(
    ~number,  ~expected,
    1000000,  "around 1.0 million",     # exact multiple of the step
    1019999,  "around 1.0 million",     # just under 20% of the step
    1020000,  "more than 1.0 million",  # 20% boundary
    1090747,  "around 1.1 million",     # was "around 1,090,000" before the million format
    1150000,  "more than 1.1 million",
    1155000,  "more than 1.1 million",  # tie tweak applies (+1); no effect on result
    1169999,  "more than 1.1 million",  # just under 70%
    1170000,  "nearly 1.2 million",     # 70% boundary
    1189999,  "nearly 1.2 million",     # just under 90%
    1190000,  "around 1.2 million",     # 90% boundary
    1199999,  "around 1.2 million",
    1200000,  "around 1.2 million",     # exact multiple of the step
    1234567,  "more than 1.2 million",
    1909747,  "around 1.9 million",     # remainder < 20%, floors down
    1999999,  "around 2.0 million"      # rounds up to a whole million, keeps 1 d.p.
  ) |>
    expect_rounding()
})

test_that("10M+ range uses the same 100,000 step", {
  tibble::tribble(
    ~number,   ~expected,
    12301000,  "around 12.3 million",
    12319999,  "around 12.3 million",
    12320000,  "more than 12.3 million",
    12345678,  "more than 12.3 million",
    12350000,  "more than 12.3 million",  # tie tweak applies (+1); no effect on result
    12370000,  "nearly 12.4 million",
    12390000,  "around 12.4 million",
    12395000,  "around 12.4 million",
    99990000,  "around 100.0 million"     # rounds up across a digit boundary
  ) |>
    expect_rounding()
})

test_that("100M+ range is now reported to 1 d.p. of a million, not the nearest million", {
  tibble::tribble(
    ~number,    ~expected,
    123100000,  "around 123.1 million",
    123119999,  "around 123.1 million",
    123120000,  "more than 123.1 million",
    123500000,  "around 123.5 million",   # tie tweak applies (+1); remainder is then 1
    123600000,  "around 123.6 million",   # was "more than 123,000,000"
    123770000,  "nearly 123.8 million",
    123990000,  "around 124.0 million",
    250000000,  "around 250.0 million"
  ) |>
    expect_rounding()
})

test_that("values just under 1 million that round up to 1,000,000 use the million format", {
  tibble::tribble(
    ~number,  ~expected,
    999999,   "around 1.0 million",   # was "around 1,000,000"
    999900,   "around 1.0 million",   # 90% boundary
    999899,   "nearly 1.0 million",   # just under 90%
    999700,   "nearly 1.0 million",   # 70% boundary
    999699,   "more than 999,000",    # just under 70%: stays in the 100k+ range
    999500,   "more than 999,000"     # tie tweak applies (+1); stays in the 100k+ range
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
    123950,   "around 124,000"
  ) |>
    expect_rounding()
})

test_that("smaller ranges are unchanged, except that values rounding up to 1,000 get a comma", {
  tibble::tribble(
    ~number,  ~expected,
    50000,    "around 50,000",
    5000,     "around 5,000",
    1200,     "around 1,200",
    999,      "around 1,000",     # was "around 1000" (missing thousand separator)
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
    crukRounding(c(1090747, 123600000, 156789, 1200, 999999)),
    c("around 1.1 million", "around 123.6 million", "nearly 157,000",
      "around 1,200", "around 1.0 million")
  )
})

test_that("case = 'upper' capitalises only the first letter", {
  expect_equal(crukRounding(1200, case = "upper"), "Around 1,200")
  expect_equal(crukRounding(1090747, case = "upper"), "Around 1.1 million")
  expect_equal(crukRounding(1234567, case = "upper"), "More than 1.2 million")
})

test_that("numeric strings are coerced", {
  expect_equal(crukRounding("1200"), "around 1,200")
})

test_that("input validation works", {
  expect_error(crukRounding(1200, case = "title"), "`case` must be")
  expect_error(crukRounding("abc"), "must be numeric")
  expect_warning(crukRounding(-5), "Negative values")
})

test_that("partly non-numeric input errors rather than silently returning text", {
  expect_error(crukRounding(c("1200", "abc")), "must be numeric")
})

test_that("missing and infinite values error", {
  expect_error(crukRounding(NA_real_), "missing")
  expect_error(crukRounding(NA), "missing")            # logical NA
  expect_error(crukRounding(NA_character_), "missing")
  expect_error(crukRounding(NaN), "missing")
  expect_error(crukRounding(c(1200, NA)), "missing")   # one NA in an otherwise valid vector
  expect_error(crukRounding(Inf), "infinite")
  expect_error(crukRounding(-Inf), "infinite")
})
