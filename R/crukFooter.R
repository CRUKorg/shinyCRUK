#' CRUK footer
#'
#' @returns a div containing a styled footer with links and logos
#' @export
#'
#' @examples
#' crukFooter()
#'
#' if (interactive()) {
#'   crukFooter()
#' }
crukFooter <- function() {
  # Register the package's www directory as a resource path
  isStatic <- is.null(shiny::getDefaultReactiveDomain())
  if (isStatic) {
    # For static HTML (Quarto), use base64 encoding
    cruk_logo_path <- knitr::image_uri(
      system.file("www/images/cruk-logo.svg", package = "shinyCRUK")
    )
    regulator_logo_path <- knitr::image_uri(
      system.file("www/images/logo-fundraising-regulator-reg.svg", package = "shinyCRUK")
    )
  } else {
    # For Shiny apps, use resource paths
    shiny::addResourcePath(
      prefix = "shinyCRUK",
      directoryPath = system.file("www", package = "shinyCRUK")
    )
    cruk_logo_path <- "shinyCRUK/images/cruk-logo.svg"
    regulator_logo_path <- "shinyCRUK/images/logo-fundraising-regulator-reg.svg"
  }

  citation_path <- system.file("markdown", "citation-text.html", package = "shinyCRUK", mustWork = TRUE)
  email_site_path <- system.file("markdown", "email-site-text.html", package = "shinyCRUK", mustWork = TRUE)

  htmltools::tagList(
    # crukCSSDependency(),
    htmltools::htmlDependency(
      name = "shinyCRUK-footer",
      version = utils::packageVersion("shinyCRUK"),
      src = "www",
      package = "shinyCRUK",
      stylesheet = "css/crukFooter.css",
      all_files = TRUE
    ),
    htmltools::div(
      class = "central-column",
      htmltools::div(
        class = "info-footer",
        # CRUK logo
        htmltools::div(
          htmltools::a(
            htmltools::img(
              src = cruk_logo_path,
              class = "cruk-logo-footer",
            ),
            href = "https://www.cancerresearchuk.org/"
          )
        ),
        bslib::layout_column_wrap(
          width = 1 / 2,
          htmltools::includeHTML(citation_path),
          htmltools::includeHTML(email_site_path)
        ),
      ),
      htmltools::hr(class = "footer-hr"),
      htmltools::h3(class = "footer-strapline",
                    "Together we are", htmltools::br(),
                    " beating cancer"
                    ),
      htmltools::div(
        class = "terms-and-conditions",
        htmltools::div(
          htmltools::tags$ul(
            class = "terms-and-conditions-list",
            htmltools::tags$li(
              htmltools::a(class = "terms-and-conditions-link",
                "Terms and conditions",
                href = "https://www.cancerresearchuk.org/terms-and-conditions"
              )
            ),
            htmltools::tags$li(
              htmltools::a(class = "terms-and-conditions-link",
                "Privacy",
                href = "https://www.cancerresearchuk.org/about-us/our-organisation/privacy-statement"
              )
            ),
            htmltools::tags$li(
              htmltools::a(class = "terms-and-conditions-link",
                "Modern slavery statement",
                href = "https://www.cancerresearchuk.org/about-us/our-organisation/responsible-organisation"
              )
            ),
            htmltools::tags$li(
              htmltools::a(class = "terms-and-conditions-link",
              "Cookies",
                href = "https://crukcancerintelligence.shinyapps.io/cookiespolicy"
              )
            )
          )
        ),
      ),
      htmltools::a(
        htmltools::img(
          class = "regulator-logo",
          src = regulator_logo_path,
          height = "97px",
        ),
        href = "https://www.fundraisingregulator.org.uk/"
      ),
      htmltools::tags$address("Cancer Research UK is a registered charity in England and Wales (1089464), Scotland (SC041666), the Isle of Man (1103) and Jersey (247). A company limited by guarantee. Registered company in England and Wales (4325234) and the Isle of Man (5713F). Registered address: 2 Redman Place, London, E20 1JQ.")
    )
  )
}
