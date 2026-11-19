html_of <- function(x) paste(as.character(x), collapse = "\n")

count_matches <- function(x, pattern) {
  lengths(regmatches(x, gregexpr(pattern, x)))
}

# Static behaviour (must be unchanged) ------------------------------------

test_that("character notes render as a <p> with a Notes header", {
  html <- html_of(crukSources(notes = "Static note."))

  expect_match(html, '<p>\\s*<span class="notes-header">Notes:</span>')
  expect_match(html, "Static note.", fixed = TRUE)
  expect_equal(count_matches(html, "sources-notes"), 0)
})

test_that("empty or NULL notes omit the notes section", {
  expect_equal(count_matches(html_of(crukSources()), "Notes:"), 0)
  expect_equal(count_matches(html_of(crukSources(notes = "")), "Notes:"), 0)
  expect_equal(count_matches(html_of(crukSources(notes = NULL)), "Notes:"), 0)
})

test_that("the sources header and an empty list render with no sources", {
  html <- html_of(crukSources())

  expect_match(html, '<span class="sources-header">Data sources:</span>')
  expect_match(html, '<ul style="margin-top: 0px"></ul>', fixed = TRUE)
})

test_that("a tagList of <li> is placed inside a single <ul>", {
  html <- html_of(
    crukSources(
      custom_sources = htmltools::tagList(
        htmltools::tags$li("First"),
        htmltools::tags$li("Second")
      )
    )
  )

  expect_equal(count_matches(html, "<ul"), 1)
  expect_equal(count_matches(html, "<li>"), 2)
  expect_match(html, "First", fixed = TRUE)
  expect_match(html, "Second", fixed = TRUE)
})

# Border --------------------------------------------------------------------

test_that("boxBorder adds or omits the border class", {
  expect_match(html_of(crukSources()), '<div class="sources border"', fixed = TRUE)
  expect_match(
    html_of(crukSources(boxBorder = TRUE)),
    '<div class="sources border"',
    fixed = TRUE
  )

  html_no_border <- html_of(crukSources(boxBorder = FALSE))
  expect_match(html_no_border, '<div class="sources">', fixed = TRUE)
  expect_equal(count_matches(html_no_border, "border"), 0)
})

# Dynamic notes -------------------------------------------------------------

test_that("textOutput() notes render in a classed <div>, not a <p>", {
  html <- html_of(crukSources(notes = shiny::textOutput("n")))

  expect_match(html, '<div class="sources-notes">', fixed = TRUE)
  expect_match(html, '<span class="notes-header">Notes:</span>', fixed = TRUE)
  expect_match(html, 'id="n"', fixed = TRUE)
  expect_match(html, "shiny-text-output", fixed = TRUE)
  expect_equal(count_matches(html, "<p>"), 0)
})

test_that("uiOutput() notes render in a classed <div>, not a <p>", {
  html <- html_of(crukSources(notes = shiny::uiOutput("n")))

  expect_match(html, '<div class="sources-notes">', fixed = TRUE)
  expect_match(html, "shiny-html-output", fixed = TRUE)
  expect_equal(count_matches(html, "<p>"), 0)
})

test_that("dynamic notes always show the Notes header", {
  html <- html_of(crukSources(notes = shiny::textOutput("n")))

  expect_equal(count_matches(html, "Notes:"), 1)
})

# Dynamic sources -----------------------------------------------------------

test_that("uiOutput() custom_sources becomes the <ul> itself", {
  html <- html_of(crukSources(custom_sources = shiny::uiOutput("s")))

  expect_match(html, '<ul[^>]*id="s"')
  expect_match(html, '<ul[^>]*shiny-html-output')
  expect_match(html, "margin-top: 0px", fixed = TRUE)
  expect_equal(count_matches(html, '<div[^>]*id="s"'), 0)
  expect_equal(count_matches(html, "<ul"), 1)
})

test_that("uiOutput() with a custom container is still recognised", {
  html <- html_of(
    crukSources(custom_sources = shiny::uiOutput("s", container = htmltools::span))
  )

  expect_match(html, '<ul[^>]*id="s"')
  expect_equal(count_matches(html, "<ul"), 1)
})

test_that("textOutput() custom_sources is wrapped in a single <li>", {
  html <- html_of(crukSources(custom_sources = shiny::textOutput("src")))

  expect_match(html, '<li>\\s*<div id="src"')
  expect_match(html, "shiny-text-output", fixed = TRUE)
  expect_equal(count_matches(html, "<ul"), 1)
  expect_equal(count_matches(html, "<li>"), 1)
})

test_that("an output nested in a tagList() is not recognised and keeps the <ul> wrapper", {
  html <- html_of(
    crukSources(custom_sources = htmltools::tagList(shiny::uiOutput("s")))
  )

  expect_match(html, '<div[^>]*id="s"')
  expect_equal(count_matches(html, '<ul[^>]*id="s"'), 0)
})

test_that("dynamic notes and dynamic sources work together", {
  html <- html_of(
    crukSources(
      notes = shiny::textOutput("n"),
      custom_sources = shiny::uiOutput("s")
    )
  )

  expect_match(html, '<div class="sources-notes">', fixed = TRUE)
  expect_match(html, '<ul[^>]*id="s"')
})

# Zotero --------------------------------------------------------------------

test_that("zotero_path produces a single zotero-list <ul> and ignores custom_sources", {
  skip_if_not(utils::packageVersion("testthat") >= "3.2.0")

  testthat::local_mocked_bindings(
    get_zotero_sources = function(...) {
      c(
        'A Author. <a href="https://example.com">Title</a>, 2024.',
        "B Author. Other title, 2023."
      )
    }
  )

  html <- html_of(
    crukSources(
      zotero_path = "Some/Collection",
      custom_sources = htmltools::tagList(htmltools::tags$li("Ignored"))
    )
  )

  expect_match(html, '<ul[^>]*class="zotero-list"')
  expect_equal(count_matches(html, "<ul"), 1)
  expect_equal(count_matches(html, "<li>"), 2)
  expect_match(html, '<a href="https://example.com">Title</a>', fixed = TRUE)
  expect_equal(count_matches(html, "Ignored"), 0)
})

# Dependencies --------------------------------------------------------------

test_that("the CSS dependency is attached and the file exists", {
  deps <- htmltools::findDependencies(crukSources())

  expect_contains(vapply(deps, function(x) x$name, character(1)), "crukSources")
  expect_gt(
    nchar(system.file("www", "css", "crukSources.css", package = "shinyCRUK")),
    0
  )
})

# Internal helper -----------------------------------------------------------

test_that("has_output_class() recognises only shiny tags with the given class", {
  expect_identical(has_output_class(shiny::textOutput("a"), "shiny-text-output"), TRUE)
  expect_identical(has_output_class(shiny::uiOutput("a"), "shiny-html-output"), TRUE)
  expect_identical(has_output_class(shiny::uiOutput("a"), "shiny-text-output"), FALSE)
  expect_identical(has_output_class(htmltools::tags$li("x"), "shiny-text-output"), FALSE)
  expect_identical(has_output_class(NULL, "shiny-text-output"), FALSE)
  expect_identical(has_output_class("a string", "shiny-text-output"), FALSE)
  expect_identical(
    has_output_class(htmltools::tagList(shiny::uiOutput("a")), "shiny-html-output"),
    FALSE
  )
})
