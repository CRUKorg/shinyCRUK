# Round and Format Percentages with Descriptive Text

Converts numeric proportions (0-1) into human-readable text descriptions
following CRUK style guidelines. Provides intuitive phrases like "1 in
4" alongside percentage values. If you're value is an integer divide by
100 first.

## Usage

``` r
crukRoundingPercentage(number, case = "lower", digits = 3)
```

## Arguments

- number:

  Numeric vector of proportions between 0 and 1.

- case:

  Character string specifying text case. Either "lower" (default) for
  lowercase or "upper" for sentence case output.

- digits:

  Integer specifying number of decimal places for percentage display.
  Default is 3.

## Value

Character vector of formatted percentage descriptions.

## Examples

``` r
crukRoundingPercentage(0.25)
#> [1] "1 in 4 (25%)"
# Returns: "1 in 4 (25%)"

crukRoundingPercentage(0.33, digits = 2)
#> [1] "1 in 3 (33%)"
# Returns: "1 in 3 (33%)"

crukRoundingPercentage(0.4567, case = "lower")
#> [1] "almost 1 in 2 (45.7%)"
# Returns: "almost 1 in 2 (45.7%)"

crukRoundingPercentage(0.4567, case = "upper")
#> [1] "Almost 1 in 2 (45.7%)"
# Returns: "Almost 1 in 2 (45.7%)"
```
