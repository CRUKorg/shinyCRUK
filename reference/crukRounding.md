# Round Numbers Following Cancer Intelligence Guidelines

Formats numbers according to Cancer Intelligence rounding rules,
providing human-readable descriptions with appropriate precision levels
based on magnitude. Returns descriptive text like "around 1,200" or
"more than 5,000".

## Usage

``` r
crukRounding(number, case = "lower")
```

## Arguments

- number:

  Numeric vector of values to format. Can be integers or decimals.

- case:

  Character string specifying text case. Either "lower" (default) for
  lowercase or "upper" for sentence case output.

## Value

Character vector of formatted number descriptions with thousand
separators and descriptive qualifiers (around, nearly, more than, less
than).

## Details

The function applies different rounding rules based on number magnitude:

- Numbers \>= 100,000: Rounded to 3 significant figures with qualifiers

- Numbers \>= 1,000: Rounded to nearest 100 with "around" prefix

- Numbers \>= 100: Rounded to nearest 10 with "around" prefix

- Numbers \>= 10: Rounded to nearest 5 with "around" prefix

- Numbers \< 10: Simplified to "around 10", "around 5", or "less than 5"

Special handling is applied to avoid ties at 0.5 boundaries by adding
small increments before rounding.

## Examples

``` r
crukRounding(1200)
#> [1] "around 1,200"
# Returns: "around 1,200"

crukRounding(1200, case = "upper")
#> [1] "Around 1,200"
# Returns: "Around 1,200"

crukRounding(156789)
#> [1] "nearly 157,000"
# Returns: "around 157,000"

crukRounding(c(3, 25, 500, 5000, 50000))
#> [1] "less than 5"   "around 25"     "around 500"    "around 5,000" 
#> [5] "around 50,000"
# Returns vectorized output for multiple values

crukRounding(999999)
#> [1] "around 1,000,000"
# Returns: "around 1,000,000"
```
