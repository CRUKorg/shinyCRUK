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
