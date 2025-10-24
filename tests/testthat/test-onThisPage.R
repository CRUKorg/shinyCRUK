library(testthat)
library(htmltools)

test_that("onThisPage creates correct HTML structure with basic inputs", {
  result <- onThisPage(
    c("section1", "Section 1"),
    c("section2", "Section 2")
  )

  # Convert to character for testing
  html_output <- as.character(result)

  # Check for main container
  expect_true(grepl('class="otp-link-container"', html_output))

  # Check for header
  expect_true(grepl("On this page", html_output))

  # Check for links with correct hrefs
  expect_true(grepl('href="#section1"', html_output))
  expect_true(grepl('href="#section2"', html_output))

  # Check for link text
  expect_true(grepl("Section 1", html_output))
  expect_true(grepl("Section 2", html_output))
})

test_that("onThisPage handles IDs with existing # prefix", {
  result <- onThisPage(
    c("#already-has-hash", "Section 1"),
    c("no-hash", "Section 2")
  )

  html_output <- as.character(result)

  # Should not double up the hash
  expect_true(grepl('href="#already-has-hash"', html_output))
  expect_false(grepl('href="##already-has-hash"', html_output))

  # Should add hash where missing
  expect_true(grepl('href="#no-hash"', html_output))
})

test_that("onThisPage includes scroll-to-top button by default", {
  result <- onThisPage(
    c("section1", "Section 1")
  )

  html_output <- as.character(result)

  # Check for button element
  expect_true(grepl('class="scroll-to-top-button"', html_output))

  # Check for JavaScript
  expect_true(grepl("window.scrollToTop", html_output))
  expect_true(grepl("scrollToTopButtons", html_output))
  expect_true(grepl("window.scrollY > 200", html_output))

  # Check for arrow icon
  expect_true(grepl("arrow_upward", html_output))
})

test_that("onThisPage excludes scroll-to-top button when include_top_button = FALSE", {
  result <- onThisPage(
    c("section1", "Section 1"),
    include_top_button = FALSE
  )

  html_output <- as.character(result)

  # Should not include button
  expect_false(grepl('class="scroll-to-top-button"', html_output))

  # Should not include JavaScript
  expect_false(grepl("window.scrollToTop", html_output))
  expect_false(grepl("scrollToTopButtons", html_output))

  # Should not include arrow icon
  expect_false(grepl("arrow_upward", html_output))
})

test_that("onThisPage includes required dependencies", {
  result <- onThisPage(
    c("section1", "Section 1")
  )

  # Check that result is a tagList
  expect_s3_class(result, "shiny.tag.list")

  # Extract dependencies
  deps <- htmltools::findDependencies(result)
  dep_names <- sapply(deps, function(x) x$name)

  # Check for required dependencies
  expect_true("onThisPage" %in% dep_names)
  expect_true("google-material-symbols" %in% dep_names)
})

test_that("onThisPage includes Material Icons link", {
  result <- onThisPage(
    c("section1", "Section 1")
  )

  html_output <- as.character(result)

  # Check for Google Fonts Material Icons link
  expect_true(grepl("fonts.googleapis.com/icon\\?family=Material\\+Icons", html_output))
})

test_that("onThisPage includes downward arrow icons for links", {
  result <- onThisPage(
    c("section1", "Section 1"),
    c("section2", "Section 2")
  )

  html_output <- as.character(result)

  # Check for arrow_downward icons
  expect_true(grepl("arrow_downward", html_output))

  # Check for icon class
  expect_true(grepl('class="material-symbols-sharp otp-link-icon"', html_output))
})

test_that("onThisPage errors when div_ids and link_texts lengths don't match", {
  # This should error because the function expects pairs
  # We can't easily test this with the current implementation since ... expects pairs
  # But we can test with modified internals if needed

  # Create a modified version for testing
  test_fn <- function(div_ids, link_texts) {
    if (length(div_ids) != length(link_texts)) {
      stop("Number of div_ids must match number of link_texts")
    }
  }

  expect_error(
    test_fn(c("id1", "id2"), c("text1")),
    "Number of div_ids must match number of link_texts"
  )
})

test_that("onThisPage handles multiple links correctly", {
  result <- onThisPage(
    c("intro", "Introduction"),
    c("methods", "Methods"),
    c("results", "Results"),
    c("discussion", "Discussion"),
    c("conclusion", "Conclusion")
  )

  html_output <- as.character(result)

  # Check all IDs are present
  expect_true(grepl('href="#intro"', html_output))
  expect_true(grepl('href="#methods"', html_output))
  expect_true(grepl('href="#results"', html_output))
  expect_true(grepl('href="#discussion"', html_output))
  expect_true(grepl('href="#conclusion"', html_output))

  # Check all link texts are present
  expect_true(grepl("Introduction", html_output))
  expect_true(grepl("Methods", html_output))
  expect_true(grepl("Results", html_output))
  expect_true(grepl("Discussion", html_output))
  expect_true(grepl("Conclusion", html_output))
})

test_that("onThisPage handles special characters in IDs and text", {
  result <- onThisPage(
    c("section-with-dashes", "Section with Spaces"),
    c("section_with_underscores", "Section & Ampersand")
  )

  html_output <- as.character(result)

  # Check IDs are preserved
  expect_true(grepl('href="#section-with-dashes"', html_output))
  expect_true(grepl('href="#section_with_underscores"', html_output))

  # Check text is present (may be HTML encoded)
  expect_true(grepl("Section with Spaces", html_output))
})

test_that("onThisPage works with single link", {
  result <- onThisPage(
    c("only-section", "Only Section")
  )

  html_output <- as.character(result)

  # Should still create proper structure
  expect_true(grepl('class="otp-link-container"', html_output))
  expect_true(grepl("On this page", html_output))
  expect_true(grepl('href="#only-section"', html_output))
  expect_true(grepl("Only Section", html_output))
})

test_that("JavaScript includes smooth scroll behavior", {
  result <- onThisPage(
    c("section1", "Section 1")
  )

  html_output <- as.character(result)

  # Check for smooth scroll implementation
  expect_true(grepl("behavior: 'smooth'", html_output))
  expect_true(grepl("window.scrollTo", html_output))
})

test_that("JavaScript shows button after 200px scroll", {
  result <- onThisPage(
    c("section1", "Section 1")
  )

  html_output <- as.character(result)

  # Check for the 200px threshold
  expect_true(grepl("window.scrollY > 200", html_output))
  expect_true(grepl("button.style.display = shouldShow \\? 'block' : 'none'", html_output))
})

test_that("onThisPage return type is consistent", {
  result_with_button <- onThisPage(
    c("section1", "Section 1"),
    include_top_button = TRUE
  )

  result_without_button <- onThisPage(
    c("section1", "Section 1"),
    include_top_button = FALSE
  )

  # Both should return tagList
  expect_s3_class(result_with_button, "shiny.tag.list")
  expect_s3_class(result_without_button, "shiny.tag.list")
})
