#' CRUK footer
#'
#' @returns a div containing a styled footer with links and logos
#' @export
#'
#' @examples
#' crukFooter()
crukFooter <- function() {
  # Get paths using system.file()
  cruk_logo_path <- system.file("www", "cruk-logo.svg", package = "crukShiny")
  regulator_logo_path <- system.file("www", "logo-fundraising-regulator-reg.svg", package = "crukShiny")
  citation_path <- system.file("markdown", "citation-text.Rmd", package = "crukShiny")
  email_site_path <- system.file("markdown", "email-site-text.Rmd", package = "crukShiny")

  # Base64 encode the SVGs
  cruk_logo_base64 <- base64enc::base64encode(cruk_logo_path)
  regulator_logo_base64 <- base64enc::base64encode(regulator_logo_path)

  htmltools::div(
    class = "central-column",
    htmltools::div(
      class = "info-footer",
      style = "padding: 16px 48px 16px 48px; border: 2px solid black; margin-bottom: 32px; margin-top: 32px;",
      # CRUK logo
      htmltools::div(
        htmltools::a(
          htmltools::img(
            src = paste0("data:image/svg+xml;base64,", cruk_logo_base64),
            class = "cruk-logo-footer",
            style = "margin: 8px; margin-bottom: 16px; height: 60px;"
          ),
          href = "https://www.cancerresearchuk.org/"
        )
      ),
      bslib::layout_column_wrap(
        width = 1 / 2,
        htmltools::includeMarkdown(citation_path),
        htmltools::includeMarkdown(email_site_path)
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
        style = "terms-and-conditions-list",
        htmltools::tags$ul(
          class = "terms-and-conditions-list",
          htmltools::tags$li(
            htmltools::div(htmltools::a(htmltools::span("Terms and conditions", style = "font-size: 0.875rem"),
              href = "https://www.cancerresearchuk.org/terms-and-conditions"
            ))
          ),
          htmltools::tags$li(
            htmltools::div(
              htmltools::a(
                htmltools::span("Privacy", style = "font-size: 0.875rem"),
                href = "https://www.cancerresearchuk.org/about-us/our-organisation/privacy-statement"
              )
            )
          ),
          htmltools::tags$li(
            htmltools::div(
              htmltools::a(
                htmltools::span("Modern slavery statement", style = "font-size: 0.875rem"),
                href = "https://www.cancerresearchuk.org/about-us/our-organisation/responsible-organisation"
              )
            )
          ),
          htmltools::tags$li(
            htmltools::div(
              htmltools::a(
                htmltools::span("Cookies", style = "font-size: 0.875rem"),
                href = "https://crukcancerintelligence.shinyapps.io/cookiespolicy"
              )
            )
          )
        )
      ),
    ),
    htmltools::a(
      htmltools::img(
        src = paste0("data:image/svg+xml;base64,", regulator_logo_base64),
        height = "97px",
        style = "margin-right: 10px; height: 51px; margin-top: 16px; margin-bottom: 16px;"
      ),
      href = "https://www.fundraisingregulator.org.uk/"
    ),
    htmltools::tags$address("Cancer Research UK is a registered charity in England and Wales (1089464), Scotland (SC041666), the Isle of Man (1103) and Jersey (247). A company limited by guarantee. Registered company in England and Wales (4325234) and the Isle of Man (5713F). Registered address: 2 Redman Place, London, E20 1JQ.")
  )
}
