# CRUK Google analytics and cookie banner

Adds the necessary html and javascript to enable google analytics in a
shiny app, along with the necessary cookie banner. The app should also
include the crukFooter() that includes a link to our cookies policy
page. The function should be called within the head html element of a
shiny app.

## Usage

``` r
crukGA()
```

## Value

Adds google analytics to a shiny dashboard along with the necessary
cookie banner

## Examples

``` r
htmltools::tags$head(
  crukGA()
)
#> 
```
