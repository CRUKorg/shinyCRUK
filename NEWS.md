# shinyCRUK 0.5.1

* `crukTable()` gains `WindowSize`, `mobileBreakpoint` and `mobileMaxWidth`
  arguments. Pass the reactive from `window_size_server()` to draw a compact
  table (smaller fonts, padding and column widths) on narrow screens.
* `crukChartTable()` now fills its container's width, and content that is too
  wide scrolls horizontally inside the card instead of widening the page.
* `centralColumn()`: on screens under 992px, one wide child (e.g. a table) no
  longer stretches the whole column, and the page, past the screen edge.
  
# shinyCRUK 0.5.0

* New `crukTooltip()` function, a tooltip based on the Helix design system's Popover

# shinyCRUK 0.4.0

## New features

* New `crukTable()` family of functions, built as a wrapper around
  `reactable::reactable()`.
  * `crukTable()` creates a styled table that can be used outside of shiny 
    (eg. in RMarkdown or Quarto docs)
    * `renderCrukTable()` renders a `crukTable()` in a reactive environment so 
      allowing the user to pass reactive variables
    * `crukTableOutput()` is a matching output function for `renderCrukTable()`

* New `crukDownloadButton()`, a CRUK-styled wrapper around
  `shiny::downloadButton()`. Like `crukButton()`, it takes `type`
  (`"primary"` or `"secondary"`) and an optional Material Symbols `icon`.

## Bug fixes

* `crukChartTable()`: `dataSourceText` now accepts `shiny::textOutput()` or
  `shiny::uiOutput()`, so the data source label can update reactively.
  Previously, tag objects were converted to a string and showed as raw markup.

# shinyCRUK 0.3.0

* First time creating updating the news!
