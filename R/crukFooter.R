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
  shiny::addResourcePath(
    prefix = "shinyCRUK",
    directoryPath = system.file("www", package = "shinyCRUK")
  )

  cruk_logo_path <- "shinyCRUK/images/cruk-logo.svg"
  regulator_logo_path <- "shinyCRUK/images/logo-fundraising-regulator-reg.svg"

  # Get paths for logos and text for reuse of content
  # cruk_logo_path <- "images/cruk-logo.svg"
  # regulator_logo_path <- "images/logo-fundraising-regulator-reg.svg"


  citation_path <- system.file("markdown", "citation-text.html", package = "shinyCRUK", mustWork = TRUE)
  email_site_path <- system.file("markdown", "email-site-text.html", package = "shinyCRUK", mustWork = TRUE)

  htmltools::tagList(
    crukCSSDependency(),
    htmltools::div(
      class = "central-column",
      htmltools::div(
        class = "info-footer",
        style = "padding: 16px 48px 16px 48px;
               border: 2px solid black;
               margin-bottom: 32px;
               margin-top: 32px;",
        # CRUK logo
        htmltools::div(
          htmltools::a(
            htmltools::img(
              src = cruk_logo_path,
              class = "cruk-logo-footer",
              style = "margin: 8px; margin-bottom: 16px; height: 60px;"
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
      htmltools::hr(style = "opacity: 1;
                  margin-right: calc(50% - 49.5vw) !important;
                  border: 0;
                  border-color: #000000;
                  border-style: solid;
                  border-bottom-width: 0.25rem;
                  margin: 0px;
                  width: auto;"),
      htmltools::h3("Together we are", htmltools::br(),
        " beating cancer",
        style = "padding-top: 16px; padding-bottom: 40px"
      ),
      htmltools::div(
        class = "terms-and-conditions",
        htmltools::div(
          htmltools::tags$ul(
            class = "terms-and-conditions-list",
            htmltools::tags$li(
              htmltools::div(
                htmltools::a(
                  htmltools::span("Terms and conditions"),
                  href = "https://www.cancerresearchuk.org/terms-and-conditions"
                )
              )
            ),
            htmltools::tags$li(
              htmltools::div(
                htmltools::a(
                  htmltools::span("Privacy"),
                  href = "https://www.cancerresearchuk.org/about-us/our-organisation/privacy-statement"
                )
              )
            ),
            htmltools::tags$li(
              htmltools::div(
                htmltools::a(
                  htmltools::span("Modern slavery statement"),
                  href = "https://www.cancerresearchuk.org/about-us/our-organisation/responsible-organisation"
                )
              )
            ),
            htmltools::tags$li(
              htmltools::div(
                htmltools::a(
                  htmltools::span("Cookies"),
                  href = "https://crukcancerintelligence.shinyapps.io/cookiespolicy"
                )
              )
            )
          )
        ),
      ),
      htmltools::a(
        htmltools::img(
          src = regulator_logo_path,
          height = "97px",
          style = "margin-right: 10px; height: 51px; margin-top: 16px; margin-bottom: 16px;"
        ),
        href = "https://www.fundraisingregulator.org.uk/"
      ),
      htmltools::tags$address("Cancer Research UK is a registered charity in England and Wales (1089464), Scotland (SC041666), the Isle of Man (1103) and Jersey (247). A company limited by guarantee. Registered company in England and Wales (4325234) and the Isle of Man (5713F). Registered address: 2 Redman Place, London, E20 1JQ.")
    )
  )
}
