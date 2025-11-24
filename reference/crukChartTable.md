# Border-less Card for Chart and Table Combined Output

Creates a border-less bslib card with two panels: one for a chart and
the other for a table. This function has a requirement for alt text to
ensure accessibility best practice.

## Usage

``` r
crukChartTable(
  chart,
  table,
  alt,
  dataSourceText,
  dataSourceLink,
  ...,
  height = 600
)
```

## Arguments

- chart:

  A chart output in the form of a
  [`shiny::plotOutput`](https://rdrr.io/pkg/shiny/man/plotOutput.html),
  `plotly::plotlyOutput`, or `highcharter::highchartOutput`.

- table:

  A table output in the form of a
  [`shiny::tableOutput`](https://rdrr.io/pkg/shiny/man/renderTable.html),
  `DT::dataTableOutput`, `gt::gt_output`, or
  `reactable::reactableOutput`.

- alt:

  Character. Alt text to include alongside the chart. Minimum 15
  characters. Please ensure alt text is sufficiently descriptive.
  Supplied character string will be appended with the text " Please see
  table for the data in an accessible format."

- dataSourceText:

  Character. Data source text that is displayed at the bottom of the
  table. Text is appended with "Data source: " in front.

- dataSourceLink:

  Character. URL for the data source hyperlink.

- ...:

  Optional additional arguments

- height:

  Height of the card. Default is 600 pixels.

## Value

A
[`bslib::navset_card_tab`](https://rstudio.github.io/bslib/reference/navset.html)
object with attached CSS dependencies for CRUK styling. The card
includes:

- A border-less, shadow-less card with two
  [`bslib::nav_panel`](https://rstudio.github.io/bslib/reference/nav-items.html)s

- A tab with the heading "Chart".

- Attached alt text to the chart output, directing users to the table

- A tab with the heading "Title" and a data source

- Optional additional arguments placed above the card, e.g. a title
  using
  [`htmltools::h1`](https://rstudio.github.io/htmltools/reference/builder.html)
  or selectors using
  [`shinyCRUK::crukPickerInput`](https://verbose-guacamole-l18vr83.pages.github.io/reference/crukPickerInput.md)
  or
  [`shinyCRUK::crukSelectInput`](https://verbose-guacamole-l18vr83.pages.github.io/reference/crukSelectInput.md).

## Usage Tips

- Use descriptive but concise alt text

- By default, `plotly::plotlyOutput`s should scale to fill the div, so
  avoid manually setting chart sizes

- If you want a title or selectors to apply to the chart and table, pass
  these as additional arguments. They will be displayed about the chart
  table card

- Ideally give full data source. If this is not possible (for example
  because you are using UK data from several sources), then you can
  direct the user to a data sources/references box at the bottom of the
  page and supply the function the full URL of the app with the div id
  of the data sources/reference box

## Examples

``` r
if (FALSE) { # \dontrun{
#' # Basic card with just chart and table
crukChartTable(
  chart = plotlyOutput(outputId = "mtcarsPlot"),
  table = gt::gt_output(outputId = "mtTable"),
  alt = "A chart showing how horsepower varies according to mpg in the mtcars dataset.",
  dataSourceText = "mtcars: Motor Trend Car Road Tests",
  dataSourceLink = "https://www.rdocumentation.org/packages/datasets/versions/3.6.2/topics/mtcars"
)

# Chart and table card with additional arguments passed
crukChartTable(
  chart = plotlyOutput(outputId = "mtcarsPlot"),
  table = gt::gt_output(outputId = "mtTable"),
  alt = "Some alt text to go with the chart.",
  dataSourceText = "mtcars: Motor Trend Car Road Tests",
  dataSourceLink = "https://www.rdocumentation.org/packages/datasets/versions/3.6.2/topics/mtcars",
  htmltools::h1("mtcars: higher horsepower decreases mpg"),
  htmltools::br(),
  prettyCheckbox(inputId = "showCIs",
                 label = strong("Show confidence intervals"),
                 shape = "square",
                 value = FALSE)
)
} # }
```
