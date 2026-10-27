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
#'   \code{reactable::colDef()}. A column that sets any of \code{width},
#'   \code{maxWidth} or \code{minWidth} keeps exactly that sizing; see
#'   \code{fitHeaders}.
#' @param sortable Logical. Whether columns can be sorted by clicking the
#'   column headers. Default is \code{TRUE}.
#' @param filterable Logical. Whether filter inputs are displayed for columns.
#'   Default is \code{FALSE}.
#' @param selection Row selection mode: \code{"multiple"}, \code{"single"}, or
#'   \code{NULL} for no selection. Default is \code{"multiple"}. Rows are
#'   selected by clicking them; reactable's checkbox column is not shown (and
#'   takes up no space). To show it anyway, supply your own \code{.selection}
#'   column definition in \code{columns}.
#' @param onClick Action to perform when a row is clicked. Defaults to
#'   \code{"select"} when \code{selection} is set, otherwise \code{NULL}.
#' @param highlight Logical. Whether rows are highlighted on hover.
#'   Default is \code{TRUE}.
#' @param pagination Logical. Whether pagination is enabled. Default is
#'   \code{FALSE}, unless \code{defaultPageSize} is supplied and
#'   \code{pagination} is not, in which case pagination is switched on.
#' @param defaultPageSize Number of rows per page. If \code{NULL}, all rows are
#'   shown when pagination is off and 10 when it is on. Supplying a page size
#'   switches pagination on unless you also set \code{pagination = FALSE}, in
#'   which case the page size is ignored (with a warning).
#' @param class Optional extra CSS class(es) for the table.
#' @param WindowSize Optional. The current window size, i.e. the value of the
#'   reactive returned by [window_size_server()]: pass \code{WindowSize()}, not
#'   \code{WindowSize}. Any list with a numeric \code{width} element works.
#'   When the window is narrower than \code{mobileBreakpoint}, a compact
#'   version of the table is drawn: smaller fonts and cell padding, and a
#'   smaller default minimum column width so that the table is about
#'   \code{mobileMaxWidth} pixels wide or less. If \code{NULL} (the default),
#'   or the width is not yet known, the full-size table is drawn. Call
#'   \code{crukTable()} inside [renderCrukTable()] so the table redraws when the
#'   window is resized. Note that a redraw resets sorting, filtering and
#'   selection. Any \code{width}, \code{minWidth} or \code{maxWidth} you set in
#'   \code{columns} takes precedence over the compact defaults. Passing
#'   \code{WindowSize = win_size()} inside [renderCrukTable()] redraws the table
#'   on every window size update, which resets the current page. Prefer
#'   \code{mobile = window_is_narrow(win_size)} (see below) in Shiny apps.
#' @param mobileBreakpoint Window width in pixels below which the compact table
#'   is used. Default is 900 (Bootstrap's \code{md} breakpoint). Only used with
#'   \code{WindowSize}; with \code{mobile}, the breakpoint is whatever you gave
#'   [window_is_narrow()].
#' @param mobileMaxWidth Target maximum table width in pixels for the compact
#'   table. Used to work out the default minimum column width (the table
#'   width is not capped if there are too many columns to fit; it then scrolls
#'   horizontally inside its container). Default is 375. With
#'   \code{fitHeaders = TRUE} a column is never made narrower than its longest
#'   header word, so this is a target rather than a guarantee: tables with long
#'   headers or many columns will scroll horizontally on small screens rather
#'   than shrink the text or split words.
#' @param fitHeaders Logical. If \code{TRUE} (the default), each column's
#'   minimum width is raised, if necessary, so that the longest word in its
#'   header fits on one line instead of being split mid-word. The width is
#'   estimated from the number of characters (not measured in the browser), and
#'   capped so that one very long word cannot make a column huge. Columns are
#'   left alone if their \code{colDef()} sets \code{width}, \code{maxWidth} or
#'   \code{minWidth}, or sets \code{show = FALSE} or a custom \code{header}.
#'   Set to \code{FALSE} for reactable's own sizing.
#' @param mobile Optional. \code{TRUE} or \code{FALSE}: draw the compact
#'   version of the table (see \code{WindowSize}) or the full-size one. In a
#'   Shiny app, pass the reactive from [window_is_narrow()] called, i.e.
#'   \code{mobile = is_narrow()}. Because [window_is_narrow()] only changes
#'   when the window crosses its breakpoint, the table is redrawn only then,
#'   rather than on every resize, so the current page, sort order and selection
#'   are kept. If supplied, \code{mobile} takes precedence over
#'   \code{WindowSize}. If \code{NULL} (the default), \code{WindowSize} is used.
#' @param ... Additional arguments passed to \code{reactable::reactable()}.
#'
#' @return A \code{reactable} htmlwidget with the CRUK table stylesheet
#'   attached.
#'
#' @seealso [crukTableOutput()], [renderCrukTable()], [window_is_narrow()]
#' @export
#'
#' @examples
#' crukTable(head(mtcars), filterable = FALSE, selection = NULL)
#'
#' # Force the compact version
#' crukTable(head(mtcars), mobile = TRUE)
#'
#' \dontrun{
#' # In a Shiny app: redraw only when the window crosses the breakpoint
#' server <- function(input, output, session) {
#'   win_size  <- window_size_server("window_tracker")
#'   is_narrow <- window_is_narrow(win_size, breakpoint = 900)
#'
#'   output$table <- renderCrukTable(
#'     crukTable(mtcars, pagination = TRUE, mobile = is_narrow())
#'   )
#' }
#' }
crukTable <- function(
    data,
    columns = NULL,
    sortable = TRUE,
    filterable = FALSE,
    selection = "multiple",
    onClick = if (!is.null(selection)) "select" else NULL,
    highlight = TRUE,
    pagination = FALSE,
    defaultPageSize = NULL,
    class = NULL,
    WindowSize = NULL,
    mobileBreakpoint = 900,
    mobileMaxWidth = 375,
    mobile = NULL,
    fitHeaders = TRUE,
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
  check_flag(fitHeaders, "fitHeaders")

  if (!is.null(selection) &&
      !(is.character(selection) && length(selection) == 1 &&
        selection %in% c("single", "multiple"))) {
    stop("`selection` must be \"single\", \"multiple\", or NULL", call. = FALSE)
  }

  if (is.function(WindowSize)) {
    stop(
      "`WindowSize` must be the window size, not the reactive: use ",
      "`WindowSize = win_size()` rather than `WindowSize = win_size`",
      call. = FALSE
    )
  }

  if (!is.null(WindowSize) && !is.list(WindowSize)) {
    stop(
      "`WindowSize` must be NULL or a list with a `width` element, such as ",
      "the value of the reactive returned by `window_size_server()`",
      call. = FALSE
    )
  }

  if (!is.null(mobile)) {
    check_flag(mobile, "mobile")
  }

  # An explicit `mobile` wins. Otherwise fall back to WindowSize, where anything
  # unexpected (NULL, NA, no width yet) counts as "not mobile".
  is_mobile <- if (!is.null(mobile)) {
    mobile
  } else {
    cruk_is_mobile(WindowSize, mobileBreakpoint)
  }

  # A page size only means something with pagination on. If the caller gave a
  # page size but left `pagination` alone, they clearly want pages; if they set
  # `pagination = FALSE` as well, say that the page size is being ignored.
  if (!is.null(defaultPageSize)) {
    if (!is.numeric(defaultPageSize) || length(defaultPageSize) != 1 ||
        is.na(defaultPageSize) || defaultPageSize < 1) {
      stop("`defaultPageSize` must be a single number of at least 1", call. = FALSE)
    }

    if (missing(pagination)) {
      pagination <- TRUE
    } else if (!pagination) {
      warning(
        "`defaultPageSize` is ignored when `pagination = FALSE`",
        call. = FALSE
      )
      defaultPageSize <- NULL
    }
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
      if (is_mobile) "cruk-table--compact",
      class
    ),
    collapse = " "
  )

  # Let columns grow so the longest header word fits on one line. This runs
  # before cruk_columns() so that only the caller's columns are considered.
  if (fitHeaders) {
    columns <- cruk_fit_headers(
      columns,
      data,
      sortable = sortable,
      mobile = is_mobile,
      floor_px = cruk_min_width_floor(data, is_mobile, mobileMaxWidth)
    )
  }

  widget <- reactable::reactable(
    data,
    columns = cruk_columns(columns, selection),
    sortable = sortable,
    filterable = filterable,
    selection = selection,
    onClick = onClick,
    highlight = highlight,
    borderless = TRUE,
    pagination = pagination,
    defaultPageSize = defaultPageSize,
    defaultColDef = cruk_default_col_def(data, is_mobile, mobileMaxWidth),
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

# TRUE if the window is known to be narrower than `breakpoint`. NULL, NA or a
# missing width count as "not mobile", so the full-size table is the fallback.
cruk_is_mobile <- function(WindowSize, breakpoint) {
  width <- WindowSize$width
  is.numeric(width) && length(width) == 1 && !is.na(width) && width < breakpoint
}

# Rows are selected by clicking, so reactable's checkbox column is never wanted.
# Hiding it with CSS is not enough: reactable still lays it out, so it adds 45px
# to the table's minimum width and leaves an empty 45px cell in the footer
# (summary) row. show = FALSE removes it from the table altogether. A
# `.selection` definition supplied by the caller is left alone.
cruk_columns <- function(columns, selection) {
  if (is.null(selection) || ".selection" %in% names(columns)) {
    return(columns)
  }

  c(columns, list(.selection = reactable::colDef(show = FALSE)))
}

# reactable's default minWidth is 100px. On mobile, share `max_width` between
# the columns, but never go below 40px or above 100px (the reactable default).
cruk_min_width_floor <- function(data, mobile, max_width) {
  if (!mobile) {
    return(100)
  }

  n_col <- max(ncol(data), 1L)
  max(40, min(100, floor(max_width / n_col)))
}

cruk_default_col_def <- function(data, mobile, max_width) {
  if (!mobile) {
    return(reactable::colDef(
      align = "left",
      headerStyle = list(textAlign = "left")
    ))
  }

  reactable::colDef(
    align = "left",
    headerStyle = list(textAlign = "left"),
    minWidth = cruk_min_width_floor(data, mobile, max_width)
  )
}

# Header fitting ---------------------------------------------------------------
#
# reactable sizes columns in pixels (colDef(minWidth =)), but the header text is
# sized by the browser, and reactable's CSS sets `word-wrap: break-word` on
# cells, so a column narrower than its longest header word splits that word
# mid-word. R cannot measure text in the user's browser, so the width needed is
# *estimated* from the character count, using the constants below.
#
# KEEP IN SYNC WITH inst/www/css/tables.css:
#   font_rem     .cruk-table .rt-thead .rt-th font-size (the same in compact mode)
#   pad_px       left/right padding of .rt-th-inner: reactable's default 8px, and
#                6px in .cruk-table--compact
#   rem_px       1rem = 16px, as set in crukTheme.css. Only true when
#                crukTheme() is on the page; otherwise the browser default
#                (normally also 16px) applies.
#   em_per_char  average advance of a MIXED-CASE Poppins Semibold letter plus the
#                0.02em letter-spacing, as a fraction of the font size. Headers
#                are not upper-cased by default and capitals are wider than
#                lower-case letters
#   sort_px      room for the sort arrow that reactable adds beside the text of
#                the SORTED column. Reserved on every sortable column so sorting
#                does not make a tight header split. Read by eye from a
#                screenshot at about 12-13px (arrow plus gap); the 6px slack
#                covers the difference. Confirm with test-crukTable-headers.R.
cruk_header_metrics <- list(
  rem_px      = 16,
  font_rem    = 0.6875,
  em_per_char = 0.68,
  pad_px      = c(full = 8, compact = 6),
  sort_px     = 12,
  slack_px    = 6,    # sub-pixel rounding and the 3px row-header border
  max_px      = 220   # one very long word must not make a column huge
)

# Number of characters in the longest unbreakable word of a header. Browsers
# can break a line at a space or after a hyphen, so split on both.
cruk_longest_word_chars <- function(label) {
  label |>
    as.character() |>
    stringr::str_replace_all("-", "- ") |>
    stringr::str_split("\\s+") |>
    unlist() |>
    stringr::str_length() |>
    max(0L, na.rm = TRUE)
}

# TRUE if the caller has sized this column with colDef(), in which case we do
# not touch it.
cruk_is_user_sized <- function(col) {
  !is.null(col[["width"]]) ||
    !is.null(col[["minWidth"]]) ||
    !is.null(col[["maxWidth"]])
}

# Estimated pixel width needed for the longest header word, or NA if this
# column should be left alone.
cruk_header_width <- function(col, name, sortable, mobile) {
  if (cruk_is_user_sized(col) ||
      !is.null(col[["header"]]) ||        # custom header: text unknown
      identical(col[["show"]], FALSE)) {
    return(NA_real_)
  }

  m <- cruk_header_metrics
  label <- if (is.null(col[["name"]])) name else col[["name"]]
  col_sortable <- if (is.null(col[["sortable"]])) sortable else col[["sortable"]]
  pad <- if (mobile) m$pad_px[["compact"]] else m$pad_px[["full"]]

  ceiling(
    cruk_longest_word_chars(label) * m$em_per_char * m$font_rem * m$rem_px +
      2 * pad +
      (if (isTRUE(col_sortable)) m$sort_px else 0) +
      m$slack_px
  )
}

# Raise one column's minWidth if its header needs more room than `floor_px`.
# Never lowers a width, never touches a user-sized column. `col` is NULL when
# the caller did not define the column; the result is then NULL (nothing to
# change) or a new colDef().
cruk_fit_header <- function(col, name, sortable, mobile, floor_px) {
  needed <- cruk_header_width(col, name, sortable, mobile)
  if (is.na(needed) || needed <= floor_px) {
    return(col)
  }

  min_width <- max(floor_px, min(needed, cruk_header_metrics$max_px))

  if (is.null(col)) {
    return(reactable::colDef(minWidth = min_width))
  }

  col[["minWidth"]] <- min_width
  col
}

# Apply cruk_fit_header() to every data column. Entries in `columns` that are
# not data columns (e.g. `.selection`) pass through unchanged.
cruk_fit_headers <- function(columns, data, sortable, mobile, floor_px) {
  col_names <- colnames(data)
  if (is.null(col_names)) {
    return(columns)
  }

  fitted <- col_names |>
    rlang::set_names() |>
    purrr::map(\(nm) cruk_fit_header(columns[[nm]], nm, sortable, mobile, floor_px)) |>
    purrr::compact()

  c(fitted, columns[setdiff(names(columns), col_names)])
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
