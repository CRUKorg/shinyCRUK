# CRUK-branded Navigation Title

Themes the navigation bar with the CRUK logo. Accomodates mobile layout
and up to two selectors

## Usage

``` r
crukNavTitle(
  Title = "",
  title_width = 155,
  selectors = 0,
  selector1 = NULL,
  selector2 = NULL
)
```

## Arguments

- Title:

  Character string. The title text to display in the navigation bar. Can
  include HTML markup. Default is an empty string.

- title_width:

  Numeric. Width in pixels of title. Defaults to 155.

- selectors:

  Integer (0, 1, or 2). The number of selector elements to include in
  the navigation bar. This determines the responsive layout behavior:

  - 0: Simple layout with title and stacked logo

  - 1: Layout with title, one selector, and responsive logo switching

  - 2: Layout with title, two selectors, and responsive logo switching

  Default is 0.

- selector1:

  Shiny UI element or NULL. The first selector to display in the
  navigation bar. Only used when `selectors >= 1`. Typically a
  [`selectInput()`](https://rdrr.io/pkg/shiny/man/selectInput.html),
  [`pickerInput()`](https://dreamrs.github.io/shinyWidgets/reference/pickerInput.html),
  or similar input element. Default is NULL.

- selector2:

  Shiny UI element or NULL. The second selector to display in the
  navigation bar. Only used when `selectors == 2`. Typically a
  [`selectInput()`](https://rdrr.io/pkg/shiny/man/selectInput.html),
  [`pickerInput()`](https://dreamrs.github.io/shinyWidgets/reference/pickerInput.html),
  or similar input element. Default is NULL.

## Value

An
[`htmltools::tagList`](https://rstudio.github.io/htmltools/reference/tagList.html)
containing the styled navigation bar with embedded CSS for responsive
behavior.

## Responsive Behavior

The function creates different layouts based on screen width:

- Mobile (\< 992px):

  Vertical layout with stacked logo (50px height), full-width selectors
  stacked below the title

- Desktop (\>= 992px):

  Horizontal layout with wide logo (35px or 70px height), selectors
  positioned alongside title (400px width each)

## Action Link

The title is wrapped in an `actionLink` with id `"app_title_link"`,
allowing you to observe clicks with
`observeEvent(input$app_title_link, ...)`.

## Dependencies

Requires the shinyCRUK package with logo assets in `inst/www/images/`:

- `cruk-logo.svg` - Stacked logo for mobile view

- `cruk-logo-wide.png` - Wide logo for desktop view

## Examples

``` r
if (FALSE) { # \dontrun{
# Simple navigation with no selectors
crukNavTitle(Title = "Local Stats Data Hub")

# Navigation with one selector
crukNavTitle(
  Title = "Data Explorer",
  selectors = 1,
  selector1 = selectInput("dataset", "Choose dataset:", choices = c("A", "B"))
)

# Navigation with two selectors
crukNavTitle(
  Title = "Analysis Dashboard",
  selectors = 2,
  selector1 = selectInput("year", "Year:", choices = 2020:2024),
  selector2 = selectInput("cancer-site", "Cancer site:",
    choices = c("All cancers", "Breast", "Bowel", "Lung", "Prostate")
  )
)
} # }
```
