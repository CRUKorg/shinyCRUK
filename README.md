
<!-- README.md is generated from README.Rmd. Please edit that file -->

# shinyCRUK

<!-- badges: start -->
<!-- badges: end -->

**shinyCRUK** provides Cancer Research UK-branded components for
building Shiny applications that align with CRUK’s Helix Design System
and brand guidelines.

## Features

### CRUK Brandomg

- Pre-styled components following CRUK brand guidelines
- Consistent typography using Progress Medium and Poppins fonts
- CRUK color palette and visual identity
- Responsive layouts for mobile and desktop

### Key Components

- **Navigation**: Branded nav bar with responsive logos and selectors
- **Layout**: Central column containers for optimal content width
- **Fonts**: Page titles and headings with CRUK styling
- **Value Boxes**: Styled value boxes
- **Footers**: Complete footer with legal information and contact
  details
- **Utilities**: Rounding functions per CI guidelines

## Installation

Install the development version from GitHub:

``` r
# Using pak
pak::pak("CRUKorg/shinyCRUK")

# Or using remotes
remotes::install_github("CRUKorg/shinyCRUK")
```

## Quick Start

Here’s a minimal example of a CRUK-branded Shiny app:

``` r
library(shiny)
library(shinyCRUK)

ui <- fluidPage(
  tags$head(crukTheme()),
  
  crukNavTitle(Title = "Cancer Statistics Dashboard"),
  
  centralColumn(
    lastReview("20 October 2025"),
    
    crukTitle(
      "UK Cancer Incidence",
      "Latest statistics for common cancer types"
    ),
    
    bslib::layout_column_wrap(
      width = 1/3,
      
      crukValueBox(
        id = "incidence",
        title = "New Cases",
        value = crukRounding(367850),
        icon = shiny::icon("user-plus"),
        detail = "Annual incidence in UK"
      ),
      
      crukValueBox(
        id = "survival",
        title = "Survival Rate",
        value = "50%",
        icon = shiny::icon("heart"),
        detail = "10-year survival"
      ),
      
      crukValueBox(
        id = "mortality",
        title = "Deaths",
        value = crukRounding(167512),
        icon = shiny::icon("chart-line-down"),
        detail = "Annual mortality in UK"
      )
    ),
    
    plotOutput("examplePlot"),
    
    crukFooter()
  )
)

server <- function(input, output, session) {
  output$examplePlot <- renderPlot({
    # Your plot here
  })
}

shinyApp(ui, server)
```

## Core Components

### Theme and Layout

``` r
# Apply CRUK theme
tags$head(crukTheme())

# Create central content column (900px max width)
centralColumn(
  # Your content here
)
```

### Navigation

Navbar styling handles desktop and mobile, with up to two selectors in
the navbar.

``` r
# Simple navigation
crukNavTitle(Title = "Early Diagnosis Data Hub")

# With selectors
crukNavTitle(
  Title = "Data Dashboard",
  selectors = 2,
  selector1 = selectInput("year", "Year:", 2020:2024),
  selector2 = selectInput("region", "Region:", c("UK", "England", "Scotland", "Wales", "Northern Ireland"))
)
```

### Typography

``` r
# Page title with optional subheading
crukTitle(
  "Cancer Incidence Trends",
  "Age-standardised rates per 100,000 population"
)
```

### Logos

``` r
# Stacked logo (preferred)
crukLogo(height = "50px")

# Wide logo (use sparingly)
crukLogoWide(height = "35px")
```

### Value Boxes

``` r
crukValueBox(
  id = "metric1",
  title = "Total Cases",
  value = crukRounding(1234),
  icon = shiny::icon("chart-bar"),
  icon_colour = "#00007e",  # CRUK blue
  detail = "Year ending 2024"
)
```

### Styled last review

Use these for the top of pages so users know how up to date material is.

``` r
# Public content
lastReview("20 October 2025")

# Health professional content
lastReview("20 October 2025", tag = "health_professional")

# Internal content
lastReview("20 October 2025", tag = "internal")

# Accepts multiple date formats
lastReview("20/10/2025")              # UK format
lastReview(as.Date("2025-10-20"))     # Date object
lastReview(Sys.Date())                # Current date
```

### Footer

``` r
# Full footer with contact information
crukFooter()

# Footer without contact section 
crukFooter(includeContact = FALSE)
```

### Number Formatting

``` r
# Format numbers per CRUK Intelligence guidelines
crukRounding(1200)
# Returns: "around 1,200"

crukRounding(156789)
# Returns: "around 157,000"
```

## Design System Integration

This package aligns with CRUK’s Helix Design System which is used
throughout the new Contentful pages. It is built to rely on
[bslib](https://rstudio.github.io/bslib/) components, particularly
`bslib::page_navbar()` for navigation layouts.

## Documentation

Comprehensive function documentation is available on the [package
website](https://verbose-guacamole-l18vr83.pages.github.io/).

Each function includes: - Detailed parameter descriptions - Usage
examples - Accessibility guidelines

## CRUK Brand Colors

## Requirements

- shiny
- htmltools
- bslib
- dplyr

## Contributing

This package is maintained by the CRUK Cancer Intelligence team. For
questions, issues, or contributions, open an issue on GitHub or message
Matt or Sam.
