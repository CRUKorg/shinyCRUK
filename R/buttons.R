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
    stylesheet = "css/buttons.css",
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


#' Create a CRUK-branded radio button group
#'
#' This function creates a Cancer Research UK branded radio button selector.
#' It wraps \code{shinyWidgets::radioGroupButtons()} with CRUK-specific
#' styling to match the helix design system.
#'
#' @param inputId The unique identifier for the radio button.
#' @param label Display label for the radio button group.
#' @param choices List of values to select from. If elements of the list are
#'   named, then the names rather than the values are displayed to the user.
#'   Can be a vector or a named list.
#' @param width The width of the input group. Can be specified in pixels
#'   (e.g., \code{"400px"}), percentage (e.g., \code{"100\%"}), or \code{NULL}
#'   (default) for automatic width.
#' @param justified Logical. If \code{TRUE} (default), buttons are stretched
#'   to fill the width of the container evenly. If \code{FALSE}, buttons are
#'   sized to their content.
#' @param class Additional CSS classes to apply to the radio button container.
#'   Optional parameter for custom styling.
#' @param ... Additional arguments passed to
#'   \code{shinyWidgets::radioGroupButtons()}.
#'
#' @return A Shiny radio button group tag with CRUK branding and attached CSS
#'   dependencies.
#'
#' @details
#' The function automatically applies CRUK brand styling through the
#' \code{css/buttons.css} stylesheet.
#'
#' @section Dependencies:
#' This function requires the \code{shinyWidgets} package to be installed and
#' loaded, as it wraps \code{shinyWidgets::radioGroupButtons()}.
#'
#' @seealso
#' \code{\link{crukButton}} for creating CRUK-branded action buttons.
#' \code{\link[shinyWidgets]{radioGroupButtons}} for the underlying widget.
#'
#' @export
#'
#' @examples
#' if (interactive()) {
#'   library(shiny)
#'   library(shinyWidgets)
#'
#'   ui <- fluidPage(
#'     # Basic usage
#'     crukRadioButton(
#'       inputId = "filter1",
#'       label = "Select a time period:",
#'       choices = c("Daily", "Weekly", "Monthly", "Yearly")
#'     ),
#'
#'     # With named choices
#'     crukRadioButton(
#'       inputId = "filter2",
#'       label = "Choose data type:",
#'       choices = list(
#'         "Donations" = "don",
#'         "Volunteers" = "vol",
#'         "Events" = "evt"
#'       )
#'     ),
#'
#'     # Non-justified buttons with custom width
#'     crukRadioButton(
#'       inputId = "filter3",
#'       label = "Select option:",
#'       choices = c("Yes", "No", "Maybe"),
#'       width = "300px",
#'       justified = FALSE
#'     ),
#'
#'     # Without label
#'     crukRadioButton(
#'       inputId = "filter4",
#'       label = NULL,
#'       choices = c("Option A", "Option B", "Option C")
#'     )
#'   )
#'
#'   server <- function(input, output, session) {
#'     # Access the selected value
#'     observeEvent(input$filter1, {
#'       print(paste("Selected:", input$filter1))
#'     })
#'   }
#'
#'   shinyApp(ui, server)
#' }
crukRadioButton <- function(inputId, label, choices, width = NULL, justified = TRUE, class = "", ...) {
  # Dependencies
  css <- htmltools::htmlDependency(
    name = "crukRadioButton",
    version = utils::packageVersion("shinyCRUK"),
    src = "www",
    package = "shinyCRUK",
    stylesheet = "css/buttons.css",
    all_files = TRUE
  )

  radioButton <- htmltools::div(
    class = c("cruk-radio-btn", class),
    shinyWidgets::radioGroupButtons(
      inputId = inputId,
      label = label,
      choices = choices,
      width = width,
      justified = TRUE,
      ...
    )
  )

  htmltools::attachDependencies(radioButton, css)
}
