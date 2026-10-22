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
  dataSourceText = NULL,
  dataSourceLink = NULL,
  ...
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
  [`reactable::reactableOutput`](https://glin.github.io/reactable/reference/reactable-shiny.html).

- alt:

  Character. Alt text to include alongside the chart. Minimum 15
  characters; over 125 characters gives a warning (it may cause issues
  with some screen readers). Please ensure alt text is sufficiently
  descriptive. Supplied character string will be appended with the text
  " Please see table for the data in an accessible format."

- dataSourceText:

  Optional. Character, or a `shiny.tag`/UI output object (e.g.
  [`shiny::textOutput`](https://rdrr.io/pkg/shiny/man/textOutput.html),
  [`shiny::uiOutput`](https://rdrr.io/pkg/shiny/man/htmlOutput.html)).
  The data source text displayed at the bottom of the table, after a
  static "Data source: " label on the same line. If a tag/output object
  is supplied it is inserted as rendered content rather than coerced to
  a string. Top-level `div` outputs (the default for `textOutput` and
  `uiOutput`) are converted to `span`s so they stay inline. If `NULL`
  (the default), no data source line is added and "Data source" does not
  appear.

- dataSourceLink:

  Optional. Where the user goes when they click `dataSourceText`. Either
  a single character URL, or a `shiny.tag` output
  ([`shiny::textOutput`](https://rdrr.io/pkg/shiny/man/textOutput.html)
  or [`shiny::uiOutput`](https://rdrr.io/pkg/shiny/man/htmlOutput.html))
  whose rendered content is the URL, so the link can be reactive. The
  URL is never displayed. For a `renderUI` output you can return plain
  text, or a tag containing an `<a href>`, in which case its `href` is
  used. Only `http(s)://` URLs are used; if the rendered value is
  anything else the text is shown without a link. Needs
  `dataSourceText`: if supplied on its own, it is ignored with a
  warning.

- ...:

  Optional additional arguments

## Value

A
[`bslib::navset_card_tab`](https://rstudio.github.io/bslib/reference/navset.html)
object with attached CSS dependencies for CRUK styling. The card
includes:

- A border-less, shadow-less card with two
  [`bslib::nav_panel`](https://rstudio.github.io/bslib/reference/nav-items.html)s

- A tab with the heading "Chart".

- Attached alt text to the chart output, directing users to the table

- A tab with the heading "Table" and, if supplied, a data source

- Optional additional arguments placed above the card, e.g. a title
  using
  [`htmltools::h1`](https://rstudio.github.io/htmltools/reference/builder.html)
  or selectors using
  [`shinyCRUK::crukPickerInput`](https://crukorg.github.io/shinyCRUK/reference/crukPickerInput.md)
  or
  [`shinyCRUK::crukSelectInput`](https://crukorg.github.io/shinyCRUK/reference/crukSelectInput.md).

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

- `dataSourceText` can be a dynamic
  [`shiny::textOutput`](https://rdrr.io/pkg/shiny/man/textOutput.html)
  or [`shiny::uiOutput`](https://rdrr.io/pkg/shiny/man/htmlOutput.html)
  if you need the data source label to update reactively; just remember
  to bind it server-side with a matching
  `output$id <- renderText({...})` (or `renderUI`), since the output tag
  itself is only a placeholder until bound.

- `dataSourceLink` is the destination of the click on `dataSourceText`;
  the URL itself is never shown.

## Examples

``` r
if (FALSE) { # \dontrun{
# Basic card with just chart and table
crukChartTable(
  chart = plotlyOutput(outputId = "mtcarsPlot"),
  table = gt::gt_output(outputId = "mtTable"),
  alt = "A chart showing how horsepower varies according to mpg in the mtcars dataset."
)

# Card with a data source
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

# Chart and table card with a reactive data source label
crukChartTable(
  chart = plotlyOutput(outputId = "mtcarsPlot"),
  table = gt::gt_output(outputId = "mtTable"),
  alt = "Some alt text to go with the chart.",
  dataSourceText = shiny::textOutput("dataSourceLabel"),
  dataSourceLink = "https://www.rdocumentation.org/packages/datasets/versions/3.6.2/topics/mtcars"
)

# Chart and table card with a reactive data source label and link.
# Server side: output$dataSourceLabel <- renderText(...);
#              output$dataSourceUrl <- renderText(url())
crukChartTable(
  chart = plotlyOutput(outputId = "mtcarsPlot"),
  table = gt::gt_output(outputId = "mtTable"),
  alt = "Some alt text to go with the chart.",
  dataSourceText = shiny::textOutput("dataSourceLabel"),
  dataSourceLink = shiny::textOutput("dataSourceUrl")
)
} # }
```
