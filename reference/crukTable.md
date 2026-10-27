# Create a CRUK-branded table

Builds a
[`reactable::reactable()`](https://glin.github.io/reactable/reference/reactable.html)
widget with CRUK styling. All styling comes from
`inst/www/css/tables.css`, which is attached as an HTML dependency. In a
Shiny app you will usually use
[`crukTableOutput()`](https://crukorg.github.io/shinyCRUK/reference/crukTableOutput.md)
in the UI and
[`renderCrukTable()`](https://crukorg.github.io/shinyCRUK/reference/renderCrukTable.md)
in the server instead of calling this directly. Call it directly in R
Markdown, Quarto, or for static tables.

## Usage

``` r
crukTable(
  data,
  columns = NULL,
  sortable = TRUE,
  filterable = FALSE,
  selection = "multiple",
  onClick = if (!is.null(selection)) "select" else NULL,
  highlight = TRUE,
  pagination = FALSE,
  defaultPageSize = NULL,
  class = NULL,
  WindowSize = NULL,
  mobileBreakpoint = 900,
  mobileMaxWidth = 375,
  mobile = NULL,
  fitHeaders = TRUE,
  ...
)
```

## Arguments

- data:

  A data frame or matrix to display.

- columns:

  Optional named list of column definitions created with
  [`reactable::colDef()`](https://glin.github.io/reactable/reference/colDef.html).
  A column that sets any of `width`, `maxWidth` or `minWidth` keeps
  exactly that sizing; see `fitHeaders`.

- sortable:

  Logical. Whether columns can be sorted by clicking the column headers.
  Default is `TRUE`.

- filterable:

  Logical. Whether filter inputs are displayed for columns. Default is
  `FALSE`.

- selection:

  Row selection mode: `"multiple"`, `"single"`, or `NULL` for no
  selection. Default is `"multiple"`. Rows are selected by clicking
  them; reactable's checkbox column is not shown (and takes up no
  space). To show it anyway, supply your own `.selection` column
  definition in `columns`.

- onClick:

  Action to perform when a row is clicked. Defaults to `"select"` when
  `selection` is set, otherwise `NULL`.

- highlight:

  Logical. Whether rows are highlighted on hover. Default is `TRUE`.

- pagination:

  Logical. Whether pagination is enabled. Default is `FALSE`, unless
  `defaultPageSize` is supplied and `pagination` is not, in which case
  pagination is switched on.

- defaultPageSize:

  Number of rows per page. If `NULL`, all rows are shown when pagination
  is off and 10 when it is on. Supplying a page size switches pagination
  on unless you also set `pagination = FALSE`, in which case the page
  size is ignored (with a warning).

- class:

  Optional extra CSS class(es) for the table.

- WindowSize:

  Optional. The current window size, i.e. the value of the reactive
  returned by
  [`window_size_server()`](https://crukorg.github.io/shinyCRUK/reference/window_size.md):
  pass `WindowSize()`, not `WindowSize`. Any list with a numeric `width`
  element works. When the window is narrower than `mobileBreakpoint`, a
  compact version of the table is drawn: smaller fonts and cell padding,
  and a smaller default minimum column width so that the table is about
  `mobileMaxWidth` pixels wide or less. If `NULL` (the default), or the
  width is not yet known, the full-size table is drawn. Call
  `crukTable()` inside
  [`renderCrukTable()`](https://crukorg.github.io/shinyCRUK/reference/renderCrukTable.md)
  so the table redraws when the window is resized. Note that a redraw
  resets sorting, filtering and selection. Any `width`, `minWidth` or
  `maxWidth` you set in `columns` takes precedence over the compact
  defaults. Passing `WindowSize = win_size()` inside
  [`renderCrukTable()`](https://crukorg.github.io/shinyCRUK/reference/renderCrukTable.md)
  redraws the table on every window size update, which resets the
  current page. Prefer `mobile = window_is_narrow(win_size)` (see below)
  in Shiny apps.

- mobileBreakpoint:

  Window width in pixels below which the compact table is used. Default
  is 900 (Bootstrap's `md` breakpoint). Only used with `WindowSize`;
  with `mobile`, the breakpoint is whatever you gave
  [`window_is_narrow()`](https://crukorg.github.io/shinyCRUK/reference/window_is_narrow.md).

- mobileMaxWidth:

  Target maximum table width in pixels for the compact table. Used to
  work out the default minimum column width (the table width is not
  capped if there are too many columns to fit; it then scrolls
  horizontally inside its container). Default is 375. With
  `fitHeaders = TRUE` a column is never made narrower than its longest
  header word, so this is a target rather than a guarantee: tables with
  long headers or many columns will scroll horizontally on small screens
  rather than shrink the text or split words.

- mobile:

  Optional. `TRUE` or `FALSE`: draw the compact version of the table
  (see `WindowSize`) or the full-size one. In a Shiny app, pass the
  reactive from
  [`window_is_narrow()`](https://crukorg.github.io/shinyCRUK/reference/window_is_narrow.md)
  called, i.e. `mobile = is_narrow()`. Because
  [`window_is_narrow()`](https://crukorg.github.io/shinyCRUK/reference/window_is_narrow.md)
  only changes when the window crosses its breakpoint, the table is
  redrawn only then, rather than on every resize, so the current page,
  sort order and selection are kept. If supplied, `mobile` takes
  precedence over `WindowSize`. If `NULL` (the default), `WindowSize` is
  used.

- fitHeaders:

  Logical. If `TRUE` (the default), each column's minimum width is
  raised, if necessary, so that the longest word in its header fits on
  one line instead of being split mid-word. The width is estimated from
  the number of characters (not measured in the browser), and capped so
  that one very long word cannot make a column huge. Columns are left
  alone if their `colDef()` sets `width`, `maxWidth` or `minWidth`, or
  sets `show = FALSE` or a custom `header`. Set to `FALSE` for
  reactable's own sizing.

- ...:

  Additional arguments passed to
  [`reactable::reactable()`](https://glin.github.io/reactable/reference/reactable.html).

## Value

A `reactable` htmlwidget with the CRUK table stylesheet attached.

## See also

[`crukTableOutput()`](https://crukorg.github.io/shinyCRUK/reference/crukTableOutput.md),
[`renderCrukTable()`](https://crukorg.github.io/shinyCRUK/reference/renderCrukTable.md),
[`window_is_narrow()`](https://crukorg.github.io/shinyCRUK/reference/window_is_narrow.md)

## Examples

``` r
crukTable(head(mtcars), filterable = FALSE, selection = NULL)

{"x":{"tag":{"name":"Reactable","attribs":{"data":{".rownames":["Mazda RX4","Mazda RX4 Wag","Datsun 710","Hornet 4 Drive","Hornet Sportabout","Valiant"],"mpg":[21,21,22.8,21.4,18.7,18.1],"cyl":[6,6,4,6,8,6],"disp":[160,160,108,258,360,225],"hp":[110,110,93,110,175,105],"drat":[3.9,3.9,3.85,3.08,3.15,2.76],"wt":[2.62,2.875,2.32,3.215,3.44,3.46],"qsec":[16.46,17.02,18.61,19.44,17.02,20.22],"vs":[0,0,1,1,0,1],"am":[1,1,1,0,0,0],"gear":[4,4,4,3,3,3],"carb":[4,4,1,1,2,1]},"columns":[{"id":".rownames","name":"","type":"character","align":"left","headerStyle":{"textAlign":"left"},"sortable":false,"filterable":false,"rowHeader":true},{"id":"mpg","name":"mpg","type":"numeric","align":"left","headerStyle":{"textAlign":"left"}},{"id":"cyl","name":"cyl","type":"numeric","align":"left","headerStyle":{"textAlign":"left"}},{"id":"disp","name":"disp","type":"numeric","align":"left","headerStyle":{"textAlign":"left"}},{"id":"hp","name":"hp","type":"numeric","align":"left","headerStyle":{"textAlign":"left"}},{"id":"drat","name":"drat","type":"numeric","align":"left","headerStyle":{"textAlign":"left"}},{"id":"wt","name":"wt","type":"numeric","align":"left","headerStyle":{"textAlign":"left"}},{"id":"qsec","name":"qsec","type":"numeric","align":"left","headerStyle":{"textAlign":"left"}},{"id":"vs","name":"vs","type":"numeric","align":"left","headerStyle":{"textAlign":"left"}},{"id":"am","name":"am","type":"numeric","align":"left","headerStyle":{"textAlign":"left"}},{"id":"gear","name":"gear","type":"numeric","align":"left","headerStyle":{"textAlign":"left"}},{"id":"carb","name":"carb","type":"numeric","align":"left","headerStyle":{"textAlign":"left"}}],"pagination":false,"defaultPageSize":6,"highlight":true,"borderless":true,"className":"cruk-table cruk-table--highlight cruk-table--sortable","dataKey":"ccb58144b43c63afa6f590ba55b4440c"},"children":[]},"class":"reactR_markup"},"evals":[],"jsHooks":[]}
# Force the compact version
crukTable(head(mtcars), mobile = TRUE)

{"x":{"tag":{"name":"Reactable","attribs":{"data":{".rownames":["Mazda RX4","Mazda RX4 Wag","Datsun 710","Hornet 4 Drive","Hornet Sportabout","Valiant"],"mpg":[21,21,22.8,21.4,18.7,18.1],"cyl":[6,6,4,6,8,6],"disp":[160,160,108,258,360,225],"hp":[110,110,93,110,175,105],"drat":[3.9,3.9,3.85,3.08,3.15,2.76],"wt":[2.62,2.875,2.32,3.215,3.44,3.46],"qsec":[16.46,17.02,18.61,19.44,17.02,20.22],"vs":[0,0,1,1,0,1],"am":[1,1,1,0,0,0],"gear":[4,4,4,3,3,3],"carb":[4,4,1,1,2,1]},"columns":[{"id":".selection","name":"","type":null,"minWidth":40,"align":"left","headerStyle":{"textAlign":"left"},"resizable":false,"width":45,"selectable":true,"show":false},{"id":".rownames","name":"","type":"character","minWidth":40,"align":"left","headerStyle":{"textAlign":"left"},"sortable":false,"filterable":false,"rowHeader":true},{"id":"mpg","name":"mpg","type":"numeric","minWidth":53,"align":"left","headerStyle":{"textAlign":"left"}},{"id":"cyl","name":"cyl","type":"numeric","minWidth":53,"align":"left","headerStyle":{"textAlign":"left"}},{"id":"disp","name":"disp","type":"numeric","minWidth":60,"align":"left","headerStyle":{"textAlign":"left"}},{"id":"hp","name":"hp","type":"numeric","minWidth":45,"align":"left","headerStyle":{"textAlign":"left"}},{"id":"drat","name":"drat","type":"numeric","minWidth":60,"align":"left","headerStyle":{"textAlign":"left"}},{"id":"wt","name":"wt","type":"numeric","minWidth":45,"align":"left","headerStyle":{"textAlign":"left"}},{"id":"qsec","name":"qsec","type":"numeric","minWidth":60,"align":"left","headerStyle":{"textAlign":"left"}},{"id":"vs","name":"vs","type":"numeric","minWidth":45,"align":"left","headerStyle":{"textAlign":"left"}},{"id":"am","name":"am","type":"numeric","minWidth":45,"align":"left","headerStyle":{"textAlign":"left"}},{"id":"gear","name":"gear","type":"numeric","minWidth":60,"align":"left","headerStyle":{"textAlign":"left"}},{"id":"carb","name":"carb","type":"numeric","minWidth":60,"align":"left","headerStyle":{"textAlign":"left"}}],"pagination":false,"defaultPageSize":6,"selection":"multiple","onClick":"select","highlight":true,"borderless":true,"className":"cruk-table cruk-table--selectable cruk-table--highlight cruk-table--sortable cruk-table--compact","dataKey":"083a4b467def13cbdda83a1d2809b1a0"},"children":[]},"class":"reactR_markup"},"evals":[],"jsHooks":[]}
if (FALSE) { # \dontrun{
# In a Shiny app: redraw only when the window crosses the breakpoint
server <- function(input, output, session) {
  win_size  <- window_size_server("window_tracker")
  is_narrow <- window_is_narrow(win_size, breakpoint = 900)

  output$table <- renderCrukTable(
    crukTable(mtcars, pagination = TRUE, mobile = is_narrow())
  )
}
} # }
```
