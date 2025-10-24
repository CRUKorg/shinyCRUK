#' Create a CRUK-branded action button
#'
#' This function creates a Cancer Research UK branded action button for Shiny
#' applications. It wraps \code{shiny::actionButton()} with CRUK-specific styling
#' and optional Google Material Symbols icons.
#'
#' @param inputId The \code{input} slot that will be used to access the value.
#' @param text The button label text to display.
#' @param type Character string specifying button style. Either \code{"primary"}
#'   (default, magenta background) or \code{"secondary"} (white background with
#'   magenta border).
#' @param icon Optional character string specifying which Google Material Symbol
#'   to display. Must be one of: \code{"upload_file"}, \code{"download"},
#'   \code{"check_circle"}, \code{"open_in_new"}, \code{"content_copy"},
#'   \code{"mail"}, or \code{"share"}. Default is \code{NULL} (no icon).
#' @param ... Additional arguments passed to \code{shiny::actionButton()}.
#'
#' @return A Shiny action button tag with CRUK branding and attached CSS/icon
#'   dependencies.
#'
#' @export
#'
#' @examples
#' if (interactive()) {
#'   library(shiny)
#'
#'   ui <- fluidPage(
#'     crukButton("btn1", "Primary Button", type = "primary"),
#'     crukButton("btn2", "Download", type = "secondary", icon = "download"),
#'     crukButton("btn3", "Share", icon = "share")
#'   )
#'
#'   server <- function(input, output, session) {
#'     observeEvent(input$btn1, {
#'       print("Button clicked!")
#'     })
#'   }
#'
#'   shinyApp(ui, server)
#' }
crukButton <- function(inputId, text, type = "primary", icon = NULL, ...) {
  # Validation checks
  if (!type %in% c("primary", "secondary")) {
    stop("type must be primary or secondary")
  }
  if (!is.null(icon) && !icon %in% c(
    "upload_file", "download", "check_circle", "open_in_new", "content_copy", "mail", "share"
  )) {
    stop("Available icons are: upload_file, download, check_circle, open_in_new, content_copy, mail, or share.")
  }
  if (text == "") {
    stop("You need to give your button a label via the text argument!")
  }

  # Dependencies
  css <- htmltools::htmlDependency(
    name = "crukButton",
    version = utils::packageVersion("shinyCRUK"),
    src = "www",
    package = "shinyCRUK",
    stylesheet = "css/crukButton.css",
    all_files = TRUE
  )
  googleSymbols <- htmltools::htmlDependency(
    name = "google-material-symbols",
    version = "1.0.0",
    src = c(href = "https://fonts.googleapis.com"),
    stylesheet = "css2?family=Material+Symbols+Sharp"
  )

  # Create button first
  button <- shiny::actionButton(inputId = inputId, label = text, class = c(paste0("cruk-btn-", type), "cruk-btn"), ...)

  # If icon specified, add it to the button
  if (!is.null(icon)) {
    icon_html <- htmltools::tags$span(class = c("material-symbols-sharp", paste0("cruk-btn-icon-", type)), icon)
    button$children[[1]] <- htmltools::tagList(text, " ", icon_html)
  }

  # Attach the Google Symbols dependency and return
  htmltools::attachDependencies(button, list(googleSymbols, css))
}
