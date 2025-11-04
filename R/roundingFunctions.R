#' Round Numbers Following Cancer Intelligence Guidelines
#'
#' Formats numbers according to Cancer Intelligence rounding rules,
#' providing human-readable descriptions with appropriate precision levels based
#' on magnitude. Returns descriptive text like "around 1,200" or "more than 5,000".
#'
#' @param number Numeric vector of values to format. Can be integers or decimals.
#' @param case Character string specifying text case. Either "lower" (default)
#'   for lowercase or "upper" for sentence case output.
#'
#' @return Character vector of formatted number descriptions with thousand
#'   separators and descriptive qualifiers (around, nearly, more than, less than).
#'
#' @details
#' The function applies different rounding rules based on number magnitude:
#' \itemize{
#'   \item Numbers >= 100,000: Rounded to 3 significant figures with qualifiers
#'   \item Numbers >= 1,000: Rounded to nearest 100 with "around" prefix
#'   \item Numbers >= 100: Rounded to nearest 10 with "around" prefix
#'   \item Numbers >= 10: Rounded to nearest 5 with "around" prefix
#'   \item Numbers < 10: Simplified to "around 10", "around 5", or "less than 5"
#' }
#'
#' Special handling is applied to avoid ties at 0.5 boundaries by adding small
#' increments before rounding.
#'
#' @importFrom dplyr case_when
#'
#' @examples
#' crukRounding(1200)
#' # Returns: "around 1,200"
#'
#' crukRounding(1200, case = "upper")
#' # Returns: "Around 1,200"
#'
#' crukRounding(156789)
#' # Returns: "around 157,000"
#'
#' crukRounding(c(3, 25, 500, 5000, 50000))
#' # Returns vectorized output for multiple values
#'
#' crukRounding(999999)
#' # Returns: "around 1,000,000"
#'
#' @export
crukRounding <- function(number, case = "lower") {
  # Input validation
  if (!is.numeric(number) && !all(is.na(number))) {
    # Try to coerce to numeric
    number_converted <- suppressWarnings(as.numeric(number))
    if (all(is.na(number_converted) & !is.na(number))) {
      stop("`number` must be numeric or coercible to numeric")
    }
    number <- number_converted
  }

  # Convert to numeric if not already
  number <- as.numeric(number)

  # Warn about negative values
  if (any(number < 0, na.rm = TRUE)) {
    warning("Negative values detected. Results may not follow CRUK guidelines for negative numbers.")
  }

  # Error if case argument is mis-specified
  if (!case %in% c("lower", "upper")) {
    stop("`case` must be 'lower' or 'upper'")
  }

  # Apply rounding tweaks to avoid ties at 0.5 boundaries
  number <- dplyr::case_when(
    number >= 100000000 & number %% 1000000 == 500 ~ number + 1,
    number >= 10000000 & number %% 100000 == 500 ~ number + 1,
    number >= 1000000 & number %% 10000 == 500 ~ number + 1,
    number >= 100000 & number %% 1000 == 500 ~ number + 1,
    number >= 10000 & number %% 100 == 50 ~ number + 1,
    number >= 1000 & number %% 100 == 50 ~ number + 1,
    number >= 100 & number %% 10 == 5 ~ number + 0.01,
    number >= 10 & number %% 1 == 0.5 ~ number + 0.0001,
    TRUE ~ number
  )

  # Helper function to format numbers with thousand separators
  fmt <- function(x) {
    trimws(format(x, big.mark = ",", scientific = FALSE))
  }

  # Generate descriptive text based on magnitude and remainder
  numbertext <- dplyr::case_when(
    # 100+ million range
    number >= 100000000 & number %% 1000000 >= 900 ~
      paste0("around ", fmt(signif(number, 3))),
    number >= 100000000 & number %% 1000000 >= 700 ~
      paste0("nearly ", fmt(signif(number, 3))),
    number >= 100000000 & number %% 1000000 >= 200 ~
      paste0("more than ", fmt(signif(floor(number / 100000) * 100000, 3))),
    number >= 100000000 ~
      paste0("around ", fmt(signif(floor(number / 100000) * 100000, 3))),

    # 10+ million range
    number >= 10000000 & number %% 100000 >= 900 ~
      paste0("around ", fmt(signif(number, 3))),
    number >= 10000000 & number %% 100000 >= 700 ~
      paste0("nearly ", fmt(signif(number, 3))),
    number >= 10000000 & number %% 100000 >= 200 ~
      paste0("more than ", fmt(signif(floor(number / 100000) * 100000, 3))),
    number >= 10000000 ~
      paste0("around ", fmt(signif(floor(number / 100000) * 100000, 3))),

    # 1+ million range
    number >= 1000000 & number %% 10000 >= 900 ~
      paste0("around ", fmt(signif(number, 3))),
    number >= 1000000 & number %% 10000 >= 700 ~
      paste0("nearly ", fmt(signif(number, 3))),
    number >= 1000000 & number %% 10000 >= 200 ~
      paste0("more than ", fmt(signif(floor(number / 10000) * 10000, 3))),
    number >= 1000000 ~
      paste0("around ", fmt(signif(floor(number / 10000) * 10000, 3))),

    # 100k+ range
    number >= 100000 & number %% 1000 >= 900 ~
      paste0("around ", fmt(signif(number, 3))),
    number >= 100000 & number %% 1000 >= 700 ~
      paste0("nearly ", fmt(signif(number, 3))),
    number >= 100000 & number %% 1000 >= 200 ~
      paste0("more than ", fmt(signif(floor(number / 1000) * 1000, 3))),
    number >= 100000 ~
      paste0("around ", fmt(signif(floor(number / 1000) * 1000, 3))),

    # 10k+ range - round to nearest 100
    number >= 10000 ~
      paste0("around ", fmt(round(number / 100) * 100)),

    # 1k+ range - round to nearest 100
    number >= 1000 ~
      paste0("around ", fmt(round(number / 100) * 100)),

    # 100+ range - round to nearest 10
    number >= 100 ~
      paste0("around ", round(number / 10) * 10),

    # 10+ range - round to nearest 5
    number >= 10 ~
      paste0("around ", round(number / 5) * 5),

    # Small numbers
    number >= 7.5 ~ "around 10",
    number >= 5 ~ "around 5",

    # Default for very small numbers
    TRUE ~ "less than 5"
  )

  numbertext <- if(case == "upper") {
    paste0(
      substr(toupper(numbertext), 1, 1),
      substr(numbertext, 2, nchar(numbertext))
    )
  } else {
    numbertext
  }

return(numbertext)
}


#' Round and Format Percentages with Descriptive Text
#'
#' Converts numeric proportions (0-1) into human-readable text descriptions
#' following CRUK style guidelines. Provides intuitive phrases like "1 in 4"
#' alongside percentage values. If you're value is an integer%, make sure to
#' divide by 100 first.
#'
#' @param number Numeric vector of proportions between 0 and 1.
#' @param case Character string specifying text case. Either "lower" (default)
#'   for lowercase or "upper" for sentence case output.
#' @param digits Integer specifying number of decimal places for percentage
#'   display. Default is 3.
#'
#' @return Character vector of formatted percentage descriptions.
#'
#' @examples
#' crukRoundingPercentage(0.25)
#' # Returns: "1 in 4 (25%)"
#'
#' crukRoundingPercentage(0.33, digits = 2)
#' # Returns: "1 in 3 (33%)"
#'
#' crukRoundingPercentage(0.4567, case = "lower")
#' # Returns: "almost 1 in 2 (45.7%)"
#'
#' crukRoundingPercentage(0.4567, case = "upper")
#' # Returns: "Almost 1 in 2 (45.7%)"
#'
#' @export
crukRoundingPercentage <- function(number, case = "lower", digits = 3) {
  # Input validation
  if (!is.numeric(number) && !all(is.na(number))) {
    # Try to coerce to numeric
    number_converted <- suppressWarnings(as.numeric(number))

    if (all(is.na(number_converted) & !is.na(number))) {
      stop("`number` must be numeric or coercible to numeric")
    }
    number <- number_converted
  }

  if (!case %in% c("lower", "upper")) {
    stop("`case` must be either 'lower' or 'upper'")
  }

  if (!is.numeric(digits) || digits < 0) {
    stop("`digits` must be a non-negative number")
  }

  # Warn about out-of-range values
  if (any(number < 0 | number > 1, na.rm = TRUE)) {
    warning("Some values are outside the expected range [0, 1]")
  }

  # Pre-compute rounded values once for efficiency
  rounded_2 <- round(number, 2)
  rounded_digits <- round(number, digits)
  percentage_text <- rounded_digits * 100

  # Generate descriptive text
  Text <- dplyr::case_when(
    number <= 0.008 ~ "Less than 1%",
    rounded_2 < 0.02 ~ "Only 1 in 100",
    rounded_2 < 0.03 ~ "Only 2 in 100",
    rounded_2 < 0.04 ~ paste0("Almost 5 in 100 (", percentage_text, "%)"),
    rounded_2 < 0.05 ~ paste0("Around 5 in 100 (", percentage_text, "%)"),
    rounded_2 == 0.05 ~ paste0("5 in 100 (", percentage_text, "%)"),
    rounded_2 < 0.07 ~ paste0("Around 5 in 100 (", percentage_text, "%)"),
    rounded_2 < 0.08 ~ paste0("More than 5 in 100 (", percentage_text, "%)"),
    rounded_2 < 0.09 ~ paste0("Almost 1 in 10 (", percentage_text, "%)"),
    rounded_2 < 0.1 ~ paste0("Around 1 in 10 (", percentage_text, "%)"),
    rounded_2 == 0.1 ~ paste0("1 in 10 (", percentage_text, "%)"),
    rounded_2 < 0.12 ~ paste0("Around 1 in 10 (", percentage_text, "%)"),
    rounded_2 < 0.13 ~ paste0("More than 1 in 10 (", percentage_text, "%)"),
    rounded_2 < 0.14 ~ paste0("Almost 3 in 20 (", percentage_text, "%)"),
    rounded_2 < 0.15 ~ paste0("Around 3 in 20 (", percentage_text, "%)"),
    rounded_2 == 0.15 ~ paste0("3 in 20 (", percentage_text, "%)"),
    rounded_2 < 0.17 ~ paste0("Around 3 in 20 (", percentage_text, "%)"),
    rounded_2 < 0.18 ~ paste0("More than 3 in 20 (", percentage_text, "%)"),
    rounded_2 < 0.19 ~ paste0("Almost 1 in 5 (", percentage_text, "%)"),
    rounded_2 < 0.2 ~ paste0("Around 1 in 5 (", percentage_text, "%)"),
    rounded_2 == 0.2 ~ paste0("1 in 5 (", percentage_text, "%)"),
    rounded_2 < 0.22 ~ paste0("Around 1 in 5 (", percentage_text, "%)"),
    rounded_2 < 0.23 ~ paste0("More than 1 in 5 (", percentage_text, "%)"),
    rounded_2 < 0.24 ~ paste0("Almost 1 in 4 (", percentage_text, "%)"),
    rounded_2 < 0.25 ~ paste0("Around 1 in 4 (", percentage_text, "%)"),
    rounded_2 == 0.25 ~ paste0("1 in 4 (", percentage_text, "%)"),
    rounded_2 < 0.27 ~ paste0("Around 1 in 4 (", percentage_text, "%)"),
    rounded_2 < 0.29 ~ paste0("More than 1 in 4 (", percentage_text, "%)"),
    rounded_2 < 0.32 ~ paste0("Almost 1 in 3 (", percentage_text, "%)"),
    rounded_2 < 0.33 ~ paste0("Around 1 in 3 (", percentage_text, "%)"),
    rounded_2 == 0.33 ~ paste0("1 in 3 (", percentage_text, "%)"),
    rounded_2 < 0.35 ~ paste0("Around 1 in 3 (", percentage_text, "%)"),
    rounded_2 < 0.37 ~ paste0("More than 1 in 3 (", percentage_text, "%)"),
    rounded_2 < 0.39 ~ paste0("Almost 4 in 10 (", percentage_text, "%)"),
    rounded_2 < 0.4 ~ paste0("Around 4 in 10 (", percentage_text, "%)"),
    rounded_2 == 0.4 ~ paste0("4 in 10 (", percentage_text, "%)"),
    rounded_2 < 0.42 ~ paste0("Around 4 in 10 (", percentage_text, "%)"),
    rounded_2 < 0.45 ~ paste0("More than 4 in 10 (", percentage_text, "%)"),
    rounded_2 < 0.5 ~ paste0("Almost 1 in 2 (", percentage_text, "%)"),
    rounded_2 == 0.5 ~ paste0("1 in 2 (", percentage_text, "%)"),
    rounded_2 < 0.52 ~ paste0("Around 1 in 2 (", percentage_text, "%)"),
    rounded_2 < 0.55 ~ paste0("More than 1 in 2 (", percentage_text, "%)"),
    rounded_2 < 0.6 ~ paste0("Almost 6 in 10 (", percentage_text, "%)"),
    rounded_2 == 0.6 ~ paste0("6 in 10 (", percentage_text, "%)"),
    rounded_2 < 0.62 ~ paste0("Around 6 in 10 (", percentage_text, "%)"),
    rounded_2 < 0.63 ~ paste0("More than 6 in 10 (", percentage_text, "%)"),
    rounded_2 < 0.65 ~ paste0("Almost 2 in 3 (", percentage_text, "%)"),
    rounded_2 < 0.66 ~ paste0("Around 2 in 3 (", percentage_text, "%)"),
    rounded_2 == 0.66 ~ paste0("2 in 3 (", percentage_text, "%)"),
    rounded_2 < 0.68 ~ paste0("Around 2 in 3 (", percentage_text, "%)"),
    rounded_2 < 0.69 ~ paste0("More than 2 in 3 (", percentage_text, "%)"),
    rounded_2 < 0.7 ~ paste0("Around 7 in 10 (", percentage_text, "%)"),
    rounded_2 == 0.7 ~ paste0("7 in 10 (", percentage_text, "%)"),
    rounded_2 < 0.72 ~ paste0("Around 7 in 10 (", percentage_text, "%)"),
    rounded_2 < 0.73 ~ paste0("More than 7 in 10 (", percentage_text, "%)"),
    rounded_2 < 0.74 ~ paste0("Almost 3 in 4 (", percentage_text, "%)"),
    rounded_2 < 0.75 ~ paste0("Around 3 in 4 (", percentage_text, "%)"),
    rounded_2 == 0.75 ~ paste0("3 in 4 (", percentage_text, "%)"),
    rounded_2 < 0.77 ~ paste0("Around 3 in 4 (", percentage_text, "%)"),
    rounded_2 < 0.78 ~ paste0("More than 3 in 4 (", percentage_text, "%)"),
    rounded_2 < 0.79 ~ paste0("Almost 8 in 10 (", percentage_text, "%)"),
    rounded_2 < 0.80 ~ paste0("Around 8 in 10 (", percentage_text, "%)"),
    rounded_2 == 0.8 ~ paste0("8 in 10 (", percentage_text, "%)"),
    rounded_2 < 0.82 ~ paste0("Around 8 in 10 (", percentage_text, "%)"),
    rounded_2 < 0.85 ~ paste0("More than 8 in 10 (", percentage_text, "%)"),
    rounded_2 < 0.89 ~ paste0("Almost 9 in 10 (", percentage_text, "%)"),
    rounded_2 < 0.9 ~ paste0("Around 9 in 10 (", percentage_text, "%)"),
    rounded_2 == 0.9 ~ paste0("9 in 10 (", percentage_text, "%)"),
    rounded_2 < 0.92 ~ paste0("Around 9 in 10 (", percentage_text, "%)"),
    rounded_2 < 0.98 ~ paste0("More than 9 in 10 (", percentage_text, "%)"),
    rounded_2 < 0.99 ~ paste0("Almost all (", percentage_text, "%)"),
    rounded_2 < 1 ~ paste0("Around all (", percentage_text, "%)"),
    rounded_2 == 1 ~ paste0("All (", percentage_text, "%)"),
    TRUE ~ "All"
  )

  # Apply case transformation
  if (case == "lower") {
    return(tolower(Text))
  } else {
    return(Text)
  }

}
