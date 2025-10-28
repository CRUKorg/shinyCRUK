#' Title
#'
#' @returns
#' @export
#'
#' @examples
ciBox <- function(boxBorder = TRUE) {
  shiny::addResourcePath(
    prefix = "shinyCRUK",
    directoryPath = system.file("www", package = "shinyCRUK")
  )

  ci_logo_path <- "shinyCRUK/images/CI-logo.svg"

  css <- htmltools::htmlDependency(
    name = "ciBox",
    version = utils::packageVersion("shinyCRUK"),
    src = "www",
    package = "shinyCRUK",
    stylesheet = "css/ciBox.css",
    all_files = TRUE
  )

  ciBox <- htmltools::div(class = "ci-box",
                          style = if(boxBorder) {"border: 1px solid black;"},
                          htmltools::div(class = "ci-logo",
                                         htmltools::tags$img(src = ci_logo_path)),
                          htmltools::div(class = "ci-child",
                              htmltools::p(class = "ci-text",
                                          "This app was made by the Cancer Intelligence team to help showcase the amazing work of the HCE team. If you have feedback or have found a bug, then please email",
                                          htmltools::a("cancerintelligence@cancer.org.uk", href = "mailto:cancerintelligence@cancer.org.uk")))

  )

  htmltools::attachDependencies(ciBox, css)
}
