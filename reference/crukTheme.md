# Apply CRUK Brand Theme to Shiny Application

Adds Cancer Research UK branding and styling to a Shiny application by
loading the CRUK CSS theme file. This function should be called within
the UI definition, typically inside `tags$head()`, to apply consistent
CRUK styling across the entire application.

## Usage

``` r
crukTheme()
```

## Value

An
[`htmltools::tagList`](https://rstudio.github.io/htmltools/reference/tagList.html)
containing an `htmlDependency` object that loads the CRUK theme CSS file
(`crukTheme.css`) from the package's `www/css/` directory.

## CSS Dependency

This function creates an HTML dependency that: Loads `crukTheme.css`
from `inst/www/css/` in the shinyCRUK package. Is versioned according to
the shinyCRUK package version. Sets up the resource path for other CRUK
assets (logos, images, etc.)

## Usage Pattern

This function is typically used in the UI definition of a Shiny app,
placed within `tags$head()` to ensure the CSS loads before the page
renders. It should be used in conjunction with
[`crukNavTitle`](https://verbose-guacamole-l18vr83.pages.github.io/reference/crukNavTitle.md)
and other shinyCRUK components for complete CRUK branding.

## See also

[`crukNavTitle`](https://verbose-guacamole-l18vr83.pages.github.io/reference/crukNavTitle.md)
for creating a CRUK-branded navigation bar

## Examples

``` r
if (FALSE) { # \dontrun{
# Basic usage in Shiny UI
ui <- fluidPage(
  tags$head(
    crukTheme()
  ),
  title = crukNavTitle(Title = "Cancer Stats Data Hub"),
  # ... rest of UI
)
} # }
```
