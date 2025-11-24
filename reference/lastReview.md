# Last Reviewed Date with Optional Audience Tag

Displays the last review date for page content with an optional audience
tag (Health Professionals or Internal Only). This component helps users
understand the currency of the information and its intended audience.

## Usage

``` r
lastReview(last_review_date, tag = NULL)

lastReviewHP(last_review_date)

lastReviewInternal(last_review_date)
```

## Arguments

- last_review_date:

  Character string or Date object. The date when the page or content was
  last reviewed. Must be in the format "DD Month YYYY" (e.g., "08 July
  2025") or a Date object which will be automatically converted to this
  format. Required.

- tag:

  Character string or NULL. The audience tag to display. Options are:

  - `"health professional"` or `"hp"` - Blue tag for health professional
    content

  - `"internal"` - Pink tag for internal-only content

  - `NULL` (default) - No tag, shows only the review date

## Value

An
[`htmltools::div`](https://rstudio.github.io/htmltools/reference/builder.html)
element containing:

- Optional audience tag (if specified) with appropriate styling

- Last reviewed date right-aligned in format "DD Month YYYY"

- CSS dependency for styling

## Details

The review date appears right-aligned in a flex container, with the
optional tag appearing on the left. The component is typically placed at
the top of page content to provide context about data freshness and
access restrictions.

## Date Format

The function enforces a consistent date format: "DD Month YYYY" (e.g.,
"08 July 2025", "01 January 2024"). You can provide:

- A character string already in "DD Month YYYY" format

- A UK date string in "DD/MM/YYYY" format (e.g., "08/07/2025")

- A Date object (e.g., `as.Date("2025-07-08")`) which will be
  automatically formatted

- An ISO date string (e.g., "2025-07-08") which will be parsed and
  formatted

Invalid formats will produce an error with guidance on the expected
format.

This function will take UK date format (DD/MM/YYYY), I.e. "08/07/2025"
as 8th July 2025, not 7th August 2025 (US format). You may want to
double check the format of your data frame.

## Tag Styles

- Health Professional:

  - Background: Light blue (#e2f4fd)

  - Text: Blue-grey (#52627a)

  - Label: "Health professionals"

- Internal Only:

  - Background: Light pink (#fff0f8)

  - Text: Pink (#cc006c)

  - Label: "Internal only"

## Placement

Place this component at the top of page content, typically immediately
after
[`crukTitle`](https://verbose-guacamole-l18vr83.pages.github.io/reference/crukTitle.md)
or as the first element within
[`centralColumn`](https://verbose-guacamole-l18vr83.pages.github.io/reference/centralColumn.md).

## See also

[`crukTitle`](https://verbose-guacamole-l18vr83.pages.github.io/reference/crukTitle.md)
for page titles
[`centralColumn`](https://verbose-guacamole-l18vr83.pages.github.io/reference/centralColumn.md)
for the main content container

## Examples

``` r
# Correct format - character string
if (FALSE) { # \dontrun{
lastReview("08 July 2025")
lastReview("01 January 2024", tag = "internal")

# UK date format (DD/MM/YYYY)
lastReview("08/07/2025") # 8th July 2025
lastReview("15/03/2024", tag = "hp") # 15th March 2024
lastReview("1/1/2025", tag = "internal") # 1st January 2025

# Using Date objects (automatically formatted)
lastReview(as.Date("2025-07-08"))
lastReview(Sys.Date(), tag = "hp")

# Using ISO date strings (automatically formatted)
lastReview("2025-07-08", tag = "health professional")

# All of these produce: "Last reviewed: 08 July 2025"
lastReview("08 July 2025")
lastReview("08/07/2025")
lastReview(as.Date("2025-07-08"))
lastReview("2025-07-08")

# These will produce errors:
lastReview("July 8, 2025") # Wrong format (US style)
lastReview("32/01/2025") # Invalid date (no 32nd day)
} # }
```
