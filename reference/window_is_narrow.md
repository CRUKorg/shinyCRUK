# Is the browser window narrower than a breakpoint?

Turns the reactive returned by
[`window_size_server()`](https://crukorg.github.io/shinyCRUK/reference/window_size.md)
into a single `TRUE`/`FALSE` that only changes when the window crosses
`breakpoint`. Use it where a render only needs to know "narrow or wide",
such as `crukTable(mobile = is_narrow())`, instead of reading the raw
width.

## Usage

``` r
window_is_narrow(win_size, breakpoint = 900)
```

## Arguments

- win_size:

  The reactive returned by
  [`window_size_server()`](https://crukorg.github.io/shinyCRUK/reference/window_size.md).
  Pass the reactive itself (`win_size`), not its value (`win_size()`).

- breakpoint:

  Single number. Window width in pixels below which the window counts as
  narrow. Default is 900 (Bootstrap's `md` breakpoint), which matches
  the default `mobileBreakpoint` of
  [`crukTable()`](https://crukorg.github.io/shinyCRUK/reference/crukTable.md).

## Value

A reactive expression returning `TRUE` if the window width is below
`breakpoint`, otherwise `FALSE`. Call it with brackets: `is_narrow()`.

## Details

Reading `win_size()` inside a render function makes that output re-run
on every window size update. Reading the result of `window_is_narrow()`
instead only re-runs it when the value flips, so a table keeps its
current page, sort order and selection while the window is resized
within one band.

Call this once, in the server function (or module server), because it
creates an observer. It does not change
[`window_size_server()`](https://crukorg.github.io/shinyCRUK/reference/window_size.md):
that still returns the full width and height, so you can use both side
by side.

The value is `FALSE` until the browser has reported a width, so the
first render is the wide version. On a narrow window it flips to `TRUE`
shortly afterwards (after the `debounce_ms` of
[`window_size_server()`](https://crukorg.github.io/shinyCRUK/reference/window_size.md))
and the output re-runs once.

It returns only two states. For plots or tables that need to scale
smoothly with the window, or that need the width in pixels, use
`win_size()`.

## See also

[`window_size_server()`](https://crukorg.github.io/shinyCRUK/reference/window_size.md),
[`crukTable()`](https://crukorg.github.io/shinyCRUK/reference/crukTable.md)

## Examples

``` r
if (FALSE) { # \dontrun{
library(shiny)

ui <- fluidPage(
  crukTheme(),
  window_size_ui("window_tracker"),
  crukTableOutput("table")
)

server <- function(input, output, session) {
  win_size  <- window_size_server("window_tracker", debounce_ms = 300)
  is_narrow <- window_is_narrow(win_size, breakpoint = 900)

  output$table <- renderCrukTable(
    crukTable(mtcars, pagination = TRUE, mobile = is_narrow())
  )
}

shinyApp(ui, server)
} # }
```
