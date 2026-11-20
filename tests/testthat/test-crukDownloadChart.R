test_that("crukDownloadChartButton builds a button with the expected data attributes", {
  html <- as.character(
    crukDownloadChartButton("my_plot", filename = "my-chart", heading = "A heading", scale = 3)
  )

  expect_match(html, "<button", fixed = TRUE)
  expect_match(html, 'data-plot-id="my_plot"', fixed = TRUE)
  expect_match(html, 'data-filename="my-chart"', fixed = TRUE)
  expect_match(html, 'data-heading="A heading"', fixed = TRUE)
  expect_match(html, 'data-scale="3"', fixed = TRUE)
  expect_match(html, "cruk-download-chart", fixed = TRUE)
  expect_match(html, "Download chart", fixed = TRUE)
})

test_that("headingId is used and absent attributes are dropped", {
  html <- as.character(crukDownloadChartButton("p", headingId = "title_h3"))

  expect_match(html, 'data-heading-id="title_h3"', fixed = TRUE)
  expect_false(grepl("data-heading=", html, fixed = TRUE))
})

test_that("subheadingId is used and absent when not supplied", {
  html <- as.character(crukDownloadChartButton("p", headingId = "h", subheadingId = "sub_h4"))
  expect_match(html, 'data-subheading-id="sub_h4"', fixed = TRUE)
  expect_match(html, 'data-heading-id="h"', fixed = TRUE)

  without <- as.character(crukDownloadChartButton("p", headingId = "h"))
  expect_false(grepl("data-subheading-id", without, fixed = TRUE))
})

test_that("subheading string is added alongside subheadingId", {
  html <- as.character(
    crukDownloadChartButton("p", subheading = "Fixed sub", subheadingId = "sub_h4")
  )
  expect_match(html, 'data-subheading="Fixed sub"', fixed = TRUE)
  expect_match(html, 'data-subheading-id="sub_h4"', fixed = TRUE)

  without <- as.character(crukDownloadChartButton("p", subheadingId = "sub_h4"))
  expect_false(grepl("data-subheading=", without, fixed = TRUE))
})

test_that("the button carries CRUK styling classes and an icon by default", {
  html <- as.character(crukDownloadChartButton("p"))

  expect_match(html, "cruk-btn", fixed = TRUE)
  expect_match(html, "cruk-btn-secondary", fixed = TRUE)
  expect_match(html, "cruk-download-chart", fixed = TRUE)
  expect_match(html, "material-symbols-sharp", fixed = TRUE)
  expect_match(html, "cruk-btn-icon-secondary", fixed = TRUE)
  expect_match(html, ">download<", fixed = TRUE)
})

test_that("type, icon, align and class arguments are applied", {
  primary <- as.character(crukDownloadChartButton("p", type = "primary", icon = "share"))
  expect_match(primary, "cruk-btn-primary", fixed = TRUE)
  expect_match(primary, "cruk-btn-icon-primary", fixed = TRUE)
  expect_match(primary, ">share<", fixed = TRUE)

  no_icon <- as.character(crukDownloadChartButton("p", icon = NULL))
  expect_false(grepl("material-symbols-sharp\"", no_icon, fixed = TRUE))

  left <- as.character(crukDownloadChartButton("p", align = "left"))
  expect_match(left, "align-items: flex-start", fixed = TRUE)
  right <- as.character(crukDownloadChartButton("p"))
  expect_match(right, "align-items: flex-end", fixed = TRUE)

  extra <- as.character(crukDownloadChartButton("p", class = "my-extra"))
  expect_match(extra, "my-extra", fixed = TRUE)
  expect_match(extra, "cruk-download-chart", fixed = TRUE)
})

test_that("CSS and JS dependencies are attached", {
  deps <- htmltools::findDependencies(crukDownloadChartButton("p"))
  names <- vapply(deps, function(d) d$name, character(1))

  expect_true("crukButton" %in% names)
  expect_true("crukDownloadChart" %in% names)
})

test_that("invalid input errors", {
  expect_error(crukDownloadChartButton(NULL), "plotId")
  expect_error(crukDownloadChartButton(c("a", "b")), "plotId")
  expect_error(crukDownloadChartButton("p", filename = ""), "filename")
  expect_error(crukDownloadChartButton("p", heading = 1), "heading")
  expect_error(crukDownloadChartButton("p", headingId = c("a", "b")), "headingId")
  expect_error(crukDownloadChartButton("p", subheading = 1), "subheading")
  expect_error(crukDownloadChartButton("p", subheadingId = c("a", "b")), "subheadingId")
  expect_error(crukDownloadChartButton("p", text = ""), "label")
  expect_error(crukDownloadChartButton("p", type = "tertiary"), "primary or secondary")
  expect_error(crukDownloadChartButton("p", icon = "banana"), "Available icons")
  expect_error(crukDownloadChartButton("p", align = "centre"), "right or left")
  expect_error(crukDownloadChartButton("p", scale = 0), "scale")
})
