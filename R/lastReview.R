#' Last Reviewed Date with Optional Audience Tag
#'
#' Displays the last review date for page content with an optional audience tag
#' (Health Professionals or Internal Only). This component helps users understand
#' the currency of the information and its intended audience.
#'
#' The review date appears right-aligned in a flex container, with the optional
#' tag appearing on the left. The component is typically placed at the top of
#' page content to provide context about data freshness and access restrictions.
#'
#' @param last_review_date Character string or Date object. The date when the
#'   page or content was last reviewed. Must be in the format "DD Month YYYY"
#'   (e.g., "08 July 2025") or a Date object which will be automatically
#'   converted to this format. Required.
#' @param tag Character string or NULL. The audience tag to display. Options are:
#'   \itemize{
#'     \item \code{"health_professional"} or \code{"hp"} - Blue tag for health
#'       professional content
#'     \item \code{"internal"} - Pink tag for internal-only content
#'     \item \code{NULL} (default) - No tag, shows only the review date
#'   }
#'
#' @return An \code{htmltools::div} element containing:
#'   \itemize{
#'     \item Optional audience tag (if specified) with appropriate styling
#'     \item Last reviewed date right-aligned in format "DD Month YYYY"
#'     \item CSS dependency for styling
#'   }
#'
#' @section Date Format:
#' The function enforces a consistent date format: "DD Month YYYY" (e.g.,
#' "08 July 2025", "01 January 2024"). You can provide:
#' \itemize{
#'   \item A character string already in "DD Month YYYY" format
#'   \item A UK date string in "DD/MM/YYYY" format (e.g., "08/07/2025")
#'   \item A Date object (e.g., \code{as.Date("2025-07-08")}) which will be
#'     automatically formatted
#'   \item An ISO date string (e.g., "2025-07-08") which will be parsed and
#'     formatted
#' }
#' Invalid formats will produce an error with guidance on the expected format.
#'
#' This function will take UK date format (DD/MM/YYYY), I.e. "08/07/2025" as
#' 8th July 2025, not 7th August 2025 (US format). You may want to double check
#' the format of your data frame.
#'
#' @section Tag Styles:
#' \describe{
#'   \item{Health Professional}{
#'     \itemize{
#'       \item Background: Light blue (#e2f4fd)
#'       \item Text: Blue-grey (#52627a)
#'       \item Label: "Health professionals"
#'     }
#'   }
#'   \item{Internal Only}{
#'     \itemize{
#'       \item Background: Light pink (#fff0f8)
#'       \item Text: Pink (#cc006c)
#'       \item Label: "Internal only"
#'     }
#'   }
#' }
#'
#' @section Placement:
#' Place this component at the top of page content, typically immediately after
#' \code{\link{crukTitle}} or as the first element within \code{\link{centralColumn}}.
#'
#' @seealso
#' \code{\link{crukTitle}} for page titles
#' \code{\link{centralColumn}} for the main content container
#'
#' @examples
#' # Correct format - character string
#' \dontrun{
#' lastReview("08 July 2025")
#' lastReview("01 January 2024", tag = "internal")
#'
#' # UK date format (DD/MM/YYYY)
#' lastReview("08/07/2025") # 8th July 2025
#' lastReview("15/03/2024", tag = "hp") # 15th March 2024
#' lastReview("1/1/2025", tag = "internal") # 1st January 2025
#'
#' # Using Date objects (automatically formatted)
#' lastReview(as.Date("2025-07-08"))
#' lastReview(Sys.Date(), tag = "hp")
#'
#' # Using ISO date strings (automatically formatted)
#' lastReview("2025-07-08", tag = "health_professional")
#'
#' # All of these produce: "Last reviewed: 08 July 2025"
#' lastReview("08 July 2025")
#' lastReview("08/07/2025")
#' lastReview(as.Date("2025-07-08"))
#' lastReview("2025-07-08")
#'
#' # These will produce errors:
#' lastReview("July 8, 2025") # Wrong format (US style)
#' lastReview("32/01/2025") # Invalid date (no 32nd day)
#' }
#'
#' @export
lastReview <- function(last_review_date, tag = NULL) {
  # Input validation
  if (missing(last_review_date)) {
    stop("Parameter 'last_review_date' is required")
  }

  # Format date to "DD Month YYYY"
  formatted_date <- format_review_date(last_review_date)

  # Validate tag parameter
  valid_tags <- c("health_professional", "hp", "internal")
  if (!is.null(tag) && !tag %in% valid_tags) {
    stop("Parameter 'tag' must be one of: 'health_professional', 'hp', 'internal', or NULL")
  }

  # Load CSS dependency
  css <- htmltools::htmlDependency(
    name = "lastReview",
    version = utils::packageVersion("shinyCRUK"),
    src = "www",
    package = "shinyCRUK",
    stylesheet = "css/lastReview.css",
    all_files = TRUE
  )

  # Determine tag content and class
  tag_element <- if (!is.null(tag)) {
    tag_class <- switch(tag,
      "health_professional" = "tag-health-professional",
      "hp" = "tag-health-professional",
      "internal" = "tag-internal"
    )

    tag_text <- switch(tag,
      "health_professional" = "Health professionals",
      "hp" = "Health professionals",
      "internal" = "Internal only"
    )

    htmltools::span(tag_text, class = paste("last-review-tag", tag_class))
  }

  # Create the component
  component <- htmltools::div(
    class = "last-review-container",
    tag_element,
    htmltools::div(class = "last-review-spacer"),
    htmltools::span(
      class = "last-review-date",
      "Last reviewed: ", formatted_date
    )
  )

  # Attach dependency and return
  htmltools::attachDependencies(component, css)
}

#' Format date to "DD Month YYYY" format
#'
#' Internal helper function to convert various date inputs to the standard
#' CRUK format "DD Month YYYY" (e.g., "08 July 2025").
#'
#' @param date A Date object, character string in ISO format (YYYY-MM-DD),
#'   UK format (DD/MM/YYYY), or character string already in "DD Month YYYY" format
#'
#' @return Character string in "DD Month YYYY" format
#' @keywords internal
#' @noRd
format_review_date <- function(date) {
  # If it's already a Date object
  if (inherits(date, "Date")) {
    return(format(date, "%d %B %Y"))
  }

  # If it's a character string
  if (is.character(date)) {
    # Check if it's already in the correct format "DD Month YYYY"
    pattern <- "^\\d{2} [A-Z][a-z]+ \\d{4}$"
    if (grepl(pattern, date)) {
      # Validate it's a real date
      tryCatch(
        {
          parsed <- as.Date(date, format = "%d %B %Y")
          if (is.na(parsed)) {
            stop("Invalid date")
          }
          return(date) # Return as-is if valid
        },
        error = function(e) {
          stop(
            "Date '", date, "' appears to be in DD Month YYYY format but is invalid. ",
            "Please check the date is correct (e.g., '08 July 2025')."
          )
        }
      )
    }

    # Check for UK date format DD/MM/YYYY
    uk_pattern <- "^\\d{1,2}/\\d{1,2}/\\d{4}$"
    if (grepl(uk_pattern, date)) {
      tryCatch(
        {
          parsed_date <- as.Date(date, format = "%d/%m/%Y")
          if (is.na(parsed_date)) {
            stop("Invalid date")
          }
          return(format(parsed_date, "%d %B %Y"))
        },
        error = function(e) {
          stop(
            "UK date format '", date, "' could not be parsed. ",
            "Please ensure the date is valid (e.g., '08/07/2025' for 8th July 2025)."
          )
        }
      )
    }

    # Try to parse as ISO format (YYYY-MM-DD or similar)
    tryCatch(
      {
        parsed_date <- as.Date(date)
        if (is.na(parsed_date)) {
          stop("Could not parse date")
        }
        return(format(parsed_date, "%d %B %Y"))
      },
      error = function(e) {
        stop(
          "Date must be in format 'DD Month YYYY' (e.g., '08 July 2025'), ",
          "UK format 'DD/MM/YYYY' (e.g., '08/07/2025'), ",
          "or a valid Date object. ",
          "Received: '", date, "'. "
        )
      }
    )
  }

  # If it's neither Date nor character
  stop(
    "Parameter 'last_review_date' must be a character string in format 'DD Month YYYY' ",
    "(e.g., '08 July 2025'), UK format 'DD/MM/YYYY' (e.g., '08/07/2025'), ",
    "or a Date object. ",
    "Received type: ", class(date)[1]
  )
}

# Convenience wrapper functions for backward compatibility
#' @rdname lastReview
#' @export
lastReviewHP <- function(last_review_date) {
  lastReview(last_review_date, tag = "health_professional")
}

#' @rdname lastReview
#' @export
lastReviewInternal <- function(last_review_date) {
  lastReview(last_review_date, tag = "internal")
}
