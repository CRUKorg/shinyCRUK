# Create a CRUK-branded radio button group

This function creates a Cancer Research UK branded radio button
selector. It wraps
[`shinyWidgets::radioGroupButtons()`](https://dreamrs.github.io/shinyWidgets/reference/radioGroupButtons.html)
with CRUK-specific styling to match the helix design system.

## Usage

``` r
crukRadioButton(
  inputId,
  label,
  choices,
  width = NULL,
  justified = TRUE,
  class = "",
  ...
)
```

## Arguments

- inputId:

  The unique identifier for the radio button.

- label:

  Display label for the radio button group.

- choices:

  List of values to select from. If elements of the list are named, then
  the names rather than the values are displayed to the user. Can be a
  vector or a named list.

- width:

  The width of the input group. Can be specified in pixels (e.g.,
  `"400px"`), percentage (e.g., `"100%"`), or `NULL` (default) for
  automatic width.

- justified:

  Logical. If `TRUE` (default), buttons are stretched to fill the width
  of the container evenly. If `FALSE`, buttons are sized to their
  content.

- class:

  Additional CSS classes to apply to the radio button container.
  Optional parameter for custom styling.

- ...:

  Additional arguments passed to
  [`shinyWidgets::radioGroupButtons()`](https://dreamrs.github.io/shinyWidgets/reference/radioGroupButtons.html).

## Value

A Shiny radio button group tag with CRUK branding and attached CSS
dependencies.

## Details

The function automatically applies CRUK brand styling through the
`css/buttons.css` stylesheet.

## Dependencies

This function requires the `shinyWidgets` package to be installed and
loaded, as it wraps
[`shinyWidgets::radioGroupButtons()`](https://dreamrs.github.io/shinyWidgets/reference/radioGroupButtons.html).

## See also

[`crukButton`](https://verbose-guacamole-l18vr83.pages.github.io/reference/crukButton.md)
for creating CRUK-branded action buttons.
[`radioGroupButtons`](https://dreamrs.github.io/shinyWidgets/reference/radioGroupButtons.html)
for the underlying widget.

## Examples

``` r
if (interactive()) {
  library(shiny)
  library(shinyWidgets)

  ui <- fluidPage(
    # Basic usage
    crukRadioButton(
      inputId = "filter1",
      label = "Select a time period:",
      choices = c("Daily", "Weekly", "Monthly", "Yearly")
    ),

    # With named choices
    crukRadioButton(
      inputId = "filter2",
      label = "Choose data type:",
      choices = list(
        "Donations" = "don",
        "Volunteers" = "vol",
        "Events" = "evt"
      )
    ),

    # Non-justified buttons with custom width
    crukRadioButton(
      inputId = "filter3",
      label = "Select option:",
      choices = c("Yes", "No", "Maybe"),
      width = "300px",
      justified = FALSE
    ),

    # Without label
    crukRadioButton(
      inputId = "filter4",
      label = NULL,
      choices = c("Option A", "Option B", "Option C")
    )
  )

  server <- function(input, output, session) {
    # Access the selected value
    observeEvent(input$filter1, {
      print(paste("Selected:", input$filter1))
    })
  }

  shinyApp(ui, server)
}
```
