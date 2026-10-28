library(testthat)
library(htmltools)

test_that("crukNavLinkSetup attaches the scroll script dependency", {
  deps <- findDependencies(crukNavLinkSetup())
  nav_dep <- Filter(function(d) d$name == "crukNavLink", deps)

  expect_length(nav_dep, 1)
  expect_equal(nav_dep[[1]]$script, "javascript/scrollToDivWhenReady.js")
})

test_that("the scroll script exists in the installed package", {
  expect_true(
    file.exists(
      system.file("www", "javascript", "scrollToDivWhenReady.js", package = "shinyCRUK")
    )
  )
})

test_that("crukNavLink validates its arguments", {
  expect_error(crukNavLink(1, "nav", "page"), "valueBoxId")
  expect_error(crukNavLink(character(0), "nav", "page"), "valueBoxId")
  expect_error(crukNavLink("box", c("a", "b"), "page"), "navId")
  expect_error(crukNavLink("box", "nav", NA_character_), "targetPage")
  expect_error(crukNavLink("box", "nav", "page", targetDiv = 1), "targetDiv")
  expect_error(crukNavLink("box", "nav", "page", timeoutMs = "a"), "timeoutMs")
  expect_error(crukNavLink("box", "nav", "page", asis = NA), "asis")
})

test_that("crukNavLink rejects arguments that cannot be recycled", {
  expect_error(
    crukNavLink(c("a", "b", "c"), "nav", c("p1", "p2")),
    "same length"
  )
})

test_that("crukNavLink needs a Shiny session", {
  expect_error(crukNavLink("box", "nav", "page"), "inside a Shiny")
})
