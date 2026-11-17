test_that("crukKeyStatBox wraps a character statement without an image", {
  html <- as.character(crukKeyStatBox("Hello", image = NULL))
  expect_true(grepl("cruk-key-stat-box__box", html, fixed = TRUE))
  expect_true(grepl("Hello", html, fixed = TRUE))
  expect_false(grepl("<img", html, fixed = TRUE))
})

test_that("crukKeyStatBox shows the packaged logo by default", {
  html <- as.character(crukKeyStatBox("Hello"))
  expect_true(
    grepl('src="shinyCRUK/images/CI-logo-no-text.svg"', html, fixed = TRUE)
  )
  expect_lt(regexpr("<img", html)[1], regexpr("Hello", html)[1])
})

test_that("the default logo file ships with the package", {
  expect_true(
    nzchar(system.file("www", "images", "CI-logo-no-text.svg", package = "shinyCRUK"))
  )
})

test_that("crukKeyStatBox adds the image before the statement", {
  html <- as.character(crukKeyStatBox("Hello", image = "magnifying-glass.svg"))
  expect_true(grepl('src="magnifying-glass.svg"', html, fixed = TRUE))
  expect_false(grepl("CI-logo-no-text.svg", html, fixed = TRUE))
  expect_lt(regexpr("<img", html)[1], regexpr("Hello", html)[1])
})

test_that("showImage = FALSE hides the default and a supplied image", {
  default_html <- as.character(crukKeyStatBox("Hello", showImage = FALSE))
  custom_html <- as.character(
    crukKeyStatBox("Hello", image = "magnifying-glass.svg", showImage = FALSE)
  )
  expect_false(grepl("<img", default_html, fixed = TRUE))
  expect_false(grepl("<img", custom_html, fixed = TRUE))
  expect_true(grepl("Hello", custom_html, fixed = TRUE))
})

test_that("showImage = TRUE with image = NULL shows no image", {
  html <- as.character(crukKeyStatBox("Hello", image = NULL, showImage = TRUE))
  expect_false(grepl("<img", html, fixed = TRUE))
})

test_that("crukKeyStatBox accepts shiny outputs", {
  html <- as.character(crukKeyStatBox(shiny::textOutput("x")))
  expect_true(grepl("shiny-text-output", html, fixed = TRUE))
})

test_that("crukKeyStatBox attaches its stylesheet dependency", {
  deps <- htmltools::findDependencies(crukKeyStatBox("Hello"))
  expect_true("crukKeyStatBox" %in% vapply(deps, function(d) d$name, character(1)))
})

test_that("the stylesheet reads the box colour variable", {
  css_path <- system.file("www", "css", "crukKeyStatBox.css", package = "shinyCRUK")
  expect_true(nzchar(css_path))
  css <- paste(readLines(css_path, warn = FALSE), collapse = "\n")
  expect_true(grepl("var(--cruk-key-stat-box-colour", css, fixed = TRUE))
})

test_that("boxColour defaults to CRUK grey without a warning", {
  expect_warning(html <- as.character(crukKeyStatBox("Hello")), NA)
  expect_true(grepl("--cruk-key-stat-box-colour: #BBC7D9;", html, fixed = TRUE))
})

test_that("boxColour is applied to the box and normalised to upper-case", {
  html <- as.character(crukKeyStatBox("Hello", boxColour = "#00007e"))
  expect_true(grepl("--cruk-key-stat-box-colour: #00007E;", html, fixed = TRUE))
  # The variable is set on the box element, not the outer container.
  expect_lt(
    regexpr("cruk-key-stat-box__box", html)[1],
    regexpr("--cruk-key-stat-box-colour", html)[1]
  )
})

test_that("every CRUK brand colour is accepted without a warning", {
  brand <- c(
    "#000000", "#009CEE", "#BCE4FA", "#5BC5F2", "#E60078", "#E60079",
    "#F8C9DF", "#F088B6", "#00007E", "#CCCCE6", "#6666B2", "#BBC7D9",
    "#C6C6C6", "#878787"
  )
  for (colour in c(brand, tolower(brand))) {
    expect_warning(crukKeyStatBox("Hello", boxColour = colour), NA)
  }
})

test_that("three-digit hex codes are expanded before the brand check", {
  # #000 is #000000 (black, in the palette); #0cf is #00CCFF (not in it).
  expect_warning(
    html <- as.character(crukKeyStatBox("Hello", boxColour = "#000")),
    NA
  )
  expect_true(grepl("--cruk-key-stat-box-colour: #000000;", html, fixed = TRUE))
  expect_warning(
    crukKeyStatBox("Hello", boxColour = "#0cf"),
    "outside CRUK brand guidelines"
  )
})

test_that("a valid hex code outside the palette warns but still renders", {
  expect_warning(
    html <- as.character(crukKeyStatBox("Hello", boxColour = "#FF0000")),
    "outside CRUK brand guidelines"
  )
  expect_true(grepl("--cruk-key-stat-box-colour: #FF0000;", html, fixed = TRUE))
  expect_warning(
    crukKeyStatBox("Hello", boxColour = "#ff0000"),
    "#ff0000"
  )
})

test_that("boxColour rejects anything that is not a hex code", {
  bad <- list(
    "red", "bbc7d9", "#bbc7d", "#bbc7d9ff", "#GGGGGG", "#", "", " #bbc7d9",
    "rgb(0,0,0)", "#bbc7d9;background:url(x)", NA_character_, 1, NULL,
    c("#bbc7d9", "#000000"), TRUE
  )
  for (colour in bad) {
    expect_error(crukKeyStatBox("Hello", boxColour = colour), "boxColour")
  }
})

test_that("crukKeyStatBox rejects invalid input", {
  expect_error(crukKeyStatBox(1))
  expect_error(crukKeyStatBox("a", image = c("a.svg", "b.svg")))
  expect_error(crukKeyStatBox("a", showImage = NA), "showImage")
  expect_error(crukKeyStatBox("a", showImage = "yes"), "showImage")
  expect_error(crukKeyStatBox("a", showImage = c(TRUE, FALSE)), "showImage")
  expect_error(crukKeyStatBox("a", showImage = NULL), "showImage")
})
