# CRUK Date Picker

Creates a date picker with CRUK styling. This is a wrapper for
`shinyWidgets::airDatePickerInput` with additional CRUK-specific styling
applied via CSS dependencies.

## Usage

``` r
crukDatePicker(
  inputId,
  label,
  start,
  end,
  view = "months",
  value = Sys.Date(),
  minView = NULL,
  startView = NULL,
  class = "",
  ...
)
```

## Arguments

- inputId:

  The inputId to access the selected value

- label:

  Character. Text to display above the label. Use `NULL` for no label.

- start:

  The minimum date to display. Either a Date object or a string in the
  form `yyyy-mm-dd`.

- end:

  The minimum date to display. Either a Date object or a string in the
  form `yyyy-mm-dd`.

- view:

  Starting view, one of 'days', 'months' (default) or 'years'.

- value:

  Sets the default selected date. Either a Date object or a string in
  the form `yyyy-mm-dd`. Defaults to
  [`Sys.Date()`](https://rdrr.io/r/base/Sys.time.html).

- minView:

  Minimal view, one of 'days', 'months' or 'years'. Defaults to equal to
  `view`.

- startView:

  View to display when opening the calendar. Defaults to `value`

- class:

  Additional CSS classes to apply to wrapper div.

- ...:

  Additional arguments passed to `shinyWidgets::airDatePickerInput`

## Value

An HTML div element containing a styled airDatePickerInput with attached
CSS dependencies.

## Examples

``` r
if (FALSE) { # \dontrun{
crukDatePicker(
  inputId = "dateInput",
  label = "Select a date:",
  start = min(data$Date),
  end = max(date$Date),
  view = "months",
  minView = "months"
)

} # }
```
