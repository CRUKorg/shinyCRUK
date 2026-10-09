#' Create a CRUK-branded table
#'
#' Builds a \code{reactable::reactable()} widget with CRUK styling. All styling
#' comes from \code{inst/www/css/tables.css}, which is attached as an HTML
#' dependency. In a Shiny app you will usually use \code{crukTableOutput()} in
#' the UI and \code{renderCrukTable()} in the server instead of calling this
#' directly. Call it directly in R Markdown, Quarto, or for static tables.
#'
#' @param data A data frame or matrix to display.
#' @param columns Optional named list of column definitions created with
#'   \code{reactable::colDef()}.
#' @param sortable Logical. Whether columns can be sorted by clicking the
#'   column headers. Default is \code{TRUE}.
#' @param filterable Logical. Whether filter inputs are displayed for columns.
#'   Default is \code{TRUE}.
#' @param selection Row selection mode: \code{"multiple"}, \code{"single"}, or
#'   \code{NULL} for no selection. Default is \code{"multiple"}.
#' @param onClick Action to perform when a row is clicked. Defaults to
#'   \code{"select"} when \code{selection} is set, otherwise \code{NULL}.
#' @param highlight Logical. Whether rows are highlighted on hover.
#'   Default is \code{TRUE}.
#' @param pagination Logical. Whether pagination is enabled.
#'   Default is \code{FALSE}.
#' @param defaultPageSize Number of rows per page. If \code{NULL}, all rows are
#'   shown when pagination is off and 10 when it is on.
#' @param class Optional extra CSS class(es) for the table.
#' @param ... Additional arguments passed to \code{reactable::reactable()}.
#'
#' @return A \code{reactable} htmlwidget with the CRUK table stylesheet
#'   attached.
#'
#' @seealso [crukTableOutput()], [renderCrukTable()]
#' @export
#'
#' @examples
#' crukTable(head(mtcars), filterable = FALSE, selection = NULL)
crukTable <- function(
    data,
    columns = NULL,
    sortable = TRUE,
    filterable = TRUE,
    selection = "multiple",
    onClick = if (!is.null(selection)) "select" else NULL,
    highlight = TRUE,
    pagination = FALSE,
    defaultPageSize = NULL,
    class = NULL,
    ...
) {

  # Validation checks
  if (!is.data.frame(data) && !is.matrix(data)) {
    stop("`data` must be a data frame or matrix", call. = FALSE)
  }

  check_flag(sortable, "sortable")
  check_flag(filterable, "filterable")
  check_flag(highlight, "highlight")
  check_flag(pagination, "pagination")

  if (!is.null(selection) &&
      !(is.character(selection) && length(selection) == 1 &&
        selection %in% c("single", "multiple"))) {
    stop("`selection` must be \"single\", \"multiple\", or NULL", call. = FALSE)
  }

  # Show all rows when pagination is disabled. max() avoids a page size of 0
  # for empty data.
  if (is.null(defaultPageSize)) {
    defaultPageSize <- if (pagination) 10L else max(nrow(data), 1L)
  }

  # Modifier classes let the CSS react to the arguments, so it doesn't have to
  # guess from reactable's internal markup (e.g. whether a selection column
  # exists).
  table_class <- paste(
    c(
      "cruk-table",
      if (!is.null(selection)) "cruk-table--selectable",
      if (highlight) "cruk-table--highlight",
      if (sortable) "cruk-table--sortable",
      class
    ),
    collapse = " "
  )

  widget <- reactable::reactable(
    data,
    columns = columns,
    sortable = sortable,
    filterable = filterable,
    selection = selection,
    onClick = onClick,
    highlight = highlight,
    borderless = TRUE,
    pagination = pagination,
    defaultPageSize = defaultPageSize,
    defaultColDef = reactable::colDef(
      align = "left",
      headerStyle = list(textAlign = "left")
    ),
    class = table_class,
    ...
  )

  # Attach the stylesheet to the widget itself so static use (R Markdown,
  # Quarto, or a table built in the UI) still gets the CSS.
  widget$dependencies <- c(widget$dependencies, list(cruk_table_dependency()))
  widget
}


#' CRUK table output for Shiny
#'
#' UI counterpart to [renderCrukTable()]. A thin wrapper around
#' \code{reactable::reactableOutput()} that also loads the CRUK table
#' stylesheet, so the CSS is on the page before any data arrives.
#'
#' Because this is a reactable output, reactable helpers such as
#' \code{reactable::getReactableState()} and \code{reactable::updateReactable()}
#' work with the same \code{outputId}.
#'
#' @param outputId Output variable to read the table from.
#' @param width,height Width and height of the output, passed to
#'   \code{reactable::reactableOutput()}.
#' @param inline Use an inline element for the output container.
#'
#' @return A Shiny UI output element.
#'
#' @seealso [renderCrukTable()], [crukTable()]
#' @export
#'
#' @examples
#' if (interactive()) {
#'   library(shiny)
#'
#'   ui <- fluidPage(
#'     crukTheme(),
#'     selectInput("cyl", "Cylinders", choices = sort(unique(mtcars$cyl))),
#'     crukTableOutput("table")
#'   )
#'
#'   server <- function(input, output, session) {
#'     filtered <- reactive(mtcars[mtcars$cyl == input$cyl, ])
#'
#'     output$table <- renderCrukTable(crukTable(filtered(), filterable = FALSE))
#'   }
#'
#'   shinyApp(ui, server)
#' }
crukTableOutput <- function(outputId, width = "auto", height = "auto",
                            inline = FALSE) {
  output <- reactable::reactableOutput(
    outputId,
    width = width,
    height = height,
    inline = inline
  )

  # append = TRUE keeps reactable's own dependencies
  htmltools::attachDependencies(output, cruk_table_dependency(), append = TRUE)
}


#' Render a CRUK table in Shiny
#'
#' Server counterpart to [crukTableOutput()]. \code{expr} is evaluated
#' reactively and can return either:
#'
#' * a table built with [crukTable()], so you can set any of its arguments
#'   (and use reactive values in them), or
#' * a data frame or matrix, which is passed to [crukTable()] with its
#'   default arguments.
#'
#' Returning \code{NULL} renders nothing.
#'
#' @param expr An expression that returns a [crukTable()], a data frame or a
#'   matrix.
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression? Mainly useful for other
#'   functions that wrap this one.
#'
#' @return A render function for use as \code{output$id}.
#'
#' @seealso [crukTableOutput()], [crukTable()]
#' @export
#'
#' @examples
#' if (interactive()) {
#'   library(shiny)
#'   library(dplyr)
#'
#'   ui <- fluidPage(
#'     crukTheme(),
#'     selectInput("cyl", "Cylinders", choices = sort(unique(mtcars$cyl))),
#'     checkboxInput("paginate", "Paginate"),
#'     crukTableOutput("default_table"),
#'     crukTableOutput("custom_table")
#'   )
#'
#'   server <- function(input, output, session) {
#'     filtered_data <- reactive(filter(mtcars, cyl == input$cyl))
#'
#'     # Data only: crukTable() defaults
#'     output$default_table <- renderCrukTable(filtered_data())
#'
#'     # Call crukTable() yourself to change its arguments
#'     output$custom_table <- renderCrukTable({
#'       filtered_data() |>
#'         tibble::rownames_to_column("car") |>
#'         select(car, mpg, cyl, wt, hp) |>
#'         crukTable(filterable = FALSE, pagination = input$paginate)
#'     })
#'   }
#'
#'   shinyApp(ui, server)
#' }
renderCrukTable <- function(expr, env = parent.frame(), quoted = FALSE) {
  table_fun <- shiny::exprToFunction(expr, env, quoted)

  # renderReactable() evaluates this block inside a reactive context each time
  # the output renders, so every reactive read in expr is tracked.
  reactable::renderReactable({
    as_cruk_table(table_fun())
  })
}


# Internal helpers ------------------------------------------------------------

cruk_table_dependency <- function() {
  htmltools::htmlDependency(
    name = "crukTable",
    version = get_pkg_version(),
    src = "www",
    package = "shinyCRUK",
    stylesheet = "css/tables.css",
    all_files = TRUE
  )
}

# Turn whatever renderCrukTable()'s expression returned into a table
as_cruk_table <- function(x) {
  if (is.null(x) || inherits(x, "reactable")) {
    return(x)
  }

  if (is.data.frame(x) || is.matrix(x)) {
    return(crukTable(x))
  }

  stop(
    "`renderCrukTable()` expects `crukTable()`, a data frame or a matrix, ",
    "not an object of class <", class(x)[1], ">",
    call. = FALSE
  )
}

check_flag <- function(x, arg) {
  if (!is.logical(x) || length(x) != 1 || is.na(x)) {
    stop("`", arg, "` must be TRUE or FALSE", call. = FALSE)
  }
  invisible(x)
}
