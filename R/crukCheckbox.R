#' CRUK-styled checkbox
#'
#' A wrapper around \code{shinyWidgets::prettyCheckbox()} with CRUK styling:
#' a black outline when unchecked, and a pink fill with a white tick when checked.
#'
#' @param inputId Character string. The input id; read it in the server with \code{input$<inputId>}.
#' @param label Character string. The label shown next to the checkbox.
#' @param value Logical. Initial state. Defaults to \code{FALSE}.
#' @param inline Logical. Passed to \code{shinyWidgets::prettyCheckbox()}.
#' @param width Character string. Passed to \code{shinyWidgets::prettyCheckbox()}.
#' @param alignWithInput Logical. If \code{TRUE}, adds a top offset on wider screens
#'   so the checkbox lines up with an input that has a label above it
#'   (e.g. \code{crukSelectInput()}) when both are in the same row. The offset is removed
#'   when the row stacks.
#'
#' @section Label length:
#' Labels do not wrap. \code{shinyWidgets::prettyCheckbox()} keeps the checkbox
#' and its label on a single line, so a long label will run past the edge of its
#' column or container rather than breaking onto a second line. Keep labels short,
#' ideally a few words. If you need to explain the option in more detail, put that
#' text in a separate paragraph next to the checkbox, or use \code{crukTooltip()}.
#'
#' @return A shiny tag.
#' @export
#'
#' @examples
#' \dontrun{
#' crukCheckbox("exclude_unknown", "Exclude unknown stage", alignWithInput = TRUE)
#' }
crukCheckbox <- function(inputId, label, value = FALSE, inline = FALSE,
                         width = NULL, alignWithInput = TRUE) {
  if (!is.character(inputId) || length(inputId) != 1) {
    stop("`inputId` must be a single character string.", call. = FALSE)
  }

  checkbox <- shinyWidgets::prettyCheckbox(
    inputId = inputId,
    label = label,
    value = value,
    status = "primary",   # colour is overridden in crukCheckbox.css
    shape = "square",
    fill = TRUE,
    icon = shiny::icon("check"),
    inline = inline,
    width = width
  )

  wrapper <- htmltools::tags$div(
    class = paste(c("cruk-checkbox", if (alignWithInput) "cruk-checkbox-align"),
                  collapse = " "),
    checkbox
  )

  htmltools::attachDependencies(
    wrapper,
    htmltools::htmlDependency(
      name = "crukCheckbox",
      version = get_pkg_version(),
      src = "www",
      package = "shinyCRUK",
      stylesheet = "css/crukCheckbox.css",
      all_files = TRUE
    )
  )
}
