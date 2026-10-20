# CRUK-styled tooltip

Wraps a word or phrase in a span (font-weight 600, colour `#00007e`),
appends an info icon after it, and attaches a CRUK-styled
[`bslib::tooltip()`](https://rstudio.github.io/bslib/reference/tooltip.html)
to that icon. The tooltip shows on hover/focus (desktop) or tap (touch
devices).

## Usage

``` r
crukTooltip(
  text,
  tip,
  placement = c("bottom", "top", "left", "right"),
  id = NULL
)
```

## Arguments

- text:

  A single string: the word or phrase shown before the icon.

- tip:

  The tooltip content. A string or any htmltools tags.

- placement:

  Where the tooltip appears relative to the icon. One of `"bottom"`
  (default), `"top"`, `"left"` or `"right"`.

- id:

  Optional id passed to
  [`bslib::tooltip()`](https://rstudio.github.io/bslib/reference/tooltip.html),
  so the tooltip can be controlled from the server with
  [`bslib::toggle_tooltip()`](https://rstudio.github.io/bslib/reference/tooltip.html).

## Value

An
[`htmltools::tag()`](https://rstudio.github.io/htmltools/reference/builder.html)
with the shinyCRUK tooltip dependency attached.

## Examples

``` r
if (interactive()) {
  library(shiny)
  ui <- bslib::page_fluid(
    shinyCRUK::crukTheme(),
    shiny::p(
      "Here is some ",
      shinyCRUK::crukTooltip("information", "Here is some useful information"),
      " in a sentence."
    )
  )
  shinyApp(ui, function(input, output, session) {})
}
```
