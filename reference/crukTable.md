# Create a CRUK-branded table

Builds a
[`reactable::reactable()`](https://glin.github.io/reactable/reference/reactable.html)
widget with CRUK styling. All styling comes from
`inst/www/css/tables.css`, which is attached as an HTML dependency. In a
Shiny app you will usually use
[`crukTableOutput()`](https://verbose-guacamole-l18vr83.pages.github.io/reference/crukTableOutput.md)
in the UI and
[`renderCrukTable()`](https://verbose-guacamole-l18vr83.pages.github.io/reference/renderCrukTable.md)
in the server instead of calling this directly. Call it directly in R
Markdown, Quarto, or for static tables.

## Usage

``` r
crukTable(
  data,
  columns = NULL,
  sortable = TRUE,
  filterable = TRUE,
  selection = "multiple",
  onClick = if (!is.null(selection)) "select" else NULL,
  highlight = TRUE,
  pagination = FALSE,
  defaultPageSize = NULL,
  class = NULL,
  ...
)
```

## Arguments

- data:

  A data frame or matrix to display.

- columns:

  Optional named list of column definitions created with
  [`reactable::colDef()`](https://glin.github.io/reactable/reference/colDef.html).

- sortable:

  Logical. Whether columns can be sorted by clicking the column headers.
  Default is `TRUE`.

- filterable:

  Logical. Whether filter inputs are displayed for columns. Default is
  `TRUE`.

- selection:

  Row selection mode: `"multiple"`, `"single"`, or `NULL` for no
  selection. Default is `"multiple"`.

- onClick:

  Action to perform when a row is clicked. Defaults to `"select"` when
  `selection` is set, otherwise `NULL`.

- highlight:

  Logical. Whether rows are highlighted on hover. Default is `TRUE`.

- pagination:

  Logical. Whether pagination is enabled. Default is `FALSE`.

- defaultPageSize:

  Number of rows per page. If `NULL`, all rows are shown when pagination
  is off and 10 when it is on.

- class:

  Optional extra CSS class(es) for the table.

- ...:

  Additional arguments passed to
  [`reactable::reactable()`](https://glin.github.io/reactable/reference/reactable.html).

## Value

A `reactable` htmlwidget with the CRUK table stylesheet attached.

## See also

[`crukTableOutput()`](https://verbose-guacamole-l18vr83.pages.github.io/reference/crukTableOutput.md),
[`renderCrukTable()`](https://verbose-guacamole-l18vr83.pages.github.io/reference/renderCrukTable.md)

## Examples

``` r
crukTable(head(mtcars), filterable = FALSE, selection = NULL)

{"x":{"tag":{"name":"Reactable","attribs":{"data":{".rownames":["Mazda RX4","Mazda RX4 Wag","Datsun 710","Hornet 4 Drive","Hornet Sportabout","Valiant"],"mpg":[21,21,22.8,21.4,18.7,18.1],"cyl":[6,6,4,6,8,6],"disp":[160,160,108,258,360,225],"hp":[110,110,93,110,175,105],"drat":[3.9,3.9,3.85,3.08,3.15,2.76],"wt":[2.62,2.875,2.32,3.215,3.44,3.46],"qsec":[16.46,17.02,18.61,19.44,17.02,20.22],"vs":[0,0,1,1,0,1],"am":[1,1,1,0,0,0],"gear":[4,4,4,3,3,3],"carb":[4,4,1,1,2,1]},"columns":[{"id":".rownames","name":"","type":"character","align":"left","headerStyle":{"textAlign":"left"},"sortable":false,"filterable":false,"rowHeader":true},{"id":"mpg","name":"mpg","type":"numeric","align":"left","headerStyle":{"textAlign":"left"}},{"id":"cyl","name":"cyl","type":"numeric","align":"left","headerStyle":{"textAlign":"left"}},{"id":"disp","name":"disp","type":"numeric","align":"left","headerStyle":{"textAlign":"left"}},{"id":"hp","name":"hp","type":"numeric","align":"left","headerStyle":{"textAlign":"left"}},{"id":"drat","name":"drat","type":"numeric","align":"left","headerStyle":{"textAlign":"left"}},{"id":"wt","name":"wt","type":"numeric","align":"left","headerStyle":{"textAlign":"left"}},{"id":"qsec","name":"qsec","type":"numeric","align":"left","headerStyle":{"textAlign":"left"}},{"id":"vs","name":"vs","type":"numeric","align":"left","headerStyle":{"textAlign":"left"}},{"id":"am","name":"am","type":"numeric","align":"left","headerStyle":{"textAlign":"left"}},{"id":"gear","name":"gear","type":"numeric","align":"left","headerStyle":{"textAlign":"left"}},{"id":"carb","name":"carb","type":"numeric","align":"left","headerStyle":{"textAlign":"left"}}],"pagination":false,"defaultPageSize":6,"highlight":true,"borderless":true,"className":"cruk-table cruk-table--highlight cruk-table--sortable","dataKey":"ccb58144b43c63afa6f590ba55b4440c"},"children":[]},"class":"reactR_markup"},"evals":[],"jsHooks":[]}
```
