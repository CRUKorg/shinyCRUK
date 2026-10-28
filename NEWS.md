# shinyCRUK 0.7.0

## New functions
* New `crukNavLink()` and `crukNavLinkSetup()` functions - Wraps scrollToDivWhenReady.js 
and onclick, facilitating navigation using `crukValueBox()`, or any other navigation
element. Can be used to set up multiple onclick events at once, tidying code.

## Bug fixes
*`crukRounding()` now uses the correct "around" / "nearly" / "more than"
  thresholds for numbers of 1 million and above. The thresholds had been copied
  from the 100,000+ range without being scaled, so most numbers in the millions
  were described too early as "nearly" or "around" (e.g. 1,090,747 returned
  "nearly 1,090,000" instead of "around 1,090,000"). The 100 million+ range also
  rounded rather than floored in its "more than" wording. **Output wording will
  change for many values of 1 million and above**, for example 1,234,567 now
  returns "more than 1,230,000" rather than "around 1,230,000".
* Corrected the `crukRounding()` example for `156789`, which should return
  "nearly 157,000"

## Minor tweaks
* Slightly bumped header font size in crukTable(), from 0.6875rem 
(11px with `crukTheme()`) to 0.75rem (12px with `crukTheme()`)

# shinyCRUK 0.6.2
* Minor update to `crukTable()` function:
  * Removed default all-caps header styling. Now headers are in whatever case your 
    column headings are. Rename column headings before passing them to `crukTable()` 
    or restyle them as you would in `reactable`.
  * Added `fitHeaders` argument, set to `TRUE` by default. This enables minor
    automatic resizing of column header widths. Pass the reactive from `window_is_narrow()`
    to the `mobile` argument to slightly reduce font sizes, column widths, and padding
    when table is below the breakpoint set in `window_is_narrow()` (default is 900px).
    Header columns will widths will attempt to shrink to just a bit wider than the 
    longest word in the heading cell. Set `fitHeaders` to `FALSE` to disable this and
    enable `reactable`'s default behaviour (which allows line breaks mid-word).
    Manually editing column widths with `colDef()` is respected.


# shinyCRUK 0.6.1

## New functions
* New `window_is_narrow()` helper function. Calling this function on a reactive 
returned from `window_size_server()` returns TRUE if screen width is smaller than 
a chosen breakpoint (default is 900 pixels). 

## Bug fixes

* Fixed an issue where `crukRadioButton()` wouldn't grow above 48px, causing text 
to overflow the box if it wrapped onto a second line.
* `crukTable()`: The line above the pagination bar is now 3px solid black, as is
  the right-hand divider on the row header column (`colDef(rowHeader = TRUE)`).
* `crukTable()`: Tupplying `defaultPageSize` now switches pagination on (it was
silently ignored while `pagination` was `FALSE`). Setting both
`pagination = FALSE` and `defaultPageSize` warns that the page size is ignored.
* `crukTable()`: Treviously, passing the width returned from `window_size_server()` 
would redraw the every time the screen changed size. This caused a bug where paginated 
tables would be redrawn every time the user navigates to a page with fewer than 
`defaultPageSize` entries, which would reset the pagination to the first page. Now 
a new `mobile` parameter is designed to work with the new `window_is_narrow()` function, 
which only updates when the screen width cross the breakpoint, preventing redrawing.

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
