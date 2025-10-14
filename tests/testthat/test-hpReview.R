test_that("hpReview builds correct HTML structure", {
  result <- hpReview("2025-10-14")

  # Check it’s an htmltools tag object
  expect_s3_class(result, "shiny.tag")

  # Convert to character for content checks
  html_out <- as.character(result)

  # Check for key text content
  expect_match(html_out, "Health professionals")
  expect_match(html_out, "Last reviewed: 2025-10-14")

  # Check for structure (spans/divs)
  expect_match(html_out, "<div")
  expect_match(html_out, "<span")

  # Optional: ensure inline styles were included
  expect_match(html_out, "background: #e2f4fd;")
})
