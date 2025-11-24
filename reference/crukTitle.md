# Page Title with Optional Subheading

Creates a styled page title element with an optional subheading and
decorative horizontal rule. This function generates the main heading
(h1) for content pages in CRUK applications, providing consistent
typography and spacing per CRUK brand guidelines.

## Usage

``` r
crukTitle(Title, Subheading = "")
```

## Arguments

- Title:

  Character string. The main page title text to display as an h1
  heading. This should be a concise, descriptive title for the page
  content. Required.

- Subheading:

  Character string. Optional subheading text to display below the main
  title. Use this to provide additional context or description for the
  page. Appears in a smaller font below the title. Default is an empty
  string (no subheading).

## Value

An
[`htmltools::tagList`](https://rstudio.github.io/htmltools/reference/tagList.html)
containing:

- CSS dependency for title styling (`crukTitle.css`)

- A `div` container with class `"cruk-title-container"`

- An `h1` element with the main title (Progress Medium font)

- A `p` element with the subheading (Poppins font), if provided

- A thick horizontal rule (`hr`) as a visual separator

## Details

The title appears in the Progress Medium font, followed by an optional
subheading in Poppins font, and a distinctive thick horizontal rule that
serves as a visual separator.

## Styling

The title uses CRUK brand typography:

- Title (h1):

  Font: Progress Medium, Weight: 500, Margin: 0px

- Subheading (p):

  Font: Poppins, Margin: 28px top, 0px other sides, Class:
  "cruk-title-subheading"

- Horizontal Rule:

  Width: 4rem (~64px), Height: 0.5rem (~8px), Color: Black, Margin: 1rem
  top, 2rem bottom

## Usage Pattern

Place this at the beginning of each page's content, typically as the
first element within
[`centralColumn`](https://verbose-guacamole-l18vr83.pages.github.io/reference/centralColumn.md).
Use descriptive titles that clearly communicate the page's purpose.

## See also

[`centralColumn`](https://verbose-guacamole-l18vr83.pages.github.io/reference/centralColumn.md)
for the container that typically wraps page content

[`crukNavTitle`](https://verbose-guacamole-l18vr83.pages.github.io/reference/crukNavTitle.md)
for the application-level navigation title

## Examples

``` r
# Simple title without subheading
crukTitle("Cancer Incidence")
#> <div class="cruk-title-container">
#>   <h1 class="cruk-title-heading">Cancer Incidence</h1>
#>   <hr class="cruk-title-rule"/>
#> </div>

# Title with descriptive subheading
crukTitle(
  "Incidence for Common Cancers",
  "Latest cancer incidence statistics for the years 2017-2019"
)
#> <div class="cruk-title-container">
#>   <h1 class="cruk-title-heading">Incidence for Common Cancers</h1>
#>   <p class="cruk-title-subheading">Latest cancer incidence statistics for the years 2017-2019</p>
#>   <hr class="cruk-title-rule"/>
#> </div>

# Longer, more descriptive title and subheading
crukTitle(
  "Five-Year Survival Rates by Cancer Type",
  "Age-standardised net survival for adults diagnosed 2013-2017, followed up to 2018"
)
#> <div class="cruk-title-container">
#>   <h1 class="cruk-title-heading">Five-Year Survival Rates by Cancer Type</h1>
#>   <p class="cruk-title-subheading">Age-standardised net survival for adults diagnosed 2013-2017, followed up to 2018</p>
#>   <hr class="cruk-title-rule"/>
#> </div>

# Title only (empty subheading is default)
crukTitle("Data Methods and Sources")
#> <div class="cruk-title-container">
#>   <h1 class="cruk-title-heading">Data Methods and Sources</h1>
#>   <hr class="cruk-title-rule"/>
#> </div>

if (FALSE) { # \dontrun{
# In a complete Shiny app
library(shiny)
library(shinyCRUK)

ui <- fluidPage(
  tags$head(crukTheme()),
  crukNavTitle(Title = "Cancer Statistics Dashboard"),
  centralColumn(
    # Page title at the start of content
    crukTitle(
      "Incidence Trends",
      "Explore cancer incidence rates from 2000 to 2020"
    ),

    # Main page content follows
    plotOutput("incidencePlot"),
    tableOutput("incidenceTable")
  )
)
} # }
```
