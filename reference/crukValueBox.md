# CRUK-Branded Value Box

Creates a branded value box component for displaying key metrics or
statistics in CRUK applications. The value box features a title,
prominent value display, optional icon, and detail text, all styled
according to CRUK design guidelines.

## Usage

``` r
crukValueBox(
  id,
  title = "",
  value = "",
  icon = "",
  icon_colour = "#00007e",
  detail = ""
)
```

## Arguments

- id:

  Character string. The HTML id attribute for the value box element.
  Used for targeting with CSS or JavaScript. Required.

- title:

  Character string. The title text displayed at the top of the value
  box, describing what the value represents. A horizontal rule appears
  below the title. Default is an empty string.

- value:

  Character string or numeric. The main value to display prominently in
  the value box (e.g., "250", "45.2 with the Progress Medium font.
  Default is an empty string.

- icon:

  A Shiny icon object or Material Symbols icon. The icon to display in
  the showcase area on the left side of the value box. Can be created
  with [`shiny::icon()`](https://rdrr.io/pkg/shiny/man/icon.html) for
  Font Awesome icons or other icon systems. Default is an empty string
  (no icon).

- icon_colour:

  Character string. The color of the showcase icon, specified as a CSS
  color value (hex code, RGB, or named color). Default is `"#00007e"`
  (CRUK dark blue). Note: Uses British spelling to align with CRUK
  conventions.

- detail:

  Character string. Optional detail text displayed below the main value,
  providing additional context or information. Appears in smaller text.
  Default is an empty string.

## Value

A
[`bslib::value_box`](https://rstudio.github.io/bslib/reference/value_box.html)
object with attached CSS dependencies for CRUK styling and Google
Material Symbols font. The value box includes:

- Title with horizontal rule separator

- Large, prominent value display with forward arrow icon

- Left-aligned showcase area for custom icon

- Detail text below the value

- White background with black text (CRUK theme)

## Details

Value boxes are useful for highlighting important numbers, KPIs, or
summary statistics in dashboards and data visualizations. The CRUK value
box includes a distinctive horizontal rule under the title and a forward
arrow icon next to the value.

## Styling

The value box uses custom CSS (`crukValueBox.css`) that applies:

- Progress Medium font for the value display

- CRUK-styled horizontal rule under the title

- Material Symbols "arrow_forward" icon next to the value

- Showcase layout with icon on the left (25% width)

- White background with black text

## Dependencies

This function loads:

- `crukValueBox.css` - Custom CRUK value box styling

- Google Material Symbols Outlined font - For the arrow icon

- `bslib` package - For the base value box component

## Usage Tips

- Use concise titles that clearly describe the metric

- Format values appropriately (e.g., add commas for thousands, % signs)

- Choose icons that visually represent the metric

- Use the default CRUK blue for icons unless brand guidelines specify
  otherwise

- Keep detail text brief - one or two lines maximum

## See also

[`value_box`](https://rstudio.github.io/bslib/reference/value_box.html)
for the underlying value box component
[`icon`](https://rdrr.io/pkg/shiny/man/icon.html) for creating Font
Awesome icons

## Examples

``` r
# Basic value box with title and value
crukValueBox(
  id = "valueBox1",
  title = "Total Cases",
  value = "250"
)
#> <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Sharp:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" rel="stylesheet"/>
#> <div class="card bslib-card bslib-mb-spacing bslib-card-input html-fill-item html-fill-container bslib-value-box showcase-left-center" data-bslib-card-init data-require-bs-caller="card() value_box()" data-require-bs-version="5 5" id="valueBox1" style="color:#000000;background-color:#ffffff;--bslib-color-fg:#000000;--bslib-color-bg:#ffffff;">
#>   <div class="card-body bslib-gap-spacing html-fill-item html-fill-container" style="margin-top:auto;margin-bottom:auto;flex:1 1 auto; padding:0;">
#>     <div class="value-box-grid html-fill-item" style="--bslib-grid-height:auto;--bslib-grid-height-mobile:auto;---bslib-value-box-showcase-w:25%;---bslib-value-box-showcase-w-fs:1fr;---bslib-value-box-showcase-max-h:100px;---bslib-value-box-showcase-max-h-fs:67%;">
#>       <div class="value-box-showcase html-fill-item html-fill-container">
#>         <span style="color: #00007e;"></span>
#>       </div>
#>       <div class="value-box-area html-fill-item html-fill-container">
#>         <p class="value-box-title">
#>           Total Cases
#>           <hr class="value-box-hr"/>
#>         </p>
#>         <div class="value-box-value value-box-value">
#>           <span style="font-family: Progress Medium;">250</span>
#>           <i class="material-symbols-sharp value-box-value-arrow">arrow_forward</i>
#>         </div>
#>         
#>       </div>
#>     </div>
#>   </div>
#>   <script data-bslib-card-init>bslib.Card.initializeAllCards();</script>
#> </div>

# Value box with icon and detail
crukValueBox(
  id = "valueBox2",
  title = "Average Weight",
  value = "74.5 kg",
  icon = shiny::icon("weight-scale"),
  detail = "Based on 1,234 patients"
)
#> <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Sharp:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" rel="stylesheet"/>
#> <div class="card bslib-card bslib-mb-spacing bslib-card-input html-fill-item html-fill-container bslib-value-box showcase-left-center" data-bslib-card-init data-require-bs-caller="card() value_box()" data-require-bs-version="5 5" id="valueBox2" style="color:#000000;background-color:#ffffff;--bslib-color-fg:#000000;--bslib-color-bg:#ffffff;">
#>   <div class="card-body bslib-gap-spacing html-fill-item html-fill-container" style="margin-top:auto;margin-bottom:auto;flex:1 1 auto; padding:0;">
#>     <div class="value-box-grid html-fill-item" style="--bslib-grid-height:auto;--bslib-grid-height-mobile:auto;---bslib-value-box-showcase-w:25%;---bslib-value-box-showcase-w-fs:1fr;---bslib-value-box-showcase-max-h:100px;---bslib-value-box-showcase-max-h-fs:67%;">
#>       <div class="value-box-showcase html-fill-item html-fill-container">
#>         <span style="color: #00007e;">
#>           <i class="fas fa-weight-scale" role="presentation" aria-label="weight-scale icon"></i>
#>         </span>
#>       </div>
#>       <div class="value-box-area html-fill-item html-fill-container">
#>         <p class="value-box-title">
#>           Average Weight
#>           <hr class="value-box-hr"/>
#>         </p>
#>         <div class="value-box-value value-box-value">
#>           <span style="font-family: Progress Medium;">74.5 kg</span>
#>           <i class="material-symbols-sharp value-box-value-arrow">arrow_forward</i>
#>         </div>
#>         Based on 1,234 patients
#>       </div>
#>     </div>
#>   </div>
#>   <script data-bslib-card-init>bslib.Card.initializeAllCards();</script>
#> </div>

# Value box with custom icon color
crukValueBox(
  id = "valueBox3",
  title = "Survival Rate",
  value = "89.2%",
  icon = shiny::icon("heart-pulse"),
  icon_colour = "#009cee",
  detail = "5-year net survival"
)
#> <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Sharp:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" rel="stylesheet"/>
#> <div class="card bslib-card bslib-mb-spacing bslib-card-input html-fill-item html-fill-container bslib-value-box showcase-left-center" data-bslib-card-init data-require-bs-caller="card() value_box()" data-require-bs-version="5 5" id="valueBox3" style="color:#000000;background-color:#ffffff;--bslib-color-fg:#000000;--bslib-color-bg:#ffffff;">
#>   <div class="card-body bslib-gap-spacing html-fill-item html-fill-container" style="margin-top:auto;margin-bottom:auto;flex:1 1 auto; padding:0;">
#>     <div class="value-box-grid html-fill-item" style="--bslib-grid-height:auto;--bslib-grid-height-mobile:auto;---bslib-value-box-showcase-w:25%;---bslib-value-box-showcase-w-fs:1fr;---bslib-value-box-showcase-max-h:100px;---bslib-value-box-showcase-max-h-fs:67%;">
#>       <div class="value-box-showcase html-fill-item html-fill-container">
#>         <span style="color: #009cee;">
#>           <i class="fas fa-heart-pulse" role="presentation" aria-label="heart-pulse icon"></i>
#>         </span>
#>       </div>
#>       <div class="value-box-area html-fill-item html-fill-container">
#>         <p class="value-box-title">
#>           Survival Rate
#>           <hr class="value-box-hr"/>
#>         </p>
#>         <div class="value-box-value value-box-value">
#>           <span style="font-family: Progress Medium;">89.2%</span>
#>           <i class="material-symbols-sharp value-box-value-arrow">arrow_forward</i>
#>         </div>
#>         5-year net survival
#>       </div>
#>     </div>
#>   </div>
#>   <script data-bslib-card-init>bslib.Card.initializeAllCards();</script>
#> </div>

# Multiple value boxes in a layout
if (FALSE) { # \dontrun{
library(shiny)
library(shinyCRUK)

ui <- fluidPage(
  tags$head(crukTheme()),
  crukNavTitle(Title = "Cancer Statistics Dashboard"),
  centralColumn(
    crukTitle("Key Metrics", "Overview of cancer statistics"),

    # Layout value boxes in a grid
    bslib::layout_column_wrap(
      width = 1 / 3,
      crukValueBox(
        id = "incidence",
        title = "New Cases",
        value = "367,000",
        icon = shiny::icon("user-plus"),
        detail = "Annual incidence in UK"
      ),
      crukValueBox(
        id = "survival",
        title = "Survival Rate",
        value = "50%",
        icon = shiny::icon("heart"),
        icon_colour = "#e40087",
        detail = "10-year survival"
      ),
      crukValueBox(
        id = "mortality",
        title = "Deaths",
        value = "167,000",
        icon = shiny::icon("chart-line-down"),
        detail = "Annual mortality in UK"
      )
    )
  )
)

server <- function(input, output, session) {
  # Server logic here
}

shinyApp(ui, server)

# Reactive value boxes with server-side updates
ui <- fluidPage(
  tags$head(crukTheme()),
  crukNavTitle(Title = "Live Dashboard"),
  centralColumn(
    selectInput("cancer_type", "Cancer Type:",
      choices = c("Breast", "Lung", "Bowel")
    ),
    uiOutput("dynamicValueBoxes")
  )
)

server <- function(input, output, session) {
  output$dynamicValueBoxes <- renderUI({
    # Get data based on selection
    cases <- switch(input$cancer_type,
      "Breast" = "55,900",
      "Lung" = "48,500",
      "Bowel" = "42,900"
    )

    bslib::layout_column_wrap(
      width = 1 / 2,
      crukValueBox(
        id = "cases_box",
        title = paste(input$cancer_type, "Cancer Cases"),
        value = cases,
        icon = shiny::icon("hospital"),
        detail = "Annual incidence"
      ),
      crukValueBox(
        id = "rate_box",
        title = "Incidence Rate",
        value = "123.4",
        icon = shiny::icon("chart-line"),
        detail = "Per 100,000 population"
      )
    )
  })
}

shinyApp(ui, server)
} # }
```
