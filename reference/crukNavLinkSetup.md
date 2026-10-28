# Page Setup for crukNavLink

Loads the JavaScript helper used by
[`crukNavLink`](https://crukorg.github.io/shinyCRUK/reference/crukNavLink.md)
and calls
[`shinyjs::useShinyjs()`](https://rdrr.io/pkg/shinyjs/man/useShinyjs.html).
Place it once in the UI, for example in the `header` of
[`bslib::page_navbar()`](https://rstudio.github.io/bslib/reference/page_navbar.html).

## Usage

``` r
crukNavLinkSetup()
```

## Value

An
[`htmltools::tagList`](https://rstudio.github.io/htmltools/reference/tagList.html)
containing
[`shinyjs::useShinyjs()`](https://rdrr.io/pkg/shinyjs/man/useShinyjs.html)
and an `htmlDependency` that loads `javascript/scrollToDivWhenReady.js`
from the package's `www/` directory. The dependency is versioned
according to the shinyCRUK package version.

## See also

[`crukNavLink`](https://crukorg.github.io/shinyCRUK/reference/crukNavLink.md)

## Examples

``` r
if (FALSE) { # \dontrun{
bslib::page_navbar(
  id = "main_navbar",
  header = shiny::tagList(
    shiny::tags$head(crukTheme()),
    crukNavLinkSetup()
  )
)
} # }
```
