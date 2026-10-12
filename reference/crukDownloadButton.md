# Create a CRUK-branded download button

This function creates a Cancer Research UK branded download button for
Shiny applications. It wraps
[`shiny::downloadButton()`](https://rdrr.io/pkg/shiny/man/downloadButton.html)
with CRUK-specific styling and optional Google Material Symbols icons.

## Usage

``` r
crukDownloadButton(outputId, text, type = "secondary", icon = "download", ...)
```

## Arguments

- outputId:

  The name of the output slot that the download handler uses.

- text:

  The button label text to display.

- type:

  Character string specifying button style. Either `"primary"` (default,
  magenta background) or `"secondary"` (white background with magenta
  border).

- icon:

  Optional character string specifying which Google Material Symbol to
  display. Must be one of: `"upload_file"`, `"download"`,
  `"check_circle"`, `"open_in_new"`, `"content_copy"`, `"mail"`, or
  `"share"`. Default is `NULL` (no icon).

- ...:

  Additional arguments passed to
  [`shiny::downloadButton()`](https://rdrr.io/pkg/shiny/man/downloadButton.html).

## Value

A Shiny download button tag with CRUK branding and attached CSS/icon
dependencies.

## Examples

``` r
if (interactive()) {
  library(shiny)

  ui <- fluidPage(
    crukDownloadButton(
      "downloadDemoData",
      "Download data",
      type = "secondary",
      icon = "download"
    )
  )

  server <- function(input, output, session) {
    output$downloadDemoData <- downloadHandler(
      filename = function() {
        paste0("mtcars_", Sys.Date(), ".csv")
      },
      content = function(file) {
        write.csv(mtcars, file, row.names = FALSE)
      }
    )
  }

  shinyApp(ui, server)
}
```
