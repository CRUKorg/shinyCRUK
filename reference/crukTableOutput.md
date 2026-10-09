# CRUK table output for Shiny

UI counterpart to
[`renderCrukTable()`](https://verbose-guacamole-l18vr83.pages.github.io/reference/renderCrukTable.md).
A thin wrapper around
[`reactable::reactableOutput()`](https://glin.github.io/reactable/reference/reactable-shiny.html)
that also loads the CRUK table stylesheet, so the CSS is on the page
before any data arrives.

## Usage

``` r
crukTableOutput(outputId, width = "auto", height = "auto", inline = FALSE)
```

## Arguments

- outputId:

  Output variable to read the table from.

- width, height:

  Width and height of the output, passed to
  [`reactable::reactableOutput()`](https://glin.github.io/reactable/reference/reactable-shiny.html).

- inline:

  Use an inline element for the output container.

## Value

A Shiny UI output element.

## Details

Because this is a reactable output, reactable helpers such as
[`reactable::getReactableState()`](https://glin.github.io/reactable/reference/getReactableState.html)
and
[`reactable::updateReactable()`](https://glin.github.io/reactable/reference/updateReactable.html)
work with the same `outputId`.

## See also

[`renderCrukTable()`](https://verbose-guacamole-l18vr83.pages.github.io/reference/renderCrukTable.md),
[`crukTable()`](https://verbose-guacamole-l18vr83.pages.github.io/reference/crukTable.md)

## Examples

``` r
if (interactive()) {
  library(shiny)

  ui <- fluidPage(
    crukTheme(),
    selectInput("cyl", "Cylinders", choices = sort(unique(mtcars$cyl))),
    crukTableOutput("table")
  )

  server <- function(input, output, session) {
    filtered <- reactive(mtcars[mtcars$cyl == input$cyl, ])

    output$table <- renderCrukTable(crukTable(filtered(), filterable = FALSE))
  }

  shinyApp(ui, server)
}
```
