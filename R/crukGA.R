#' CRUK Google analytics and cookie banner
#'
#' Adds the necessary html and javascript to enable google analytics in a shiny app, along with the necessary cookie banner. The app should also include the crukFooter() that includes a link to our cookies policy page. The function should be called within the head html element of a shiny app.
#'
#' @returns Adds google analytics to a shiny dashboard along with the necessary cookie banner
#' @export
#'
#' @examples
#' htmltools::tags$head(
#'   crukGA()
#' )
crukGA <- function() {
  #Check if being run locally, if not activate analytics
  if (!interactive()) {
    analytics_script <- system.file("www", "ga-code.html", package = "shinyCRUK", mustWork = TRUE)
    htmltools::includeHTML(analytics_script)
  }
}
