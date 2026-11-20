# Download a plotly chart as a PNG, with a heading

A CRUK-branded button that saves a rendered plotly chart as a PNG
**including a heading**, without using plotly's modebar or any plotly.js
export function. The browser takes a snapshot of the chart's rendered
SVG with html2canvas, placed under a heading, and downloads it. Nothing
is sent to or rendered by the server, so it does not need Chrome,
kaleido or Python on shinyapps.io / Posit Connect.

## Usage

``` r
crukDownloadChartButton(
  plotId,
  filename = "chart",
  heading = NULL,
  headingId = NULL,
  subheading = NULL,
  subheadingId = NULL,
  text = "Download chart",
  type = "secondary",
  icon = "download",
  align = "right",
  scale = 2,
  class = NULL,
  ...
)
```

## Arguments

- plotId:

  The output id of the plotly chart (the id passed to
  [`plotly::plotlyOutput()`](https://rdrr.io/pkg/plotly/man/plotly-shiny.html)).
  Inside a module, pass `ns("plot")`.

- filename:

  File name without extension. Characters that are unsafe in file names
  are replaced with `-`.

- heading:

  Optional fixed heading text.

- headingId:

  Optional id of an element on the page whose text is used as the
  heading. Inside a module, pass `ns("heading")`.

- subheading:

  Optional fixed subheading text, shown under the heading in the PNG.
  Can be used with or without a heading.

- subheadingId:

  Optional id of an element on the page (typically an
  [`shiny::h4()`](https://rstudio.github.io/htmltools/reference/builder.html))
  whose text is used as the subheading. It is read at click time, like
  `headingId`. If both `subheading` and `subheadingId` are given,
  `subheading` wins. Inside a module, pass `ns("subheading")`.

- text:

  Button label.

- type:

  Either `"primary"` (magenta background) or `"secondary"` (default,
  white background with magenta border).

- icon:

  Optional Google Material Symbol shown after the label. One of
  `"upload_file"`, `"download"` (default), `"check_circle"`,
  `"open_in_new"`, `"content_copy"`, `"mail"` or `"share"`. Use `NULL`
  for no icon.

- align:

  Horizontal alignment of the button within its container, `"right"`
  (default) or `"left"`.

- scale:

  Resolution multiplier for the PNG. `2` gives a sharper image.

- class:

  Optional extra CSS classes for the button.

- ...:

  Further attributes passed to the button tag.

## Value

A button tag with CRUK branding and its CSS/JavaScript dependencies
attached.

## Details

The heading can come from an existing element on the page (`headingId`),
from a fixed string (`heading`), or both. If both are given, `heading`
wins. Use `headingId` when the on-screen heading is dynamic (for example
a [`textOutput()`](https://rdrr.io/pkg/shiny/man/textOutput.html) or
[`uiOutput()`](https://rdrr.io/pkg/shiny/man/htmlOutput.html) inside an
[`shiny::h3()`](https://rstudio.github.io/htmltools/reference/builder.html)),
because the text is read at click time.

The button is styled to match
[`crukDownloadButton()`](https://crukorg.github.io/shinyCRUK/reference/crukDownloadButton.md)
and
[`crukButton()`](https://crukorg.github.io/shinyCRUK/reference/crukButton.md).

## Examples

``` r
if (interactive() && requireNamespace("plotly", quietly = TRUE)) {
  library(shiny)
  ui <- fluidPage(
    h3(id = "cars_title", "Stopping distance by speed"),
    plotly::plotlyOutput("cars"),
    crukDownloadChartButton("cars", filename = "cars", headingId = "cars_title")
  )
  server <- function(input, output, session) {
    output$cars <- plotly::renderPlotly(plotly::plot_ly(cars, x = ~speed, y = ~dist))
  }
  shinyApp(ui, server)
}
```
