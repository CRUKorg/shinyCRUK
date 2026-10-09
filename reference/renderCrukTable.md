# Render a CRUK table in Shiny

Server counterpart to
[`crukTableOutput()`](https://verbose-guacamole-l18vr83.pages.github.io/reference/crukTableOutput.md).
`expr` is evaluated reactively and can return either:

## Usage

``` r
renderCrukTable(expr, env = parent.frame(), quoted = FALSE)
```

## Arguments

- expr:

  An expression that returns a
  [`crukTable()`](https://verbose-guacamole-l18vr83.pages.github.io/reference/crukTable.md),
  a data frame or a matrix.

- env:

  The environment in which to evaluate `expr`.

- quoted:

  Is `expr` a quoted expression? Mainly useful for other functions that
  wrap this one.

## Value

A render function for use as `output$id`.

## Details

- a table built with
  [`crukTable()`](https://verbose-guacamole-l18vr83.pages.github.io/reference/crukTable.md),
  so you can set any of its arguments (and use reactive values in them),
  or

- a data frame or matrix, which is passed to
  [`crukTable()`](https://verbose-guacamole-l18vr83.pages.github.io/reference/crukTable.md)
  with its default arguments.

Returning `NULL` renders nothing.

## See also

[`crukTableOutput()`](https://verbose-guacamole-l18vr83.pages.github.io/reference/crukTableOutput.md),
[`crukTable()`](https://verbose-guacamole-l18vr83.pages.github.io/reference/crukTable.md)

## Examples

``` r
if (interactive()) {
  library(shiny)
  library(dplyr)

  ui <- fluidPage(
    crukTheme(),
    selectInput("cyl", "Cylinders", choices = sort(unique(mtcars$cyl))),
    checkboxInput("paginate", "Paginate"),
    crukTableOutput("default_table"),
    crukTableOutput("custom_table")
  )

  server <- function(input, output, session) {
    filtered_data <- reactive(filter(mtcars, cyl == input$cyl))

    # Data only: crukTable() defaults
    output$default_table <- renderCrukTable(filtered_data())

    # Call crukTable() yourself to change its arguments
    output$custom_table <- renderCrukTable({
      filtered_data() |>
        tibble::rownames_to_column("car") |>
        select(car, mpg, cyl, wt, hp) |>
        crukTable(filterable = FALSE, pagination = input$paginate)
    })
  }

  shinyApp(ui, server)
}
```
