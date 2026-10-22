# Key statistic box

A bordered box containing a key statement and, optionally, an image. The
image sits to the left of the statement when there is room, and above it
otherwise.

## Usage

``` r
crukKeyStatBox(statement, image = NULL)
```

## Arguments

- statement:

  A single character string, or a Shiny output such as
  [`shiny::textOutput()`](https://rdrr.io/pkg/shiny/man/textOutput.html)
  or
  [`shiny::uiOutput()`](https://rdrr.io/pkg/shiny/man/htmlOutput.html).

- image:

  Optional. File name of an image in the app's `www` folder, e.g.
  `"magnifying-glass.svg"`. Displayed at 140px by 140px. Defaults to
  `NULL` (no image).

## Value

A
[htmltools::tag](https://rstudio.github.io/htmltools/reference/builder.html)
object.

## Examples

``` r
crukKeyStatBox("Nearly 1 in 2 of us will get cancer in our lifetimes.")
#> <div class="cruk-key-stat-box">
#>   <div class="cruk-key-stat-box__box">
#>     <div class="cruk-key-stat-box__statement">Nearly 1 in 2 of us will get cancer in our lifetimes.</div>
#>   </div>
#> </div>
crukKeyStatBox("A statement", image = "magnifying-glass.svg")
#> <div class="cruk-key-stat-box">
#>   <div class="cruk-key-stat-box__box">
#>     <img src="magnifying-glass.svg" alt="" class="cruk-key-stat-box__image"/>
#>     <div class="cruk-key-stat-box__statement">A statement</div>
#>   </div>
#> </div>
```
