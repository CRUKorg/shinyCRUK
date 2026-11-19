# CRUK Data Sources Box with Zotero Integration

Creates a styled box displaying data sources and optional notes for CRUK
applications. Notes and sources can be fixed (a character string or a
list of `<li>` elements) or rendered dynamically from the server using
[`textOutput()`](https://rdrr.io/pkg/shiny/man/textOutput.html) and
[`uiOutput()`](https://rdrr.io/pkg/shiny/man/htmlOutput.html).

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

  Optional explanatory notes displayed above the data sources list,
  under a "Notes:" header. Use this to provide context about data
  limitations, methodology, or important caveats. Either:

  - a character string. If `""` (the default) no notes section is shown;
    or

  - a Shiny output such as `shiny::textOutput("my_notes")` or
    `shiny::uiOutput("my_notes")`, filled by the matching `render*()`
    function in your server. The "Notes:" header is always shown in this
    case, because the UI is built before the server knows whether the
    notes will be empty.

- zotero_path:

  Character string or NULL. Path to a Zotero collection (e.g.,
  `"General & Cross Pathway/Local Stats Dashboard"`). When provided, the
  function automatically fetches bibliographic references from Zotero
  and formats them as an HTML list. Takes precedence over
  `custom_sources`. Default is `NULL`.

- custom_sources:

  Custom list of data sources to display. Use this when not integrating
  with Zotero or when you need custom formatting. Only used if
  `zotero_path` is `NULL`. Either:

  - `NULL` (the default), or an
    [`htmltools::tagList()`](https://rstudio.github.io/htmltools/reference/tagList.html)
    of `htmltools::tags$li()` elements;

  - `shiny::uiOutput("my_sources")`. The output container is turned into
    the `<ul>` itself, so the matching
    [`renderUI()`](https://rdrr.io/pkg/shiny/man/renderUI.html) must
    return `<li>` elements only, not a `<ul>`; or

  - `shiny::textOutput("my_source")`, for a single plain-text source.
    The text is escaped, so it cannot contain links or multiple bullets.
    Use [`uiOutput()`](https://rdrr.io/pkg/shiny/man/htmlOutput.html)
    for anything richer.

  A [`uiOutput()`](https://rdrr.io/pkg/shiny/man/htmlOutput.html) or
  [`textOutput()`](https://rdrr.io/pkg/shiny/man/textOutput.html) must
  be passed directly, not inside another
  [`tagList()`](https://rstudio.github.io/htmltools/reference/tagList.html),
  or it will not be recognised.

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

## Dynamic notes and sources

Because the UI is built before the server runs, `crukSources()` cannot
inspect dynamic content. Output IDs must be unique on the page, and
inside a Shiny module they must be wrapped in `ns()`. For example:


    # UI
    crukSources(
      notes = shiny::textOutput("src_notes"),
      custom_sources = shiny::uiOutput("src_list")
    )

    # Server
    output$src_notes <- shiny::renderText("Data up to 2024.")
    output$src_list <- shiny::renderUI({
      htmltools::tagList(
        htmltools::tags$li("First source"),
        htmltools::tags$li("Second source")
      )
    })

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
[`setup_zotero_credentials`](https://crukorg.github.io/shinyCRUK/reference/setup_zotero_credentials.md)
to help configure these.

## Custom Sources Format

When providing a static `custom_sources`, create a list of `<li>`
elements:


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
[`crukFooter`](https://crukorg.github.io/shinyCRUK/reference/crukFooter.md).

## Styling

The sources box uses custom CSS (`crukSources.css`) that provides:

- Distinct "Notes:" and "Data sources:" headers

- Consistent spacing and typography

- Optional border (2px solid black when `boxBorder = TRUE`)

- Bulleted lists indented so that the bullets sit under the headers

- Responsive padding and margins

Zotero lists also carry the class `"zotero-list"`, which is available as
a hook for custom CSS but has no rules of its own in `crukSources.css`.

## See also

[`get_zotero_sources`](https://crukorg.github.io/shinyCRUK/reference/get_zotero_sources.md)
for the underlying Zotero fetching function

[`setup_zotero_credentials`](https://crukorg.github.io/shinyCRUK/reference/setup_zotero_credentials.md)
for configuring Zotero API access

[`find_zotero_group`](https://crukorg.github.io/shinyCRUK/reference/find_zotero_group.md)
for finding your Zotero group ID

[`crukFooter`](https://crukorg.github.io/shinyCRUK/reference/crukFooter.md)
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
        href = "https://www.ons.gov.uk"
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
#>       <a href="https://www.ons.gov.uk">Cancer Registration Statistics</a>
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

# With dynamic notes and sources, rendered from the server
if (interactive()) {
  library(shiny)

  ui <- fluidPage(
    crukSources(
      notes = textOutput("src_notes"),
      custom_sources = uiOutput("src_list")
    )
  )

  server <- function(input, output, session) {
    output$src_notes <- renderText("This is a dynamic note.")
    output$src_list <- renderUI({
      htmltools::tagList(
        htmltools::tags$li("First source"),
        htmltools::tags$li("Second source")
      )
    })
  }

  shinyApp(ui, server)
}

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
