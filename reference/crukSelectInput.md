# CRUK selectInput

Creates a styled select input control with CRUK branding and custom CSS
styling. This is a wrapper around
[`shiny::selectInput`](https://rdrr.io/pkg/shiny/man/selectInput.html)
with additional CRUK-specific styling applied via CSS dependencies.

## Usage

``` r
crukSelectInput(inputId, label, choices, selectize = FALSE, class = "", ...)
```

## Arguments

- inputId:

  The input slot that will be used to access the value.

- label:

  Display label for the control, or NULL for no label.

- choices:

  List of values to select from. If elements of the list are named, then
  that name rather than the value is displayed to the user.

- selectize:

  Whether to use selectize.js or not. Default is FALSE.

- class:

  Additional CSS classes to apply to the wrapper div.

- ...:

  Additional arguments passed to
  [`shiny::selectInput`](https://rdrr.io/pkg/shiny/man/selectInput.html).

## Value

An HTML div element containing a styled select input with attached CSS
dependencies.

## Examples

``` r
if (FALSE) { # \dontrun{
# In your Shiny UI
crukSelectInput(
  inputId = "biscuit_choice",
  label = "Select your favourite biscuit:",
  choices = c("Hobnob", "Digestive", "Bourbon")
)
} # }
```
