# CRUK pickerInput

Creates a styled picker input control with CRUK branding using the
[`shinyWidgets::pickerInput`](https://dreamrs.github.io/shinyWidgets/reference/pickerInput.html)
function. This provides enhanced dropdown functionality including live
search, multiple selection, and custom styling.

## Usage

``` r
crukPickerInput(
  inputId,
  label,
  choices,
  class = "",
  livesearch = TRUE,
  placeholder = NULL,
  ...,
  options = list()
)
```

## Arguments

- inputId:

  The input slot that will be used to access the value.

- label:

  Display label for the control, or NULL for no label.

- choices:

  List of values to select from. If elements of the list are named, then
  that name rather than the value is displayed to the user.

- class:

  Additional CSS classes to apply to the wrapper div.

- livesearch:

  Enable live search functionality. Default is TRUE.

- placeholder:

  Placeholder text displayed when no selection is made.

- ...:

  Additional arguments passed to
  [`shinyWidgets::pickerInput`](https://dreamrs.github.io/shinyWidgets/reference/pickerInput.html).

- options:

  A list of options for bootstrap-select. User-provided options are
  merged with defaults (`live-search`, `selectOnTab`, `title`).

## Value

An HTML div element containing a styled picker input with attached CSS
dependencies.

## Examples

``` r
if (FALSE) { # \dontrun{
# Basic usage
crukPickerInput(
  inputId = "treatment_choice",
  label = "Select treatment:",
  choices = c("Chemotherapy", "Radiotherapy", "Surgery")
)

# With custom options
crukPickerInput(
  inputId = "multi_choice",
  label = "Select multiple:",
  choices = letters[1:10],
  placeholder = "Choose one or more...",
  options = list(
    `actions-box` = TRUE,
    `selected-text-format` = "count > 3"
  ),
  multiple = TRUE
)
} # }
```
