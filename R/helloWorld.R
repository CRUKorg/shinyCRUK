#' CRUK Hello World
#'
#' Writes Hello World, with optional exclamation mark
#'
#' @param exclamation Additional text to append to "Hello World". Defaults to an exclamation mark
#'
#' @returns Some text
#' @export
#'
#' @examples
#' \dontrun{
#' HelloWorld(
#'
#' )
#'
#' }

HelloWorld <- function(exclamation = "!") {
  text <- "Hello World"
  text <- paste0(text, exclamation)
  print(text)
}
