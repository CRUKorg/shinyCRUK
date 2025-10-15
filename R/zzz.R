.onLoad <- function(libname, pkgname) {
  shiny::addResourcePath(
    prefix = "shinyCRUK",
    directoryPath = system.file("www", package = "shinyCRUK")
  )
}

.onUnload <- function(libname, pkgname) {
  shiny::removeResourcePath("shinyCRUK")
}
