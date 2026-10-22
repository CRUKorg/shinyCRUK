card <- function(..., alt = "A sufficiently long alt text for the tests.") {
  crukChartTable(
    chart = shiny::plotOutput("p"),
    table = shiny::tableOutput("t"),
    alt = alt,
    ...
  )
}

test_that("no source line is added when text and link are omitted", {
  html <- as.character(card())
  expect_false(grepl("Data source", html, fixed = TRUE))
  expect_false(grepl("no-border-card-source", html, fixed = TRUE))
})

test_that("empty strings and NULL count as not supplied", {
  html <- as.character(card(dataSourceText = "", dataSourceLink = NULL))
  expect_false(grepl("Data source", html, fixed = TRUE))
})

test_that("text and link: the text is the link and the URL is not displayed", {
  url <- "https://example.com/data"
  html <- as.character(card(dataSourceText = "NHS Digital", dataSourceLink = url))
  expect_match(html, "Data source: ", fixed = TRUE)
  expect_match(html, paste0('<a href="', url, '">'), fixed = TRUE)
  expect_match(html, "NHS Digital", fixed = TRUE)
  # URL appears only once (in the href), not as visible text
  expect_equal(lengths(regmatches(html, gregexpr(url, html, fixed = TRUE))), 1L)
})

test_that("text only gives plain text with no anchor in the source line", {
  html <- as.character(card(dataSourceText = "NHS Digital"))
  expect_match(html, "NHS Digital", fixed = TRUE)
  # The tab headers are <a> elements too, so only look inside the source div
  source_html <- strsplit(html, "no-border-card-source", fixed = TRUE)[[1]][2]
  expect_false(is.na(source_html))
  expect_false(grepl("<a ", source_html, fixed = TRUE))
})

test_that("link without text warns and adds no source line", {
  expect_warning(html <- as.character(card(dataSourceLink = "https://example.com")), "dataSourceText")
  expect_false(grepl("Data source", html, fixed = TRUE))
})

test_that("output tags are inserted as tags and made inline", {
  html <- as.character(card(dataSourceText = shiny::textOutput("txt")))
  expect_match(html, "shiny-text-output", fixed = TRUE)
  expect_false(grepl('<div id="txt"', html, fixed = TRUE))
  expect_false(grepl("&lt;", html, fixed = TRUE))
})

test_that("reactive link: text is the anchor label, output is hidden, script is attached", {
  for (link in list(shiny::textOutput("lnk"), shiny::uiOutput("lnk"))) {
    html <- as.character(card(dataSourceText = "NHS Digital", dataSourceLink = link))
    expect_match(html, 'id="lnk-source-link"', fixed = TRUE)
    expect_match(html, 'id="lnk"', fixed = TRUE)
    expect_match(html, 'aria-hidden="true"', fixed = TRUE)
    expect_match(html, "MutationObserver", fixed = TRUE)
  }
})

test_that("invalid link or text types error", {
  expect_error(card(dataSourceText = "x", dataSourceLink = c("a", "b")), "dataSourceLink")
  expect_error(card(dataSourceText = 1:2), "dataSourceText")
})

test_that("alt text over 125 characters warns rather than errors", {
  long_alt <- strrep("a", 126)
  expect_warning(card(alt = long_alt), "125 characters")
  expect_no_error(suppressWarnings(card(alt = long_alt)))
})

test_that("alt text under 15 characters still errors", {
  expect_error(card(alt = "too short"), "descriptive")
})
