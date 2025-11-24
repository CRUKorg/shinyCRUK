# Cancer Intelligence Team Attribution Box

Only for use in internal apps.

## Usage

``` r
ciBox(boxBorder = TRUE)
```

## Arguments

- boxBorder:

  Logical. If `TRUE` (default), displays the attribution box with a 1px
  solid black border. Set to `FALSE` for a borderless version that
  blends more seamlessly with surrounding content.

## Value

An
[`htmltools::div`](https://rstudio.github.io/htmltools/reference/builder.html)
element with attached CSS dependencies containing:

- Cancer Intelligence logo (SVG format)

- Attribution text explaining the team's role

- Contact email link (cancerintelligence@cancer.org.uk) for feedback and
  bug reports

## Details

Creates a styled box that credits the Cancer Intelligence team as the
creators of the application. Includes the Cancer Intelligence logo and
contact information.

The box is typically placed at the bottom of the page, within
[`centralColumn`](https://verbose-guacamole-l18vr83.pages.github.io/reference/centralColumn.md),
and can be displayed with or without a border.

## Styling

The component uses custom CSS (`ciBox.css`) that provides:

- Flexible layout with logo and text positioned side-by-side on desktop

- Responsive stacking of logo and text on mobile devices

- Optional border styling controlled by the `boxBorder` parameter

- CRUK brand-compliant typography and spacing

## Dependencies

- CSS: `inst/www/css/ciBox.css`

- Logo: `inst/www/images/CI-logo.svg`

## Usage Context

This component is specifically designed for apps created by the Cancer
Intelligence team to showcase work and provide attribution. Only us it
for internal apps.

## Placement

The attribution box should be placed at the end of your UI definition,
typically:

- As the last element within
  [`centralColumn`](https://verbose-guacamole-l18vr83.pages.github.io/reference/centralColumn.md)

- Before or after
  [`crukFooter`](https://verbose-guacamole-l18vr83.pages.github.io/reference/crukFooter.md)
  depending on your layout needs

- At the bottom of the page to maintain clear visual hierarchy

## See also

[`crukFooter`](https://verbose-guacamole-l18vr83.pages.github.io/reference/crukFooter.md)
for the main CRUK footer with legal information

[`centralColumn`](https://verbose-guacamole-l18vr83.pages.github.io/reference/centralColumn.md)
for the main content container

## Examples

``` r
# Basic usage with border (default)
ciBox()
#> <div class="ci-box" style="border: 2px solid black;">
#>   <div class="ci-logo">
#>     <img src="shinyCRUK/images/CI-logo.svg"/>
#>   </div>
#>   <div class="ci-child">
#>     <p class="ci-text">
#>       This app was made by the Cancer Intelligence team. If you have feedback or have found a bug, then please email
#>       <a href="mailto:cancerintelligence@cancer.org.uk" class="ci-email">cancerintelligence@cancer.org.uk</a>
#>     </p>
#>   </div>
#> </div>

# Without border for seamless integration
ciBox(boxBorder = FALSE)
#> <div class="ci-box">
#>   <div class="ci-logo">
#>     <img src="shinyCRUK/images/CI-logo.svg"/>
#>   </div>
#>   <div class="ci-child">
#>     <p class="ci-text">
#>       This app was made by the Cancer Intelligence team. If you have feedback or have found a bug, then please email
#>       <a href="mailto:cancerintelligence@cancer.org.uk" class="ci-email">cancerintelligence@cancer.org.uk</a>
#>     </p>
#>   </div>
#> </div>

if (FALSE) { # \dontrun{
# Complete Shiny app with attribution box
library(shiny)
library(shinyCRUK)

ui <- fluidPage(
  tags$head(crukTheme()),
  crukNavTitle(Title = "Cancer Statistics Dashboard"),
  centralColumn(
    crukTitle("Analysis Results"),
    p("Main content goes here..."),
    plotOutput("mainPlot"),

    # Add attribution box at the end
    ciBox()
  ),
  # Optional: Add main CRUK footer after
  crukFooter()
)

server <- function(input, output, session) {
  output$mainPlot <- renderPlot({
    plot(1:10)
  })
}

shinyApp(ui, server)
} # }
```
