#' CRUK HTML dependency
#'
#' Attaches CSS resources for shinyCRUK components
#'
#' @return An htmlDependency object
#' @keywords internal
crukCSSDependency <- function() {
  htmltools::htmlDependency(
    name = "shinyCRUK",
    version = utils::packageVersion("shinyCRUK"),
    src = "www",
    package = "shinyCRUK",
    stylesheet = "css/styles.css",
    all_files = TRUE
  )
}


