#' CRUK logo
#'
#' @returns The CRUK stacked logo as a .svg
#' @export
#'
#' @examples
#' crukLogo()
crukLogo <- function() {
  #Add filepath for logo
  shiny::addResourcePath(
    prefix = "shinyCRUK",
    directoryPath = system.file("www", package = "shinyCRUK")
  )

  # Get paths for logos and text for reuse of content
  cruk_logo_path <- "shinyCRUK/images/cruk-logo.svg"
  htmltools::img(
    src = cruk_logo_path,
    class = "cruk-logo-footer",
  )
}

#' CRUK logo wide
#'
#' @returns A wide version of the CRUK as a .svg. Use sparingly and only when stacked logo doesn't work
#' @export
#'
#' @examples
#' crukLogoWide()
crukLogoWide <- function() {
  #Add filepath for logo
  shiny::addResourcePath(
    prefix = "shinyCRUK",
    directoryPath = system.file("www", package = "shinyCRUK")
  )

  # Get paths for logos and text for reuse of content
  cruk_logo_path <- "shinyCRUK/images/cruk-logo.svg"
  htmltools::img(
    src = cruk_logo_path,
    class = "cruk-logo-footer",
  )
}
