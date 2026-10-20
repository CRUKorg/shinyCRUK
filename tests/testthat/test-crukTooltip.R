test_that("crukTooltip wraps the text and appends a trigger", {
  skip_if_not_installed("bsicons")
  html <- as.character(crukTooltip("information", "Here is some useful information"))

  expect_true(grepl("cruk-tooltip-label", html, fixed = TRUE))
  expect_true(grepl(">information<", html, fixed = TRUE))
  expect_true(grepl("cruk-tooltip-trigger", html, fixed = TRUE))
  expect_true(grepl("Here is some useful information", html, fixed = TRUE))
  expect_true(grepl("bslib-tooltip", html, fixed = TRUE))
})

test_that("crukTooltip attaches its dependency", {
  skip_if_not_installed("bsicons")
  deps <- htmltools::findDependencies(crukTooltip("a", "b"))
  expect_true("crukTooltip" %in% vapply(deps, function(d) d$name, character(1)))
})

test_that("crukTooltip validates its inputs", {
  skip_if_not_installed("bsicons")
  expect_error(crukTooltip(1, "b"), "single string")
  expect_error(crukTooltip(c("a", "b"), "b"), "single string")
  expect_error(crukTooltip("a", "b", placement = "diagonal"))
})
