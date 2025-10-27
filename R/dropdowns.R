#' CRUK selectInput
#'
#' Creates a styled select input control with CRUK branding and custom CSS styling.
#' This is a wrapper around \code{shiny::selectInput} with additional CRUK-specific
#' styling applied via CSS dependencies.
#'
#' @param inputId The input slot that will be used to access the value.
#' @param label Display label for the control, or NULL for no label.
#' @param choices List of values to select from. If elements of the list are named,
#'   then that name rather than the value is displayed to the user.
#' @param selectize Whether to use selectize.js or not. Default is FALSE.
#' @param class Additional CSS classes to apply to the wrapper div.
#' @param ... Additional arguments passed to \code{shiny::selectInput}.
#'
#' @returns An HTML div element containing a styled select input with attached
#'   CSS dependencies.
#' @export
#'
#' @examples
#' \dontrun{
#' # In your Shiny UI
#' crukSelectInput(
#'   inputId = "biscuit_choice",
#'   label = "Select your favourite biscuit:",
#'   choices = c("Hobnob", "Digestive", "Bourbon")
#' )
#' }
crukSelectInput <- function(inputId, label, choices, selectize = FALSE, class = "", ...) {
  shiny::addResourcePath(
    prefix = "shinyCRUK",
    directoryPath = system.file("www", package = "shinyCRUK")
  )

  css <- htmltools::htmlDependency(
    name = "dropdowns",
    version = utils::packageVersion("shinyCRUK"),
    src = "www",
    package = "shinyCRUK",
    stylesheet = "css/dropdowns.css",
    all_files = TRUE
  )
  dropdown <- htmltools::div(
    class = c("crukSelectInput", class),
    shiny::selectInput(
      inputId = inputId,
      label = label,
      choices = choices,
      selectize = selectize,
      ...
    )
  )
  htmltools::attachDependencies(dropdown, css)
}

#' CRUK pickerInput
#'
#' Creates a styled picker input control with CRUK branding using the
#' \code{shinyWidgets::pickerInput} function. This provides enhanced dropdown
#' functionality including live search, multiple selection, and custom styling.
#'
#' @param inputId The input slot that will be used to access the value.
#' @param label Display label for the control, or NULL for no label.
#' @param choices List of values to select from. If elements of the list are named,
#'   then that name rather than the value is displayed to the user.
#' @param class Additional CSS classes to apply to the wrapper div.
#' @param livesearch Enable live search functionality. Default is TRUE.
#' @param placeholder Placeholder text displayed when no selection is made.
#' @param ... Additional arguments passed to \code{shinyWidgets::pickerInput}.
#' @param options A list of options for bootstrap-select. User-provided options
#'   are merged with defaults (\code{live-search}, \code{selectOnTab}, \code{title}).
#'
#' @returns An HTML div element containing a styled picker input with attached
#'   CSS dependencies.
#' @export
#'
#' @examples
#' \dontrun{
#' # Basic usage
#' crukPickerInput(
#'   inputId = "treatment_choice",
#'   label = "Select treatment:",
#'   choices = c("Chemotherapy", "Radiotherapy", "Surgery")
#' )
#'
#' # With custom options
#' crukPickerInput(
#'   inputId = "multi_choice",
#'   label = "Select multiple:",
#'   choices = letters[1:10],
#'   placeholder = "Choose one or more...",
#'   options = list(
#'     `actions-box` = TRUE,
#'     `selected-text-format` = "count > 3"
#'   ),
#'   multiple = TRUE
#' )
#' }
crukPickerInput <- function(inputId, label, choices, class = "", livesearch = TRUE, placeholder = NULL, ..., options = list()) {
  shiny::addResourcePath(
    prefix = "shinyCRUK",
    directoryPath = system.file("www", package = "shinyCRUK")
  )

  css <- htmltools::htmlDependency(
    name = "dropdowns",
    version = utils::packageVersion("shinyCRUK"),
    src = "www",
    package = "shinyCRUK",
    stylesheet = "css/dropdowns.css"
  )
  # define default options
  default_options <- list(
    `live-search` = livesearch,
    selectOnTab = TRUE,
    title = placeholder
  )
  # Merge user-provided options with defaults
  merged_options <- utils::modifyList(default_options, options)
  # Pass ... to pickerInput, and merged options to the options argument
  dropdown <- htmltools::div(
    class = c("crukPickerInput", class),

    # class = "crukPickerInput",
    shinyWidgets::pickerInput(
      inputId = inputId,
      label = label,
      choices = choices,
      options = merged_options,
      ...
    )
  )
  htmltools::attachDependencies(dropdown, list(css))
}
