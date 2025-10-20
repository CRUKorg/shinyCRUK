#' CRUK Stacked Logo
#'
#' Returns the standard Cancer Research UK stacked logo as an SVG image element.
#' This is the primary CRUK logo format, featuring the logo mark above the text.
#' The logo is assigned the CSS class `"cruk-logo"` for styling purposes.
#'
#' @param height Character string specifying the logo height. Must be a valid CSS
#' @param width Character string specifying the logo width. Must be a valid CSS
#'   unit. Default is "auto" to maintain aspect ratio. Note: Specifying both
#'   height and width may distort the logo if the aspect ratio doesn't match
#'   the original.
#' @param class Character string or character vector of additional CSS class names
#'   to apply to the logo element. If providing multiple classes, use a character
#'   vector: `c("class1", "class2")`. These are added alongside the default
#'   `"cruk-logo"` class. Default is an empty string.
#'
#' @return An `htmltools::tags$img` element containing the CRUK stacked logo
#'   SVG with the specified dimensions and CSS classes.
#'
#' @section Logo Details:
#'   Format: SVG (Scalable Vector Graphics)
#'   Orientation: Cancer Research UK over 3 lines
#'   Default class: `"cruk-logo"`
#'   File location: `inst/www/images/cruk-logo.svg`
#'
#'
#' @section Usage Guidelines:
#'   This is the preferred CRUK logo format for most use cases. Use
#'   [crukLogoWide()] only when vertical space is limited or when
#'   the stacked format doesn't fit the layout requirements.
#'
#' @seealso
#'   [crukLogoWide] for the wide version of the CRUK logo
#'
#' @examples
#'   # Basic usage with default size (50px height)
#'   crukLogo()
#'
#'   # Custom height
#'   crukLogo(height = "75px")
#'
#'   # Custom height and width (use carefully to avoid distortion)
#'   crukLogo(height = "60px", width = "60px")
#'
#'   # Add custom CSS classes
#'   crukLogo(class = "my-custom-class")
#'
#'   # Multiple custom classes
#'   crukLogo(height = "100px", class = c("logo-header", "fade-in"))
#'
#'   # Using CSS units other than pixels
#'   crukLogo(height = "5rem")
#'   crukLogo(height = "10vh")
#'
#' @export
crukLogo <- function(height = "50px", width = "auto", class = "") {
  # Add filepath for logo
  shiny::addResourcePath(
    prefix = "shinyCRUK",
    directoryPath = system.file("www", package = "shinyCRUK")
  )
  height <- htmltools::validateCssUnit(height)
  width <- htmltools::validateCssUnit(width)

  # Get paths for logos and text for reuse of content
  cruk_logo_path <- "shinyCRUK/images/cruk-logo.svg"

  htmltools::img(
    src = cruk_logo_path,
    class = paste("cruk-logo", class),
    style = glue::glue("height: {height}; width: {width};"),
    alt = "Cancer Research UK logo"
  )
}

#' CRUK Wide Logo
#'
#' Returns the wide (horizontal) version of the Cancer Research UK logo as a PNG
#' image element. The logo is assigned the CSS class `"cruk-logo-wide"` for
#' styling purposes.
#'
#' @param height Character string specifying the logo height. Must be a valid CSS
#'   unit (e.g., "50px", "3rem", "10\%"). Default is "50px".
#' @param width Character string specifying the logo width. Must be a valid CSS
#'   unit. Default is "auto" to maintain aspect ratio. Note: Specifying both
#'   height and width may distort the logo if the aspect ratio doesn't match
#'   the original.
#' @param class Character string or character vector of additional CSS class names
#'   to apply to the logo element. If providing multiple classes, use a character
#'   vector: `c("class1", "class2")`. These are added alongside the default
#'   `"cruk-logo-wide"` class. Default is an empty string.
#'
#' @return An `htmltools::tags$img` element containing the CRUK wide logo
#'   PNG with the specified dimensions and CSS classes.
#'
#' @section Logo Details:
#'   Format: PNG (Portable Network Graphics)
#'   Orientation: Wide (logo beside text)
#'   Default class: `"cruk-logo-wide"`
#'   File location: `inst/www/images/cruk-logo-wide.png`
#'
#' @section Usage Guidelines:
#'   Use this wide logo format **sparingly** and only when:
#'
#'   Horizontal space is constrained but vertical space is available
#'   The stacked logo ([crukLogo()]) doesn't fit the layout
#'   Designing for wide/landscape orientations (e.g., desktop navigation bars)
#'
#'   The stacked logo ([crukLogo()]) is the preferred format for most
#'   use cases per CRUK brand guidelines.
#'
#' @seealso
#'   [crukLogo()] for the standard stacked version of the CRUK logo (preferred)
#'
#' @examples
#'   # Basic usage with default size (50px height)
#'   crukLogoWide()
#'
#'   # Custom height for navigation bar
#'   crukLogoWide(height = "35px")
#'
#'   # Custom height and width
#'   crukLogoWide(height = "40px", width = "200px")
#'
#'   # Add custom CSS classes
#'   crukLogoWide(class = "navbar-logo")
#'
#'   # Multiple custom classes
#'   crukLogoWide(height = "45px", class = c("logo-desktop", "float-right"))
#'
#' @export
crukLogoWide <- function(height = "50px", width = "auto", class = "") {
  # Add filepath for logo
  shiny::addResourcePath(
    prefix = "shinyCRUK",
    directoryPath = system.file("www", package = "shinyCRUK")
  )
  height <- htmltools::validateCssUnit(height)
  width <- htmltools::validateCssUnit(width)

  # Get paths for logos and text for reuse of content
  cruk_logo_path <- "shinyCRUK/images/cruk-logo-wide.png"

  htmltools::img(
    src = cruk_logo_path,
    class = paste("cruk-logo-wide", class),
    style = glue::glue("height: {height}; width: {width};"),
    alt = "Cancer Research UK logo" # Add for accessibility
  )
}
