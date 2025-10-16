#' Central column div
#'
#' @param ...
#'
#' @returns A div that produces a responsive central column of 900px
#' @export
#'
#' @examples
#' centralColumn(
#'   crukTitle("Page title")
#' )
centralColumn <- function(...) {
  content <- list(...)

  htmltools::tagList(
    # Call the css that contains the media queries
    htmltools::htmlDependency(
      name = "centralColumn",
      version = utils::packageVersion("shinyCRUK"),
      src = "www",
      package = "shinyCRUK",
      stylesheet = "css/centralColumn.css",
      all_files = TRUE
    ),
    # Create the div
    htmltools::div(
      class = "central-column",
      content
    )
  )
}
