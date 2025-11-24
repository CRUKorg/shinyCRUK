# Central Column Container

Creates a responsive central column container for main page content.
This div provides a centered, fixed-width content area with responsive
whitespace on either side, following CRUK design patterns for optimal
readability and visual hierarchy.

## Usage

``` r
centralColumn(...)
```

## Arguments

- ...:

  UI elements to be placed within the central column. Can include any
  Shiny or HTML elements such as text, plots, tables, or other
  components. All arguments are automatically wrapped in the central
  column container.

## Value

An
[`htmltools::tagList`](https://rstudio.github.io/htmltools/reference/tagList.html)
containing:

- An `htmlDependency` that loads `centralColumn.css`

- A `div` element with class `"central-column"` wrapping the provided
  content

## Details

This container should wrap all main page elements except the navigation
bar, creating a consistent content width across different screen sizes
while maintaining appropriate margins.

## Responsive Behavior

The central column adapts to different screen sizes:

- Desktop:

  Fixed width of 900px, centered with automatic side margins

- Tablet/Mobile:

  Full width with responsive padding to maintain readability on smaller
  screens

The exact responsive breakpoints and styling are defined in
`inst/www/css/centralColumn.css`.

## CSS Details

- CSS class: `"central-column"`

- Stylesheet: `centralColumn.css`

- Maximum content width: 900px (desktop)

## Layout Pattern

Typical page structure using this function:

    ui <- fluidPage(
      tags$head(crukTheme()),
      crukNavTitle(Title = "My App"),  # Outside centralColumn
      centralColumn(                    # Everything else inside
        # All main content here
      )
    )

## See also

[`crukNavTitle`](https://verbose-guacamole-l18vr83.pages.github.io/reference/crukNavTitle.md)
for the navigation bar that sits outside this container

[`crukTheme`](https://verbose-guacamole-l18vr83.pages.github.io/reference/crukTheme.md)
for applying overall CRUK styling

## Examples

``` r
if (FALSE) { # \dontrun{
# Basic usage with a title
centralColumn(
  crukTitle("Page Title")
)

# Multiple elements
centralColumn(
  crukTitle("Dashboard"),
  p("Welcome to the data dashboard."),
  plotOutput("mainPlot")
)

# With various content types
centralColumn(
  crukTitle("Analysis Results"),
  h3("Summary Statistics"),
  tableOutput("summaryTable"),
  h3("Visualization"),
  plotOutput("chart"),
  textOutput("notes")
)

# Complete Shiny app structure
library(shiny)
library(shinyCRUK)

ui <- fluidPage(
  tags$head(crukTheme()),

  # Navigation bar (outside central column)
  crukNavTitle(
    Title = "Cancer Statistics Dashboard",
    selectors = 1,
    selector1 = selectInput(
      "cancer_type",
      "Cancer Type:",
      choices = c("Breast", "Lung", "Bowel", "Prostate")
    )
  ),

  # Main content (inside central column)
  centralColumn(
    crukTitle("Incidence Trends"),
    p("Explore cancer incidence trends over time."),
    plotOutput("trendPlot", height = "400px"),
    crukTitle("Data Table"),
    tableOutput("dataTable"),
    p(
      "Data source: Cancer Research UK",
      class = "text-muted"
    )
  )
)

server <- function(input, output, session) {
  output$trendPlot <- renderPlot({
    # Your plotting code
  })

  output$dataTable <- renderTable({
    # Your table code
  })
}

shinyApp(ui, server)

# Nested layout with multiple sections
ui <- fluidPage(
  tags$head(crukTheme()),
  crukNavTitle(Title = "Multi-section Dashboard"),
  centralColumn(
    # Section 1
    crukTitle("Overview"),
    fluidRow(
      column(6, valueBoxOutput("metric1")),
      column(6, valueBoxOutput("metric2"))
    ),

    # Section 2
    crukTitle("Detailed Analysis"),
    tabsetPanel(
      tabPanel("Chart", plotOutput("chart")),
      tabPanel("Table", tableOutput("table")),
      tabPanel("Summary", verbatimTextOutput("summary"))
    ),

    # Footer
    hr(),
    p("Last updated: 2024-10-20", style = "color: #666;")
  )
)
} # }
```
