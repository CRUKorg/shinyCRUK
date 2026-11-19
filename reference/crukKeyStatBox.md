# Key statistic box

A bordered box containing a key statement and, optionally, an image. The
image sits to the left of the statement when there is room, and above it
otherwise. The image and the statement are both aligned to the top of
the box.

## Usage

``` r
crukKeyStatBox(
  statement,
  image = "shinyCRUK/images/CI-logo-no-text.svg",
  showImage = TRUE,
  boxColour = "#bbc7d9"
)
```

## Arguments

- statement:

  A single character string, or a Shiny output such as
  [`shiny::textOutput()`](https://rdrr.io/pkg/shiny/man/textOutput.html)
  or
  [`shiny::uiOutput()`](https://rdrr.io/pkg/shiny/man/htmlOutput.html).

- image:

  Optional. The `src` of the image to show: either a file name in the
  app's `www` folder, e.g. `"magnifying-glass.svg"`, or a path served by
  a registered resource path. Displayed 140px wide, with its aspect
  ratio kept and a maximum height of 140px, aligned to the top left.
  Defaults to the Cancer Research UK logo mark shipped with this
  package. `NULL` means no image.

- showImage:

  `TRUE` (the default) to show `image`, `FALSE` to hide it.

- boxColour:

  Colour of the box border, as a hex code (`"#RRGGBB"` or `"#RGB"`,
  case-insensitive; the leading `#` is required). Defaults to
  `"#bbc7d9"` (CRUK grey). A warning is given if the colour is not one
  of the CRUK brand colours: black `#000000`; cyan `#009CEE`, `#BCE4FA`,
  `#5BC5F2`; magenta `#E60078`, `#E60079`, `#F8C9DF`, `#F088B6`; navy
  `#00007E`, `#CCCCE6`, `#6666B2`; grey `#BBC7D9`, `#C6C6C6`, `#878787`.

## Value

A
[htmltools::tag](https://rstudio.github.io/htmltools/reference/builder.html)
object.

## Examples

``` r
crukKeyStatBox("Nearly 1 in 2 of us will get cancer in our lifetimes.")
#> <div class="cruk-key-stat-box">
#>   <div class="cruk-key-stat-box__box" style="--cruk-key-stat-box-colour: #BBC7D9;">
#>     <img src="shinyCRUK/images/CI-logo-no-text.svg" alt="" class="cruk-key-stat-box__image"/>
#>     <div class="cruk-key-stat-box__statement">Nearly 1 in 2 of us will get cancer in our lifetimes.</div>
#>   </div>
#> </div>
crukKeyStatBox("A statement", image = "magnifying-glass.svg")
#> <div class="cruk-key-stat-box">
#>   <div class="cruk-key-stat-box__box" style="--cruk-key-stat-box-colour: #BBC7D9;">
#>     <img src="magnifying-glass.svg" alt="" class="cruk-key-stat-box__image"/>
#>     <div class="cruk-key-stat-box__statement">A statement</div>
#>   </div>
#> </div>
crukKeyStatBox("No image here", showImage = FALSE)
#> <div class="cruk-key-stat-box">
#>   <div class="cruk-key-stat-box__box" style="--cruk-key-stat-box-colour: #BBC7D9;">
#>     <div class="cruk-key-stat-box__statement">No image here</div>
#>   </div>
#> </div>
crukKeyStatBox("A navy box", boxColour = "#00007e")
#> <div class="cruk-key-stat-box">
#>   <div class="cruk-key-stat-box__box" style="--cruk-key-stat-box-colour: #00007E;">
#>     <img src="shinyCRUK/images/CI-logo-no-text.svg" alt="" class="cruk-key-stat-box__image"/>
#>     <div class="cruk-key-stat-box__statement">A navy box</div>
#>   </div>
#> </div>
```
