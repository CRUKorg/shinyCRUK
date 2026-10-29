test_that("crukCheckbox renders id, label and wrapper class", {
  html <- as.character(crukCheckbox("chk", "Exclude unknown stage"))
  expect_match(html, "cruk-checkbox", fixed = TRUE)
  expect_match(html, 'id="chk"', fixed = TRUE)
  expect_match(html, "Exclude unknown stage", fixed = TRUE)
})

test_that("alignWithInput defaults to TRUE and adds the alignment class", {
  expect_match(as.character(crukCheckbox("chk", "x")),
               "cruk-checkbox-align", fixed = TRUE)
  expect_match(as.character(crukCheckbox("chk", "x", alignWithInput = TRUE)),
               "cruk-checkbox-align", fixed = TRUE)
})

test_that("alignWithInput = FALSE omits the alignment class", {
  html <- as.character(crukCheckbox("chk", "x", alignWithInput = FALSE))
  expect_false(grepl("cruk-checkbox-align", html, fixed = TRUE))
})

test_that("crukCheckbox validates inputId", {
  expect_error(crukCheckbox(1, "x"), "inputId")
})
