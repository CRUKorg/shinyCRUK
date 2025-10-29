.onLoad <- function(libname, pkgname) {
  shiny::addResourcePath(
    prefix = "shinyCRUK",
    directoryPath = system.file("www", package = "shinyCRUK")
  )
}

.onUnload <- function(libname, pkgname) {
  shiny::removeResourcePath("shinyCRUK")
}

#' Get package version from DESCRIPTION file
#'
#' @keywords internal
#' @noRd
get_pkg_version <- function() {
  desc_file <- system.file("DESCRIPTION", package = "shinyCRUK")
  if (file.exists(desc_file)) {
    desc <- read.dcf(desc_file)
    return(as.character(desc[1, "Version"]))
  }
  "0.1.0"  # Fallback only if DESCRIPTION missing
}
