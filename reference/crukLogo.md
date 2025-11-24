# CRUK Stacked Logo

Returns the standard Cancer Research UK stacked logo as an SVG image
element. This is the primary CRUK logo format, featuring the logo mark
above the text. The logo is assigned the CSS class \`cruk-logo\` for
styling purposes.

## Usage

``` r
crukLogo(height = "50px", width = "auto", class = "")
```

## Arguments

- height:

  Character string specifying the logo height. Must be a valid CSS

- width:

  Character string specifying the logo width. Must be a valid CSS unit.
  Default is "auto" to maintain aspect ratio. Note: Specifying both
  height and width may distort the logo if the aspect ratio doesn't
  match the original.

- class:

  Character string or character vector of additional CSS class names to
  apply to the logo element. If providing multiple classes, use a
  character vector: \`c("class1", "class2")\`. These are added alongside
  the default \`"cruk-logo"\` class. Default is an empty string.

## Value

An \`htmltools::tags\$img\` element containing the CRUK stacked logo SVG
with the specified dimensions and CSS classes.

## Logo Details

Format: SVG (Scalable Vector Graphics) Orientation: Cancer Research UK
over 3 lines Default class: \`"cruk-logo"\` File location:
\`inst/www/images/cruk-logo.svg\`

## Usage Guidelines

This is the preferred CRUK logo format for most use cases. Use
\[crukLogoWide()\] only when vertical space is limited or when the
stacked format doesn't fit the layout requirements.

## See also

\[crukLogoWide\] for the wide version of the CRUK logo

## Examples

``` r
# Basic usage with default size (50px height)
crukLogo()
#> <img src="shinyCRUK/images/cruk-logo.svg" class="cruk-logo " style="height: 50px; width: auto;" alt="Cancer Research UK logo"/>

# Custom height
crukLogo(height = "75px")
#> <img src="shinyCRUK/images/cruk-logo.svg" class="cruk-logo " style="height: 75px; width: auto;" alt="Cancer Research UK logo"/>

# Custom height and width (use carefully to avoid distortion)
crukLogo(height = "60px", width = "60px")
#> <img src="shinyCRUK/images/cruk-logo.svg" class="cruk-logo " style="height: 60px; width: 60px;" alt="Cancer Research UK logo"/>

# Add custom CSS classes
crukLogo(class = "my-custom-class")
#> <img src="shinyCRUK/images/cruk-logo.svg" class="cruk-logo my-custom-class" style="height: 50px; width: auto;" alt="Cancer Research UK logo"/>

# Multiple custom classes
crukLogo(height = "100px", class = c("logo-header", "fade-in"))
#> <img src="shinyCRUK/images/cruk-logo.svg" class="cruk-logo logo-header cruk-logo fade-in" style="height: 100px; width: auto;" alt="Cancer Research UK logo"/>

# Using CSS units other than pixels
crukLogo(height = "5rem")
#> <img src="shinyCRUK/images/cruk-logo.svg" class="cruk-logo " style="height: 5rem; width: auto;" alt="Cancer Research UK logo"/>
crukLogo(height = "10vh")
#> <img src="shinyCRUK/images/cruk-logo.svg" class="cruk-logo " style="height: 10vh; width: auto;" alt="Cancer Research UK logo"/>
```
