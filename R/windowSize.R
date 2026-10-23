#' Window Size Tracking Module
#'
#' @description
#' Track browser window dimensions in a Shiny app using a Shiny module.
#' This module provides both UI and server components that work together to
#' monitor window size changes.
#'
#' @param id Character string. Module namespace ID used to uniquely identify this
#'   instance of the module. Must be the same in both UI and server functions.
#'
#' @section UI Function:
#' `window_size_ui(id)` creates JavaScript handlers to track browser window
#' dimensions. Adds client-side code that sends window size information to the
#' server on initial load and whenever the window is resized.
#'
#' @section Server Function:
#' `window_size_server(id, debounce_ms = 200, verbose = FALSE)` is the server-side
#' component that returns a debounced reactive expression containing the current
#' window width and height.
#'
#' @param debounce_ms Numeric. Debounce delay in milliseconds (default: 200).
#'   This prevents excessive reactive updates during rapid window resizing.
#' @param verbose Logical. If `TRUE`, prints window size changes to the R console
#'   with timestamps (default: `FALSE`). Useful for debugging.
#'
#' @return
#' **window_size_ui**: A `shiny.tag` object containing JavaScript code.
#'
#' **window_size_server**: A debounced reactive expression returning a list with:
#'   * `width` - Numeric. Window inner width in pixels
#'   * `height` - Numeric. Window inner height in pixels
#'
#' @details
#' The JavaScript code sends initial window dimensions when the Shiny connection
#' is established and listens for window resize events. A random nonce is included
#' on resize to ensure Shiny detects changes even when resizing back to previous
#' dimensions.
#'
#' The returned reactive will be `NULL` or contain `NA` values until the first
#' window size update is received. Always use [shiny::req()] or similar validation
#' before accessing the values.
#'
#' The debouncing helps performance by limiting how frequently your app responds
#' to window resize events. A 200ms delay is generally imperceptible to users
#' while significantly reducing server load.
#'
#' @seealso
#' * [shiny::debounce()] for information about debouncing
#' * [shiny::req()] for handling NULL/NA values
#'
#' @examples
#' \dontrun{
#' library(shiny)
#' library(ggplot2)
#'
#' ui <- fluidPage(
#'   window_size_ui("win_tracker"),
#'   verbatimTextOutput("size_display"),
#'   plotOutput("responsive_plot")
#' )
#'
#' server <- function(input, output, session) {
#'   # Track window size with verbose logging
#'   win_size <- window_size_server("win_tracker",
#'     debounce_ms = 300,
#'     verbose = TRUE
#'   )
#'
#'   # Display current size
#'   output$size_display <- renderText({
#'     ws <- win_size()
#'     req(ws)
#'     paste0("Width: ", ws$width, "px\nHeight: ", ws$height, "px")
#'   })
#'
#'   # Create responsive plot based on window size
#'   output$responsive_plot <- renderPlot({
#'     ws <- win_size()
#'     req(ws)
#'
#'     # Adjust plot based on window width
#'     point_size <- if (ws$width < 768) 2 else 3
#'
#'     ggplot(mtcars, aes(wt, mpg)) +
#'       geom_point(size = point_size) +
#'       theme_minimal()
#'   })
#' }
#'
#' shinyApp(ui, server)
#' }
#'
#' @name window_size
NULL

#' @rdname window_size
#' @export
window_size_ui <- function(id) {
  ns <- shiny::NS(id)

  htmltools::tags$script(htmltools::HTML(sprintf("
    $(document).on('shiny:connected', function(e) {
      Shiny.setInputValue('%s', {
        width: window.innerWidth,
        height: window.innerHeight
      });
    });
    $(window).resize(function(e) {
      Shiny.setInputValue('%s', {
        width: window.innerWidth,
        height: window.innerHeight,
        nonce: Math.random()
      });
    });
  ", ns("window_size"), ns("window_size"))))
}

#' @rdname window_size
#' @export
window_size_server <- function(id, debounce_ms = 200, verbose = FALSE) {
  shiny::moduleServer(id, function(input, output, session) {
    # Initialize window size
    initial_window_size <- shiny::reactiveVal(list(width = NA, height = NA))

    # Debounced window size
    window_size <- shiny::debounce(shiny::reactive(input$window_size), debounce_ms)

    # Optional logging
    if (verbose) {
      shiny::observeEvent(window_size(), {
        shiny::req(window_size())
        cat(paste0(
          "\nWindow size changed at ", Sys.time(),
          "\nwidth: ", window_size()$width,
          "\nheight: ", window_size()$height, "\n"
        ))
      })
    }

    # Return the reactive
    return(window_size)
  })
}

#' Is the browser window narrower than a breakpoint?
#'
#' Turns the reactive returned by [window_size_server()] into a single
#' \code{TRUE}/\code{FALSE} that only changes when the window crosses
#' \code{breakpoint}. Use it where a render only needs to know "narrow or
#' wide", such as \code{crukTable(mobile = is_narrow())}, instead of reading the
#' raw width.
#'
#' Reading \code{win_size()} inside a render function makes that output re-run
#' on every window size update. Reading the result of \code{window_is_narrow()}
#' instead only re-runs it when the value flips, so a table keeps its current
#' page, sort order and selection while the window is resized within one band.
#'
#' @param win_size The reactive returned by [window_size_server()]. Pass the
#'   reactive itself (\code{win_size}), not its value (\code{win_size()}).
#' @param breakpoint Single number. Window width in pixels below which the window
#'   counts as narrow. Default is 900 (Bootstrap's \code{md} breakpoint), which
#'   matches the default \code{mobileBreakpoint} of [crukTable()].
#'
#' @details
#' Call this once, in the server function (or module server), because it creates
#' an observer. It does not change [window_size_server()]: that still returns
#' the full width and height, so you can use both side by side.
#'
#' The value is \code{FALSE} until the browser has reported a width, so the
#' first render is the wide version. On a narrow window it flips to \code{TRUE}
#' shortly afterwards (after the \code{debounce_ms} of
#' [window_size_server()]) and the output re-runs once.
#'
#' It returns only two states. For plots or tables that need to scale smoothly
#' with the window, or that need the width in pixels, use \code{win_size()}.
#'
#' @return A reactive expression returning \code{TRUE} if the window width is
#'   below \code{breakpoint}, otherwise \code{FALSE}. Call it with brackets:
#'   \code{is_narrow()}.
#'
#' @seealso [window_size_server()], [crukTable()]
#'
#' @examples
#' \dontrun{
#' library(shiny)
#'
#' ui <- fluidPage(
#'   crukTheme(),
#'   window_size_ui("window_tracker"),
#'   crukTableOutput("table")
#' )
#'
#' server <- function(input, output, session) {
#'   win_size  <- window_size_server("window_tracker", debounce_ms = 300)
#'   is_narrow <- window_is_narrow(win_size, breakpoint = 900)
#'
#'   output$table <- renderCrukTable(
#'     crukTable(mtcars, pagination = TRUE, mobile = is_narrow())
#'   )
#' }
#'
#' shinyApp(ui, server)
#' }
#' @export
window_is_narrow <- function(win_size, breakpoint = 900) {
  if (!is.function(win_size)) {
    stop(
      "`win_size` must be the reactive returned by `window_size_server()`, ",
      "not its value: use `window_is_narrow(win_size)` rather than ",
      "`window_is_narrow(win_size())`",
      call. = FALSE
    )
  }

  if (!is.numeric(breakpoint) || length(breakpoint) != 1 || is.na(breakpoint)) {
    stop("`breakpoint` must be a single number", call. = FALSE)
  }

  # A reactiveVal does not invalidate its dependents when it is set to the value
  # it already holds. A plain reactive() would, which is what made the table
  # redraw on every window size update.
  narrow <- shiny::reactiveVal(FALSE)

  # observeEvent() skips NULL by default, so before the browser has reported a
  # width the value stays FALSE. Unknown or NA widths also count as "not narrow".
  shiny::observeEvent(win_size(), {
    width <- win_size()$width
    narrow(
      is.numeric(width) && length(width) == 1 && !is.na(width) && width < breakpoint
    )
  })

  # Read-only wrapper so callers cannot set the value
  shiny::reactive(narrow())
}
