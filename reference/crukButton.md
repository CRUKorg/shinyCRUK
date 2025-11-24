# Create a CRUK-branded action button

This function creates a Cancer Research UK branded action button for
Shiny applications. It wraps
[`shiny::actionButton()`](https://rdrr.io/pkg/shiny/man/actionButton.html)
with CRUK-specific styling and optional Google Material Symbols icons.

## Usage

``` r
crukButton(inputId, text, type = "primary", icon = NULL, ...)
```

## Arguments

- inputId:

  The `input` slot that will be used to access the value.

- text:

  The button label text to display.

- type:

  Character string specifying button style. Either `"primary"` (default,
  magenta background) or `"secondary"` (white background with magenta
  border).

- icon:

  Optional character string specifying which Google Material Symbol to
  display. Must be one of: `"upload_file"`, `"download"`,
  `"check_circle"`, `"open_in_new"`, `"content_copy"`, `"mail"`, or
  `"share"`. Default is `NULL` (no icon).

- ...:

  Additional arguments passed to
  [`shiny::actionButton()`](https://rdrr.io/pkg/shiny/man/actionButton.html).

## Value

A Shiny action button tag with CRUK branding and attached CSS/icon
dependencies.

## Examples

``` r
if (interactive()) {
  library(shiny)

  ui <- fluidPage(
    crukButton("btn1", "Primary Button", type = "primary"),
    crukButton("btn2", "Download", type = "secondary", icon = "download"),
    crukButton("btn3", "Share", icon = "share")
  )

  server <- function(input, output, session) {
    observeEvent(input$btn1, {
      print("Button clicked!")
    })
  }

  shinyApp(ui, server)
}
```
