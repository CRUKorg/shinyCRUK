#' Create a CRUK-branded table
#'
#' This function creates a Cancer Research UK branded table for Shiny
#' applications. It wraps \code{reactable::reactable()} with CRUK-specific
#' styling and uses the FiveThirtyEight reactable theme.
#'
#' @param data A data frame or matrix to display.
#' @param columns Optional named list of column definitions created using
#'   \code{reactable::colDef()}.
#' @param sortable Logical. Whether columns can be sorted by clicking the
#'   column headers. Default is \code{TRUE}.
#' @param filterable Logical. Whether filter inputs are displayed for columns.
#'   Default is \code{TRUE}.
#' @param selection Character string specifying the row selection mode.
#'   Either \code{"multiple"}, \code{"single"}, or \code{NULL}.
#'   Default is \code{"multiple"}.
#' @param onClick Action to perform when a row is clicked.
#'   Default is \code{"select"}.
#' @param highlight Logical. Whether rows should be highlighted on hover.
#'   Default is \code{TRUE}.
#' @param pagination Logical. Whether pagination should be enabled.
#'   Default is \code{FALSE}.
#' @param defaultPageSize Number of rows to display per page. If \code{NULL}
#'   and pagination is disabled, all rows are displayed.
#' @param ... Additional arguments passed to \code{reactable::reactable()}.
#'
#' @return A Shiny reactable table with CRUK branding and attached CSS
#'   dependencies.
#'
#' @export
#'
#' @examples
#' if (interactive()) {
#'   library(shiny)
#'
#'   ui <- fluidPage(
#'     reactable::reactableOutput("table")
#'   )
#'
#'   server <- function(input, output, session) {
#'     output$table <- reactable::renderReactable({
#'       crukTable(
#'         mtcars,
#'         sortable = TRUE,
#'         filterable = TRUE
#'       )
#'     })
#'   }
#'
#'   shinyApp(ui, server)
#' }
crukTable <- function(
    data,
    columns = NULL,
    sortable = TRUE,
    filterable = TRUE,
    selection = "multiple",
    onClick = "select",
    highlight = TRUE,
    pagination = FALSE,
    defaultPageSize = NULL,
    ...
) {

  # Validation checks
  if (!is.data.frame(data) && !is.matrix(data)) {
    stop("data must be a data frame or matrix")
  }

  if (!is.logical(sortable) || length(sortable) != 1) {
    stop("sortable must be TRUE or FALSE")
  }

  if (!is.logical(filterable) || length(filterable) != 1) {
    stop("filterable must be TRUE or FALSE")
  }

  if (!is.null(selection) &&
      !selection %in% c("single", "multiple")) {
    stop("selection must be 'single', 'multiple', or NULL")
  }

  # Dependencies
  css <- htmltools::htmlDependency(
    name = "crukTable",
    version = get_pkg_version(),
    src = "www",
    package = "shinyCRUK",
    stylesheet = "css/tables.css",
    all_files = TRUE
  )

  # Show all rows when pagination is disabled
  if (is.null(defaultPageSize)) {
    defaultPageSize <- if (!pagination) nrow(data) else 10
  }

  # Create CRUK table
  table <- htmltools::div(
    class = "cruk-table",
    reactable::reactable(
      data,

      style = list(
        fontFamily = "Poppins, Work Sans, sans-serif",
        fontSize = "0.875rem"
      ),

      theme = reactablefmtr::fivethirtyeight(
        centered = TRUE
      ),

      highlight = highlight,
      selection = selection,
      onClick = onClick,
      borderless = TRUE,

      pagination = pagination,
      defaultPageSize = defaultPageSize,

      sortable = sortable,
      filterable = filterable,

      defaultColDef = reactable::colDef(
        align = "left",
        headerStyle = list(
          textAlign = "left"
        )
      ),

      columns = columns,

      ...
    )
  )

  htmltools::attachDependencies(table, css)
}
