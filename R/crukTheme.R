#' CRUK Theme
#'
#' @param selectors TRUE/FALSE whether the navbar includes selectors
#'
#' @returns Adds CRUK themeing via CSS
#' @export
#'
#' @examples
#' htmltools::tags$head(
#'   crukTheme()
#' )
crukTheme <- function(selectors = FALSE) {
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
