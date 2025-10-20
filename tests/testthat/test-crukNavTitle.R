test_that("crukNavTitle creates correct structure with no selectors", {
  result <- crukNavTitle(Title = "Test App", selectors = 0)

  expect_s3_class(result, "shiny.tag.list")
  expect_true(any(grepl("navbar-cruk", as.character(result))))
  expect_true(any(grepl("Test App", as.character(result))))
})

test_that("crukNavTitle creates correct structure with 1 selector", {
  selector <- shiny::selectInput("test", "Test:", choices = c("A", "B"))
  result <- crukNavTitle(
    Title = "Test App",
    selectors = 1,
    selector1 = selector
  )

  expect_s3_class(result, "shiny.tag.list")
  expect_true(any(grepl("selector-1", as.character(result))))
})

test_that("crukNavTitle creates correct structure with 2 selectors", {
  selector1 <- shiny::selectInput("test1", "Test 1:", choices = c("A", "B"))
  selector2 <- shiny::selectInput("test2", "Test 2:", choices = c("C", "D"))

  result <- crukNavTitle(
    Title = "Test App",
    selectors = 2,
    selector1 = selector1,
    selector2 = selector2
  )

  expect_s3_class(result, "shiny.tag.list")
  expect_true(any(grepl("selector-1", as.character(result))))
  expect_true(any(grepl("selector-2", as.character(result))))
})

test_that("crukNavTitle handles HTML in title", {
  result <- crukNavTitle(Title = "<strong>Bold Title</strong>", selectors = 0)

  expect_true(any(grepl("<strong>Bold Title</strong>", as.character(result))))
})

test_that("crukNavTitle includes action link with correct ID", {
  result <- crukNavTitle(Title = "Test", selectors = 0)

  expect_true(any(grepl("app_title_link", as.character(result))))
})

test_that("crukNavTitle includes CRUK logo link", {
  result <- crukNavTitle(Title = "Test", selectors = 0)

  expect_true(any(grepl("cancerresearchuk.org", as.character(result))))
})

test_that("crukNavTitle warns when selector parameter missing", {
  expect_warning(
    crukNavTitle(Title = "Test", selectors = 1, selector1 = NULL),
    "selector1 is NULL but selectors >= 1"
  )
})
