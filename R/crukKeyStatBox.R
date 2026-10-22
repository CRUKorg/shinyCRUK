#' Key statistic box
#'
#' A bordered box containing a key statement and, optionally, an image. The
#' image sits to the left of the statement when there is room, and above it
#' otherwise.
#'
#' @param statement A single character string, or a Shiny output such as
#'   [shiny::textOutput()] or [shiny::uiOutput()].
#' @param image Optional. File name of an image in the app's `www` folder, e.g.
#'   `"magnifying-glass.svg"`. Displayed at 140px by 140px. Defaults to `NULL`
#'   (no image).
#'
#' @return A [htmltools::tag] object.
#' @export
#'
#' @examples
#' crukKeyStatBox("Nearly 1 in 2 of us will get cancer in our lifetimes.")
#' crukKeyStatBox("A statement", image = "magnifying-glass.svg")
crukKeyStatBox <- function(statement, image = NULL) {
  is_tag <- inherits(statement, c("shiny.tag", "shiny.tag.list"))
  is_string <- is.character(statement) && length(statement) == 1 && !is.na(statement)

  if (!is_tag && !is_string) {
    rlang::abort(
      "`statement` must be a single character string, or a shiny tag such as `textOutput()` or `uiOutput()`."
    )
  }

  if (!is.null(image) &&
      !(is.character(image) && length(image) == 1 && !is.na(image))) {
    rlang::abort("`image` must be `NULL` or a single file name in the app's `www` folder.")
  }

  image_tag <- if (!is.null(image)) {
    htmltools::tags$img(
      src = image,
      alt = "",
      class = "cruk-key-stat-box__image"
    )
  }

  box <- htmltools::div(
    class = "cruk-key-stat-box",
    htmltools::div(
      class = "cruk-key-stat-box__box",
      image_tag, # NULL is dropped by htmltools
      htmltools::div(class = "cruk-key-stat-box__statement", statement)
    )
  )

  htmltools::attachDependencies(
    box,
    htmltools::htmlDependency(
      name = "crukKeyStatBox",
      version = get_pkg_version(),
      src = "www",
      package = "shinyCRUK",
      stylesheet = "css/crukKeyStatBox.css",
      all_files = TRUE
    )
  )
}
