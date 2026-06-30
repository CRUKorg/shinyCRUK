#' CRUK Date Picker
#'
#' Creates a date picker with CRUK styling. This is a wrapper for \code{shinyWidgets::airDatePickerInput}
#' with additional CRUK-specific styling applied via CSS dependencies.
#'
#' @param inputId The inputId to access the selected value
#' @param label Character. Text to display above the label. Use NULL for no label.
#' @param start The minimum date to display. Either a Date object or a string in the form \code{yyyy-mm-dd}.
#' @param end The minimum date to display. Either a Date object or a string in the form \code{yyyy-mm-dd}.
#' @param view Starting view, one of 'days', 'months' (default) or 'years'.
#' @param minView Minimal view, one of 'days', 'months' or 'years'. Defaults to equal to view.
#' @param value Sets the default selected date. Either a Date object or a string in the form \code{yyyy-mm-dd}. Defaults to \code{Sys.Date()}.
#' @param class Additional CSS classes to apply to wrapper div.
#' @param ... Additional arguments passed to \code{shinyWidgets::airDatePickerInput}
#'
#' @returns An HTML div element containing a  styled airDatePickerInput with attached CSS dependencies.
#' @export
#'
#' @examples
#' \dontrun{
#' crukDatePicker(
#'   inputId = "dateInput",
#'   label = "Select a date:",
#'   start = min(data$Date),
#'   end = max(date$Date),
#'   view = "months",
#'   minView = "months"
#' )
#'
#' }
crukDatePicker <- function(inputId, label, start, end, view = "months", value=Sys.Date(), minView = NULL, startView = NULL, class = "", ...) {
  shiny::addResourcePath(
    prefix = "shinyCRUK",
    directoryPath = system.file("www", package = "shinyCRUK")
  )

  css <- htmltools::htmlDependency(
    name = "crukDatePicker",
    version = get_pkg_version(),
    src = "www",
    package = "shinyCRUK",
    stylesheet = "css/crukDatePicker.css",
    all_files = TRUE
  )

  # Make minView match view by default
  if (is.null(minView)) {
    minView <- view
  }

  if (is.null(startView)) {
    startView <- value
  }

  datePicker <- htmltools::div(
    class = c("crukDatePicker", class),
    shinyWidgets::airDatepickerInput(
      inputId = inputId,
      label = label,
      view = view,
      minView = minView,
      minDate = start,
      maxDate = end,
      value = value,
      startView = startView,
      dateFormat = ifelse(view == "months", "MMMM yyyy", "d MM yyyy"),
      ...
    )
  )

  htmltools::attachDependencies(datePicker, css)

}
