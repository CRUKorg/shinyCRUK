#' CRUK logo
#'
#' Returns the standard CRUK logo as a svg, with the css class "cruk-logo". By default the height is set to 50px, but you can specify a width or height.
#'
#' @param height The height of the logo, default is 50px. Must be a valid css unit.
#' @param width The width of the logo, may not work unless a height is specified too. Must be a valid css unit.
#'
#' @returns The CRUK stacked logo as a .svg
#' @export
#'
#' @examples
#' crukLogo()
crukLogo <- function(height = "50px", width = "auto") {
  #Add filepath for logo
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
    class = "cruk-logo",
    style = glue::glue("height: {height}; width: {width};")
  )
}

#' CRUK logo wide
#'
#' This function returns the wide version of the CRUK logo with the css class "cruk-logo-wide". Use sparingly and only when stacked logo doesn't work.
#'
#' By default the height is set to 50px, but you can specify a width or height.
#'
#' @param height The height of the logo, default is 50px. Must be a valid css unit.
#' @param width The width of the logo, may not work unless a height is specified too. Must be a valid css unit.
#'
#' @returns A wide version of the CRUK as a .png.
#' @export
#'
#' @examples
#' crukLogoWide()
crukLogoWide <- function(height = "50px", width = "auto") {
  #Add filepath for logo
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
    class = "cruk-logo-wide",
    style = glue::glue("height: {height}; width: {width};")
  )
}
