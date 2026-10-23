test_that("window_is_narrow is FALSE until a width is reported", {
  server <- function(input, output, session) {
    ws <- shiny::reactive(input$ws)
    is_narrow <- window_is_narrow(ws)
  }

  shiny::testServer(server, {
    expect_false(is_narrow())

    session$setInputs(ws = list(width = NA, height = NA))
    expect_false(is_narrow())
  })
})

test_that("window_is_narrow follows the breakpoint", {
  server <- function(input, output, session) {
    ws <- shiny::reactive(input$ws)
    is_narrow <- window_is_narrow(ws, breakpoint = 900)
  }

  shiny::testServer(server, {
    session$setInputs(ws = list(width = 1200, height = 800))
    expect_false(is_narrow())

    session$setInputs(ws = list(width = 899, height = 800))
    expect_true(is_narrow())

    # the breakpoint itself is not narrow
    session$setInputs(ws = list(width = 900, height = 800))
    expect_false(is_narrow())
  })
})

test_that("window_is_narrow does not invalidate dependents within a band", {
  runs <- 0

  server <- function(input, output, session) {
    ws <- shiny::reactive(input$ws)
    is_narrow <- window_is_narrow(ws, breakpoint = 900)

    shiny::observe({
      is_narrow()
      runs <<- runs + 1
    })
  }

  shiny::testServer(server, {
    session$setInputs(ws = list(width = 1200, height = 800))
    baseline <- runs

    session$setInputs(ws = list(width = 1100, height = 800))
    session$setInputs(ws = list(width = 950, height = 600))
    expect_equal(runs, baseline)

    session$setInputs(ws = list(width = 500, height = 600))
    expect_equal(runs, baseline + 1)
  })
})

test_that("window_is_narrow validates its arguments", {
  expect_error(window_is_narrow(list(width = 400)), "reactive")
  expect_error(window_is_narrow(function() list(width = 400), breakpoint = "a"), "breakpoint")
  expect_error(window_is_narrow(function() list(width = 400), breakpoint = c(600, 900)), "breakpoint")
})
