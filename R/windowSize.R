#' Window Size Tracking Module - UI
#'
#' @description
#' Creates JavaScript handlers to track browser window dimensions in a Shiny app.
#' This function adds client-side code that sends window size information to the
#' server on initial load and whenever the window is resized.
#'
#' @param id Character string. Module namespace ID used to uniquely identify this
#'   instance of the module. Must match the `id` used in [window_size_server()].
#'
#' @return A `shiny.tag` object containing JavaScript code to be included in the UI.
#'
#' @details
#' The JavaScript code:
#' * Sends initial window dimensions when the Shiny connection is established
#' * Listens for window resize events and updates dimensions
#' * Includes a random nonce on resize to ensure Shiny detects changes even when
#'   resizing back to previous dimensions
#'
#' @seealso [window_size_server()] for the server-side component
#'
#' @examples
#' \dontrun{
#' library(shiny)
#'
#' ui <- fluidPage(
#'   window_size_ui("win_tracker"),
#'   verbatimTextOutput("size_display")
#' )
#'
#' server <- function(input, output, session) {
#'   win_size <- window_size_server("win_tracker", verbose = TRUE)
#'
#'   output$size_display <- renderText({
#'     ws <- win_size()
#'     req(ws)
#'     paste0("Width: ", ws$width, "px\nHeight: ", ws$height, "px")
#'   })
#' }
#'
#' shinyApp(ui, server)
#' }
#'
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

#' Window Size Tracking Module - Server
#'
#' @description
#' Server-side component for tracking browser window dimensions. Returns a
#' debounced reactive expression containing the current window width and height.
#'
#' @param id Character string. Module namespace ID that must match the `id` used
#'   in [window_size_ui()].
#' @param debounce_ms Numeric. Debounce delay in milliseconds (default: 200).
#'   This prevents excessive reactive updates during rapid window resizing.
#'   Increase for slower updates, decrease for more responsive tracking.
#' @param verbose Logical. If `TRUE`, prints window size changes to the R console
#'   with timestamps (default: `FALSE`). Useful for debugging.
#'
#' @return A debounced reactive expression that returns a list with two elements:
#'   * `width` - Numeric. Window inner width in pixels
#'   * `height` - Numeric. Window inner height in pixels
#'
#' @details
#' The returned reactive will be `NULL` or contain `NA` values until the first
#' window size update is received from the client. Always use [shiny::req()] or
#' similar validation before accessing the values.
#'
#' The debouncing helps performance by limiting how frequently your app responds
#' to window resize events. A 200ms delay is generally imperceptible to users
#' while significantly reducing server load during resizing.
#'
#' @seealso
#' * [window_size_ui()] for the UI component
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
#'
#'   # Conditionally show/hide UI elements
#'   observe({
#'     ws <- win_size()
#'     req(ws)
#'
#'     if (ws$width < 768) {
#'       # Mobile layout
#'     } else {
#'       # Desktop layout
#'     }
#'   })
#' }
#'
#' shinyApp(ui, server)
#' }
#'
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
