# Create a CRUK-branded download button

This function creates a Cancer Research UK branded download button for
Shiny applications. It wraps
[`shiny::downloadButton()`](https://rdrr.io/pkg/shiny/man/downloadButton.html)
with CRUK-specific styling and optional Google Material Symbols icons.

## Usage

``` r
crukDownloadButton(
  outputId,
  text = "Download data",
  type = "secondary",
  icon = "download",
  align = "right",
  ...
)
```

## Arguments

- outputId:

  The name of the output slot that the download handler uses.

- text:

  The button label text to display. Default is "Download data"

- type:

  Character string specifying button style. Either `"primary"` (magenta
  background) or `"secondary"` (default, white background with magenta
  border).

- icon:

  Optional character string specifying which Google Material Symbol to
  display. Must be one of: `"upload_file"`, `"download"`,
  `"check_circle"`, `"open_in_new"`, `"content_copy"`, `"mail"`, or
  `"share"`. Default is `"download"`.

- align:

  Character string. Horizontal alignment of the button within its
  container. Either `"right"` (default) or `"left"`.

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
