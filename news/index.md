# Changelog

## shinyCRUK 0.5.1

- [`crukTable()`](https://verbose-guacamole-l18vr83.pages.github.io/reference/crukTable.md)
  gains `WindowSize`, `mobileBreakpoint` and `mobileMaxWidth` arguments.
  Pass the reactive from
  [`window_size_server()`](https://verbose-guacamole-l18vr83.pages.github.io/reference/window_size.md)
  to draw a compact table (smaller fonts, padding and column widths) on
  narrow screens.
- [`crukChartTable()`](https://verbose-guacamole-l18vr83.pages.github.io/reference/crukChartTable.md)
  now fills its container’s width, and content that is too wide scrolls
  horizontally inside the card instead of widening the page.
- [`centralColumn()`](https://verbose-guacamole-l18vr83.pages.github.io/reference/centralColumn.md):
  on screens under 992px, one wide child (e.g. a table) no longer
  stretches the whole column, and the page, past the screen edge.
- [`crukTitle()`](https://verbose-guacamole-l18vr83.pages.github.io/reference/crukTitle.md)’
  subtitle now resizes properly on mobile.

## shinyCRUK 0.5.0

- New
  [`crukTooltip()`](https://verbose-guacamole-l18vr83.pages.github.io/reference/crukTooltip.md)
  function, a tooltip based on the Helix design system’s Popover

## shinyCRUK 0.4.0

### New features

- New
  [`crukTable()`](https://verbose-guacamole-l18vr83.pages.github.io/reference/crukTable.md)
  family of functions, built as a wrapper around
  [`reactable::reactable()`](https://glin.github.io/reactable/reference/reactable.html).
  - [`crukTable()`](https://verbose-guacamole-l18vr83.pages.github.io/reference/crukTable.md)
    creates a styled table that can be used outside of shiny (eg. in
    RMarkdown or Quarto docs)
    - [`renderCrukTable()`](https://verbose-guacamole-l18vr83.pages.github.io/reference/renderCrukTable.md)
      renders a
      [`crukTable()`](https://verbose-guacamole-l18vr83.pages.github.io/reference/crukTable.md)
      in a reactive environment so allowing the user to pass reactive
      variables
    - [`crukTableOutput()`](https://verbose-guacamole-l18vr83.pages.github.io/reference/crukTableOutput.md)
      is a matching output function for
      [`renderCrukTable()`](https://verbose-guacamole-l18vr83.pages.github.io/reference/renderCrukTable.md)
- New
  [`crukDownloadButton()`](https://verbose-guacamole-l18vr83.pages.github.io/reference/crukDownloadButton.md),
  a CRUK-styled wrapper around
  [`shiny::downloadButton()`](https://rdrr.io/pkg/shiny/man/downloadButton.html).
  Like
  [`crukButton()`](https://verbose-guacamole-l18vr83.pages.github.io/reference/crukButton.md),
  it takes `type` (`"primary"` or `"secondary"`) and an optional
  Material Symbols `icon`.

### Bug fixes

- [`crukChartTable()`](https://verbose-guacamole-l18vr83.pages.github.io/reference/crukChartTable.md):
  `dataSourceText` now accepts
  [`shiny::textOutput()`](https://rdrr.io/pkg/shiny/man/textOutput.html)
  or
  [`shiny::uiOutput()`](https://rdrr.io/pkg/shiny/man/htmlOutput.html),
  so the data source label can update reactively. Previously, tag
  objects were converted to a string and showed as raw markup.

## shinyCRUK 0.3.0

- First time creating updating the news!
