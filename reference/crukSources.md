# CRUK Data Sources Box with Zotero Integration

Creates a styled box displaying data sources and optional notes for CRUK
applications. The function can automatically fetch and format
bibliographic references from a Zotero collection or accept custom HTML
source lists. This component helps users understand the provenance of
data and comply with citation requirements.

## Usage

``` r
crukSources(
  notes = "",
  zotero_path = NULL,
  custom_sources = NULL,
  boxBorder = TRUE
)
```

## Arguments

- notes:

  Character string. Optional explanatory notes to display above the data
  sources list. Use this to provide context about data limitations,
  methodology, or important caveats. Appears with a "Notes:" header.
  Default is an empty string (no notes section).

- zotero_path:

  Character string or NULL. Path to a Zotero collection (e.g.,
  `"General & Cross Pathway/Local Stats Dashboard"`). When provided, the
  function automatically fetches bibliographic references from Zotero
  and formats them as an HTML list. Takes precedence over
  `custom_sources`. Default is `NULL`.

- custom_sources:

  HTML tag list or NULL. Custom HTML list of data sources to display.
  Use this when not integrating with Zotero or when you need custom
  formatting. Should be created with `htmltools::tags$li()` or similar.
  Only used if `zotero_path` is `NULL`. Default is `NULL`.

- boxBorder:

  Logical. If `TRUE` (default), displays a border around the sources
  box. Set to `FALSE` for a borderless design.

## Value

An
[`htmltools::div`](https://rstudio.github.io/htmltools/reference/builder.html)
element with class `"sources"` containing:

- CSS dependency for sources box styling (`crukSources.css`)

- Optional notes section with "Notes:" header

- "Data sources:" header

- Unordered list of sources (from Zotero or custom HTML)

## Zotero Integration

When using `zotero_path`, the function:

1.  Connects to the Zotero API using credentials from environment
    variables

2.  Navigates to the specified collection path

3.  Formats each reference as: "Author(s). Title, Year. Last accessed
    Month, Year."

4.  Returns the formatted citations as an HTML list

## Environment Variables Required for Zotero

To use Zotero integration, set these in your `.Renviron` file:

- `ZOTERO_API_KEY` - Your Zotero API key (from
  https://www.zotero.org/settings/keys)

- `ZOTERO_USER_ID` - Your Zotero user ID (from
  https://www.zotero.org/settings/security)

Use
[`setup_zotero_credentials`](https://verbose-guacamole-l18vr83.pages.github.io/reference/setup_zotero_credentials.md)
to help configure these.

## Custom Sources Format

When providing `custom_sources`, create a list of `<li>` elements:

    custom_sources <- htmltools::tagList(
      htmltools::tags$li("First source citation"),
      htmltools::tags$li("Second source citation"),
      htmltools::tags$li(
        htmltools::a("Linked source", href = "https://example.com")
      )
    )

## Usage Pattern

Place this component near the bottom of your page content, typically
after all data visualizations and tables but before
[`crukFooter`](https://verbose-guacamole-l18vr83.pages.github.io/reference/crukFooter.md).

## Styling

The sources box uses custom CSS (`crukSources.css`) that provides:

- Distinct "Notes:" and "Data sources:" headers in bold

- Consistent spacing and typography

- Optional border (1px solid black when `boxBorder = TRUE`)

- Responsive padding and margins

- Zotero list styling with class `"zotero-list"`

## See also

[`get_zotero_sources`](https://verbose-guacamole-l18vr83.pages.github.io/reference/get_zotero_sources.md)
for the underlying Zotero fetching function

[`setup_zotero_credentials`](https://verbose-guacamole-l18vr83.pages.github.io/reference/setup_zotero_credentials.md)
for configuring Zotero API access

[`find_zotero_group`](https://verbose-guacamole-l18vr83.pages.github.io/reference/find_zotero_group.md)
for finding your Zotero group ID

[`crukFooter`](https://verbose-guacamole-l18vr83.pages.github.io/reference/crukFooter.md)
for the page footer component

## Examples

``` r
# With Zotero integration (requires API credentials)
if (FALSE) { # \dontrun{
crukSources(
  notes = "Data extracted from published reports.
           Figures may differ from official statistics due to rounding.",
  zotero_path = "Cancer Statistics/Incidence Data"
)

# With notes but without border
crukSources(
  notes = "Provisional data subject to revision.",
  zotero_path = "Cancer Statistics/Incidence Data",
  boxBorder = FALSE
)
} # }

# With custom sources (no Zotero required)
crukSources(
  custom_sources = htmltools::tagList(
    htmltools::tags$li(
      "Office for National Statistics. ",
      htmltools::a(
        "Cancer Registration Statistics",
        href = "https://www.ons.gov.uk/peoplepopulationandcommunity/healthandsocialcare/
                conditionsanddiseases"
      ),
      ", 2023."
    ),
    htmltools::tags$li(
      "NHS Digital. Hospital Episode Statistics, 2022-2023."
    )
  )
)
#> <div class="sources border">
#>   <span class="sources-header">Data sources:</span>
#>   <ul style="margin-top: 0px">
#>     <li>
#>       Office for National Statistics. 
#>       <a href="https://www.ons.gov.uk/peoplepopulationandcommunity/healthandsocialcare/&#10;                conditionsanddiseases">Cancer Registration Statistics</a>
#>       , 2023.
#>     </li>
#>     <li>NHS Digital. Hospital Episode Statistics, 2022-2023.</li>
#>   </ul>
#> </div>

# With both notes and custom sources
crukSources(
  notes = "Age-standardised rates calculated using the 2013 European Standard Population.",
  custom_sources = htmltools::tagList(
    htmltools::tags$li("Cancer Research UK. Cancer Incidence and Mortality, 2024."),
    htmltools::tags$li("Public Health England. Cancer Services Data, 2023.")
  ),
  boxBorder = TRUE
)
#> <div class="sources border">
#>   <p>
#>     <span class="notes-header">Notes:</span>
#>     <br/>
#>     Age-standardised rates calculated using the 2013 European Standard Population.
#>   </p>
#>   <span class="sources-header">Data sources:</span>
#>   <ul style="margin-top: 0px">
#>     <li>Cancer Research UK. Cancer Incidence and Mortality, 2024.</li>
#>     <li>Public Health England. Cancer Services Data, 2023.</li>
#>   </ul>
#> </div>

# In a complete Shiny app
if (FALSE) { # \dontrun{
library(shiny)
library(shinyCRUK)

ui <- fluidPage(
  tags$head(crukTheme()),
  crukNavTitle(Title = "Cancer Statistics Dashboard"),
  centralColumn(
    crukTitle("Incidence Data"),
    plotOutput("incidencePlot"),
    tableOutput("incidenceTable"),

    # Data sources at the bottom
    crukSources(
      notes = "Data represents cancer registrations in England, 2018-2020.",
      zotero_path = "General & Cross Pathway/Shiny Example"
    )
  ),
  crukFooter()
)

server <- function(input, output, session) {
  output$incidencePlot <- renderPlot({
    # Your plotting code
  })

  output$incidenceTable <- renderTable({
    # Your table code
  })
}

shinyApp(ui, server)
} # }
```
