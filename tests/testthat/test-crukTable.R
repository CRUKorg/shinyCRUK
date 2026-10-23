test_that("crukTable returns a reactable widget with the CRUK stylesheet", {
  tbl <- crukTable(head(mtcars))

  expect_s3_class(tbl, "reactable")
  dep_names <- vapply(tbl$dependencies, `[[`, character(1), "name")
  expect_true("crukTable" %in% dep_names)
})

test_that("crukTable adds modifier classes from its arguments", {
  html_sel <- as.character(htmltools::as.tags(crukTable(head(mtcars))))
  expect_true(grepl("cruk-table--selectable", html_sel))

  html_nosel <- as.character(
    htmltools::as.tags(crukTable(head(mtcars), selection = NULL))
  )
  expect_false(grepl("cruk-table--selectable", html_nosel))
})

test_that("crukTable handles empty data", {
  expect_no_error(crukTable(mtcars[0, ]))
})

test_that("crukTable validates arguments", {
  expect_error(crukTable(list(a = 1)), "data frame or matrix")
  expect_error(crukTable(mtcars, sortable = "yes"), "TRUE or FALSE")
  expect_error(crukTable(mtcars, selection = "all"), "single")
  expect_error(crukTable(mtcars, selection = c("single", "multiple")), "single")
})

test_that("crukTableOutput keeps reactable's dependencies and adds the CSS", {
  out <- crukTableOutput("tbl")
  dep_names <- vapply(
    htmltools::findDependencies(out), `[[`, character(1), "name"
  )

  expect_true("crukTable" %in% dep_names)
  expect_true("reactable" %in% dep_names)
})

test_that("renderCrukTable returns a Shiny render function", {
  rendered <- renderCrukTable(head(mtcars))
  expect_true(is.function(rendered))
})

test_that("renderCrukTable reacts to reactive arguments of crukTable()", {
  server <- function(input, output, session) {
    output$table <- renderCrukTable({
      crukTable(head(mtcars), pagination = input$paginate)
    })
  }

  shiny::testServer(server, {
    session$setInputs(paginate = FALSE)
    off <- output$table

    session$setInputs(paginate = TRUE)
    on <- output$table

    expect_false(identical(off, on))
  })
})

test_that("renderCrukTable accepts data and reacts to reactive data", {
  server <- function(input, output, session) {
    filtered <- reactive(mtcars[mtcars$cyl == input$cyl, ])
    output$table <- renderCrukTable(filtered())
  }

  shiny::testServer(server, {
    session$setInputs(cyl = 4)
    four <- output$table

    session$setInputs(cyl = 8)
    eight <- output$table

    expect_false(identical(four, eight))
  })
})

test_that("renderCrukTable errors on unsupported return values", {
  server <- function(input, output, session) {
    output$table <- renderCrukTable("not a table")
  }

  shiny::testServer(server, {
    expect_error(output$table, "expects `crukTable\\(\\)`")
  })
})

test_that("crukTable draws a compact table when WindowSize is below the breakpoint", {
  html <- function(...) as.character(htmltools::as.tags(crukTable(head(mtcars), ...)))

  expect_false(grepl("cruk-table--compact", html()))
  expect_false(grepl("cruk-table--compact", html(WindowSize = list(width = 1000))))
  expect_false(grepl("cruk-table--compact", html(WindowSize = list(width = NA))))
  expect_true(grepl("cruk-table--compact", html(WindowSize = list(width = 400))))
  expect_true(
    grepl("cruk-table--compact", html(WindowSize = list(width = 900), mobileBreakpoint = 1000))
  )
})

test_that("crukTable redraws when the WindowSize value changes in renderCrukTable", {
  server <- function(input, output, session) {
    ws <- shiny::reactive(input$ws)
    output$table <- renderCrukTable(crukTable(head(mtcars), WindowSize = ws()))
  }

  shiny::testServer(server, {
    session$setInputs(ws = list(width = 1200))
    wide <- output$table
    session$setInputs(ws = list(width = 400))
    narrow <- output$table
    expect_false(identical(wide, narrow))
  })
})

test_that("crukTable draws a compact table when mobile is TRUE", {
  html <- function(...) as.character(htmltools::as.tags(crukTable(head(mtcars), ...)))

  expect_true(grepl("cruk-table--compact", html(mobile = TRUE)))
  expect_false(grepl("cruk-table--compact", html(mobile = FALSE)))
  expect_false(grepl("cruk-table--compact", html(mobile = NULL)))
})

test_that("crukTable's mobile argument takes precedence over WindowSize", {
  html <- function(...) as.character(htmltools::as.tags(crukTable(head(mtcars), ...)))

  expect_true(
    grepl("cruk-table--compact", html(mobile = TRUE, WindowSize = list(width = 1600)))
  )
  expect_false(
    grepl("cruk-table--compact", html(mobile = FALSE, WindowSize = list(width = 300)))
  )

  # NULL means "not supplied", so WindowSize still applies
  expect_true(
    grepl("cruk-table--compact", html(mobile = NULL, WindowSize = list(width = 300)))
  )
})

test_that("crukTable validates mobile", {
  expect_error(crukTable(mtcars, mobile = "yes"), "mobile.*TRUE or FALSE")
  expect_error(crukTable(mtcars, mobile = NA), "mobile.*TRUE or FALSE")
  expect_error(crukTable(mtcars, mobile = c(TRUE, FALSE)), "mobile.*TRUE or FALSE")
})

test_that("the compact table shares mobileMaxWidth between columns", {
  four_cols <- head(mtcars)[, 1:4]

  # 375 / 4 columns = 93px, between the 40px floor and the 100px ceiling
  expect_equal(cruk_default_col_def(four_cols, TRUE, 375)$minWidth, 93)
  expect_null(cruk_default_col_def(four_cols, FALSE, 375)$minWidth)
})

test_that("a table using window_is_narrow() is only redrawn when the window crosses the breakpoint", {
  renders <- 0

  server <- function(input, output, session) {
    ws <- shiny::reactive(input$ws)
    is_narrow <- window_is_narrow(ws, breakpoint = 900)

    output$table <- renderCrukTable({
      renders <<- renders + 1
      crukTable(head(mtcars), mobile = is_narrow())
    })
  }

  shiny::testServer(server, {
    session$setInputs(ws = list(width = 1200, height = 800))
    output$table
    after_first <- renders

    # Resizes within the same band must not redraw the table
    session$setInputs(ws = list(width = 1100, height = 800))
    output$table
    session$setInputs(ws = list(width = 1000, height = 700))
    output$table
    expect_equal(renders, after_first)

    # Crossing the breakpoint does
    session$setInputs(ws = list(width = 400, height = 700))
    output$table
    expect_equal(renders, after_first + 1)

    # ...and so does crossing back
    session$setInputs(ws = list(width = 1200, height = 800))
    output$table
    expect_equal(renders, after_first + 2)
  })
})

test_that("crukTable treats a NULL WindowSize as full size", {
  html <- as.character(htmltools::as.tags(crukTable(head(mtcars), WindowSize = NULL)))
  expect_false(grepl("cruk-table--compact", html))
})

test_that("crukTable validates WindowSize", {
  expect_error(crukTable(mtcars, WindowSize = "small"), "WindowSize")
  expect_error(
    crukTable(mtcars, WindowSize = function() list(width = 400)),
    "not the reactive"
  )
})

test_that("crukTable switches pagination on when only defaultPageSize is given", {
  attribs <- function(...) crukTable(mtcars, ...)$x$tag$attribs

  # reactable leaves `pagination` out of the widget when it is on (its default),
  # so a missing value means "on"; only FALSE is stored.
  paginated <- function(a) is.null(a$pagination) || isTRUE(a$pagination)

  expect_false(paginated(attribs()))

  paged <- attribs(defaultPageSize = 5)
  expect_true(paginated(paged))
  expect_equal(paged$defaultPageSize, 5)

  expect_true(paginated(attribs(pagination = TRUE)))
  expect_equal(attribs(pagination = TRUE)$defaultPageSize, 10)

  expect_warning(
    off <- attribs(pagination = FALSE, defaultPageSize = 5),
    "ignored"
  )
  expect_false(paginated(off))
  expect_equal(off$defaultPageSize, nrow(mtcars))
})

test_that("crukTable validates defaultPageSize", {
  expect_error(crukTable(mtcars, defaultPageSize = 0), "defaultPageSize")
  expect_error(crukTable(mtcars, defaultPageSize = "5"), "defaultPageSize")
  expect_error(crukTable(mtcars, defaultPageSize = c(5, 10)), "defaultPageSize")
})

test_that("cruk_columns hides the selection column unless told otherwise", {
  cols <- cruk_columns(NULL, "multiple")
  expect_named(cols, ".selection")
  expect_false(cols$.selection$show)

  # existing column definitions are kept
  cols <- cruk_columns(list(mpg = reactable::colDef(name = "MPG")), "single")
  expect_named(cols, c("mpg", ".selection"))

  # no selection, nothing to hide
  expect_null(cruk_columns(NULL, NULL))

  # a caller's own .selection definition wins
  own <- list(.selection = reactable::colDef(width = 60))
  expect_identical(cruk_columns(own, "multiple"), own)
})
