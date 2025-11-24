# Get Formatted Sources from Zotero Collection

Retrieves bibliographic references from a Zotero collection and formats
them as HTML-ready citation strings. This function connects to the
Zotero API, navigates to a specified collection path, and returns
formatted citations suitable for display in a shiny app.

## Usage

``` r
get_zotero_sources(
  collection_path,
  group_id = 6230705,
  api_key = Sys.getenv("ZOTERO_API_KEY"),
  last_accessed = NULL
)
```

## Arguments

- collection_path:

  Character string. Path to the Zotero collection using forward slashes
  to separate nested collections (e.g.,
  `"General & Cross Pathway/Local Stats Dashboard"`. The function
  navigates through the collection hierarchy to find the target
  collection.

- group_id:

  Numeric. Zotero group library ID. Default is `6230705` (CRUK team
  library). Use
  [`find_zotero_group`](https://verbose-guacamole-l18vr83.pages.github.io/reference/find_zotero_group.md)
  to find your group ID if using a different library.

- api_key:

  Character string. Zotero API key for authentication. Default reads
  from the `ZOTERO_API_KEY` environment variable. Get your API key from
  https://www.zotero.org/settings/keys

- last_accessed:

  Character string or NULL. Optional custom "Last accessed" text to
  override the access date stored in Zotero. Useful for standardising
  access dates across multiple sources. Format: "Last accessed Month,
  Year" (e.g., `"Last accessed January, 2024"`). When `NULL` (default),
  uses the access date from each Zotero item's metadata.

## Value

A character vector of HTML-formatted citation strings, one per reference
in the collection. Each string includes:

- Author name(s) (or "Unknown Author" if missing)

- Title (hyperlinked if URL available, or "Untitled" if missing)

- Year (if available)

- Access date (from Zotero metadata or `last_accessed` parameter)

## Details

The function formats each reference as: "Author(s). Title, Year. Last
accessed Month, Year." with clickable links to the source URLs when
available.

## Authentication

This function requires valid Zotero API credentials. Set up your
credentials by:

1.  Getting an API key from https://www.zotero.org/settings/keys

2.  Adding `ZOTERO_API_KEY=your_key_here` to your `.Renviron` file

3.  Restarting R

Or use
[`setup_zotero_credentials`](https://verbose-guacamole-l18vr83.pages.github.io/reference/setup_zotero_credentials.md)
to help with this setup.

## Collection Paths

Collection paths use forward slashes (`/`) to navigate nested
collections:

- Top-level collection: `"My Collection"`

- Nested collection: `"Parent/Child"`

- Deeply nested: `"Grandparent/Parent/Child"`

Collection names are case-sensitive and must match exactly.

## Error Handling

The function will stop with an informative error if:

- The API key is not found or invalid

- The specified collection path doesn't exist

- The collection exists but contains no references

- The API request fails

## Citation Format

References are formatted according to CRUK guidelines:

- Multiple authors are concatenated with spaces

- Titles are hyperlinked when URLs are available

- Years are extracted from full dates when necessary

- Access dates are formatted as "Last accessed Month, Year"

## See also

[`crukSources`](https://verbose-guacamole-l18vr83.pages.github.io/reference/crukSources.md)
for displaying the formatted sources in a styled box

[`setup_zotero_credentials`](https://verbose-guacamole-l18vr83.pages.github.io/reference/setup_zotero_credentials.md)
for configuring API access

[`find_zotero_group`](https://verbose-guacamole-l18vr83.pages.github.io/reference/find_zotero_group.md)
for finding your Zotero group ID

## Examples

``` r
# Basic usage (requires ZOTERO_API_KEY in .Renviron)
if (FALSE) { # \dontrun{
# Get sources from a collection
sources <- get_zotero_sources("General & Cross Pathway/Shiny Example")

# Use with custom group ID
sources <- get_zotero_sources(
  collection_path = "My Research/Papers",
  group_id = 1234567
)

# Override access dates
sources <- get_zotero_sources(
  collection_path = "General & Cross Pathway/Shiny Example",
  last_accessed = "Last accessed October, 2024"
)

# Pass directly to crukSources
crukSources(
  notes = "All data sources were accessed in October 2024.",
  custom_sources = htmltools::tagList(
    purrr::map(
      get_zotero_sources("General/Dashboard Sources"),
      ~ htmltools::tags$li(htmltools::HTML(.x))
    )
  )
)

# Example output format:
# "John Smith Jane Doe. Cancer Registration Statistics, 2023. Last accessed September, 2024."
# "Unknown Author. <a href='https://example.com'>Untitled</a>, 2022. Last accessed October, 2024."
} # }
```
