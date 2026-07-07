# Create "On This Page" Contents Box with Scroll-to-Top Button

Creates a styled navigation box that provides quick links to sections
within a page, along with a button that appears when scrolling to allows
users to return to the top of the page.

## Usage

``` r
onThisPage(..., include_top_button = TRUE)
```

## Arguments

- ...:

  Pairs of values where the first element is the div ID to link to and
  the second element is the display text for the link. Each pair should
  be provided as a vector \`c(id, text)\`. The div ID should be the
  heading of the content to link to can be provided with or without a
  leading \`#\`.

- include_top_button:

  Logical. Whether to include the scroll-to-top button that appears
  after scrolling down 200px. Default is \`TRUE\`.

## Value

A \`tagList\` containing the styled navigation box, Material Symbols
dependencies, and optionally the scroll-to-top button with its
JavaScript functionality.

## Details

The function creates two main components:

- A fixed navigation box with styled links to page sections

- A scroll-to-top button that appears when the user scrolls down more
  than 200px and smoothly returns them to the top when clicked

The function automatically includes:

- CSS styling from \`css/onThisPage.css\`

- Google Material Symbols Sharp font for icons

- JavaScript for scroll detection and smooth scrolling behavior

## Examples

``` r
if (FALSE) { # \dontrun{
# In your Shiny UI
ui <- fluidPage(
  onThisPage(
    c("introduction", "Introduction"),
    c("methods", "Methods"),
    c("results", "Results"),
    c("conclusion", "Conclusion")
  ),

  # Your page content with matching IDs
  div(id = "introduction", h2("Introduction"), p("...")),
  div(id = "methods", h2("Methods"), p("...")),
  div(id = "results", h2("Results"), p("...")),
  div(id = "conclusion", h2("Conclusion"), p("..."))
)

# Without the scroll-to-top button
onThisPage(
  c("section1", "First Section"),
  c("section2", "Second Section"),
  include_top_button = FALSE
)
} # }
```
