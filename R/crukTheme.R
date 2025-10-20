#' Apply CRUK Brand Theme to Shiny Application
#'
#' Adds Cancer Research UK branding and styling to a Shiny application by loading
#' the CRUK CSS theme file. This function should be called within the UI definition,
#' typically inside \code{tags$head()}, to apply consistent CRUK styling across
#' the entire application.
#'
#' @return An \code{htmltools::tagList} containing an \code{htmlDependency} object
#'   that loads the CRUK theme CSS file (\code{crukTheme.css}) from the package's
#'   \code{www/css/} directory.
#'
#' @section CSS Dependency:
#' This function creates an HTML dependency that:
#' Loads \code{crukTheme.css} from \code{inst/www/css/} in the shinyCRUK package.
#' Is versioned according to the shinyCRUK package version.
#' Sets up the resource path for other CRUK assets (logos, images, etc.)
#'
#' @section Usage Pattern:
#' This function is typically used in the UI definition of a Shiny app, placed
#' within \code{tags$head()} to ensure the CSS loads before the page renders.
#' It should be used in conjunction with \code{\link{crukNavTitle}} and other
#' shinyCRUK components for complete CRUK branding.
#'
#' @seealso \code{\link{crukNavTitle}} for creating a CRUK-branded navigation bar
#'
#' @examples
#' \dontrun{
#' # Basic usage in Shiny UI
#' ui <- fluidPage(
#'   tags$head(
#'     crukTheme()
#'   ),
#'   title = crukNavTitle(Title = "Cancer Stats Data Hub"),
#'   # ... rest of UI
#' )
#' }
#'
#' @export
crukTheme <- function() {
  shiny::addResourcePath(
    prefix = "shinyCRUK",
    directoryPath = system.file("www", package = "shinyCRUK")
  )
  htmltools::tagList(
    # Add css theme to whole app
    htmltools::htmlDependency(
      name = "crukTheme",
      version = utils::packageVersion("shinyCRUK"),
      src = "www",
      package = "shinyCRUK",
      stylesheet = "css/crukTheme.css",
      all_files = TRUE
    )
  )
}
