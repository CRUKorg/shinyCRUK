# shinyCRUK 0.6.0

## New functions

* `crukKeyStatBox()` adds a bordered box containing a key statement and, optionally,
  an image.
  * `statement` accepts a single character string, or a Shiny output such as
    `textOutput()` or `uiOutput()`, so the statement can be reactive.
  * `image` is optional. It takes the file name of an image in the app's `www`
    folder and displays it at 140px by 140px. It is treated as decorative
    (`alt = ""`).
  * The layout responds to the width of the box rather than the width of the page
    (a CSS container query). The image sits to the left of the statement when there
    is room, and above it otherwise.

## Changes to `crukChartTable()`

### Breaking changes

* `dataSourceText` is now the displayed text, and `dataSourceLink` is the URL the
  user goes to when they click on it. The URL is no longer displayed. Previously,
  unless the link was a `shinyapps.io` URL ending in `#`, the URL was printed after
  the source text.

### New features

* `dataSourceText` and `dataSourceLink` are now optional. If neither is supplied, no
  source line is added and the words "Data source" do not appear. If only
  `dataSourceText` is supplied, it is shown as plain text without a link. If
  `dataSourceLink` is supplied without `dataSourceText`, it is ignored with a warning.
* `dataSourceLink` now accepts `shiny::textOutput()` and `shiny::uiOutput()` as well
  as a character string, so the link can be reactive. The rendered value is used as
  the destination of the link and is not displayed. Only `http(s)://` URLs are used.
* A top-level `div` supplied as `dataSourceText` (the default for `textOutput()` and
  `uiOutput()`) is now converted to a `span`, so it stays on the same line as the
  "Data source:" label.

### Bug fixes

* The data source line is now sized to its full text in `crukChartTable.css`, so
  "Data source: ..." no longer wraps onto two lines.
* Alt text over 125 characters now gives a warning instead of an error. Alt text
  under 15 characters, or empty, still errors.
* Documentation: fixed the "Title" tab typo (now "Table") and a stray `#'` in the
  examples.

# shinyCRUK 0.5.1

* `crukTable()` gains `WindowSize`, `mobileBreakpoint` and `mobileMaxWidth`
  arguments. Pass the reactive from `window_size_server()` to draw a compact
  table (smaller fonts, padding and column widths) on narrow screens.
* `crukChartTable()` now fills its container's width, and content that is too
  wide scrolls horizontally inside the card instead of widening the page.
* `centralColumn()`: on screens under 992px, one wide child (e.g. a table) no
  longer stretches the whole column, and the page, past the screen edge.
* `crukTitle()`' subtitle now resizes properly on mobile.
  
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
