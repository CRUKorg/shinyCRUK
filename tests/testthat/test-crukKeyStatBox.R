test_that("crukKeyStatBox wraps a character statement without an image", {
  html <- as.character(crukKeyStatBox("Hello"))
  expect_true(grepl("cruk-key-stat-box__box", html, fixed = TRUE))
  expect_true(grepl("Hello", html, fixed = TRUE))
  expect_false(grepl("<img", html, fixed = TRUE))
})

test_that("crukKeyStatBox adds the image before the statement", {
  html <- as.character(crukKeyStatBox("Hello", image = "magnifying-glass.svg"))
  expect_true(grepl('src="magnifying-glass.svg"', html, fixed = TRUE))
  expect_lt(regexpr("<img", html)[1], regexpr("Hello", html)[1])
})

test_that("crukKeyStatBox accepts shiny outputs", {
  html <- as.character(crukKeyStatBox(shiny::textOutput("x")))
  expect_true(grepl("shiny-text-output", html, fixed = TRUE))
})

test_that("crukKeyStatBox attaches its stylesheet dependency", {
  deps <- htmltools::findDependencies(crukKeyStatBox("Hello"))
  expect_true("crukKeyStatBox" %in% vapply(deps, function(d) d$name, character(1)))
})

test_that("crukKeyStatBox rejects invalid input", {
  expect_error(crukKeyStatBox(1))
  expect_error(crukKeyStatBox("a", image = c("a.svg", "b.svg")))
})
