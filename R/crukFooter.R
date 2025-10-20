#' CRUK Footer with Legal Information and Branding
#'
#' Creates a comprehensive footer section for CRUK applications containing the
#' CRUK tagline, legal links, regulatory logos, and optionally citation and
#' contact information. The footer provides users with terms and conditions,
#' privacy policy, and regulatory information in a styled, brand-compliant format.
#'
#' This function automatically detects whether it's being used in a Shiny app or
#' static HTML context (e.g., Quarto) and handles logo resources appropriately.
#'
#' @param includeContact Logical. If \code{TRUE} (default), includes the
#'   \code{info-footer} section containing the CRUK logo, data citation
#'   guidelines, and contact information. Set to \code{FALSE} to omit this
#'   section and show only the tagline, legal links, and regulatory information.
#'   This is useful for apps where contact/citation information is not relevant.
#'
#' @return An \code{htmltools::tagList} containing:
#'   \itemize{
#'     \item CSS dependency for footer styling (\code{crukFooter.css})
#'     \item (Optional) Info section with CRUK logo, citation guidelines, and
#'       contact details
#'     \item CRUK tagline: "Together we are beating cancer"
#'     \item Legal links: Terms and conditions, Privacy, Modern slavery statement,
#'       Cookies
#'     \item Fundraising Regulator logo
#'     \item Registered charity and company information
#'   }
#'
#' @section Footer Components:
#' Optional Info Section (includeContact = TRUE): CRUK Logo (linked to main website),
#' Citation Guidelines (instructions for reusing content), Contact Information
#' (cancerintelligence@cancer.org.uk, 10 working days response time).
#'
#' Always Included: Tagline ("Together we are beating cancer"), Legal Links
#' (Terms and conditions, Privacy statement, Modern slavery statement, Cookies policy),
#' Regulatory Information (Fundraising Regulator logo, charity registration numbers,
#' company details, registered address: 2 Redman Place, London, E20 1JQ).
#'
#' @section Responsive Design:
#' The footer is styled responsively via \code{crukFooter.css}:
#' Citation and contact information displayed in a two-column layout
#' on desktop, stacking on mobile (when \code{includeContact = TRUE}).
#' Legal links presented as a horizontal list on desktop, wrapping on mobile.
#' All logos and text scale appropriately for different screen sizes.
#'
#' @section Static vs. Shiny Context:
#' The function automatically detects the rendering context:
#' \describe{
#'   \item{Shiny Apps}{Uses \code{shiny::addResourcePath()} to serve logo images}
#'   \item{Static HTML (Quarto/RMarkdown)}{Uses \code{knitr::image_uri()} to
#'     embed logos as base64-encoded data URIs}
#' }
#' This ensures the footer works correctly in both interactive and static documents.
#'
#' @section Dependencies:
#' \itemize{
#'   \item External HTML files (when \code{includeContact = TRUE}):
#'     \code{inst/markdown/citation-text.html} and
#'     \code{inst/markdown/email-site-text.html}
#'   \item CSS: \code{inst/www/css/crukFooter.css}
#'   \item Logos: \code{inst/www/images/cruk-logo.svg} and
#'     \code{inst/www/images/logo-fundraising-regulator-reg.svg}
#'   \item Required packages: \code{bslib} (for \code{layout_column_wrap})
#' }
#'
#' @section Placement:
#' The footer should be placed at the end of your UI definition, typically as
#' the last element within \code{\link{centralColumn}} or at the bottom of
#' the page outside the central column.
#'
#' @seealso
#' \code{\link{crukNavTitle}} for the header/navigation component
#'
#' \code{\link{centralColumn}} for the main content container
#'
#' \code{\link{crukTheme}} for overall CRUK styling
#'
#' @examples
#' # Full footer with contact information (default)
#' crukFooter()
#'
#' # Footer without contact information
#' crukFooter(includeContact = FALSE)
#'
#' # In an interactive Shiny session
#' if (interactive()) {
#'   crukFooter()
#' }
#'
#' \dontrun{
#' # Complete Shiny app with full footer
#' library(shiny)
#' library(shinyCRUK)
#'
#' ui <- fluidPage(
#'   tags$head(crukTheme()),
#'   crukNavTitle(Title = "Cancer Statistics Dashboard"),
#'   centralColumn(
#'     crukTitle("Welcome"),
#'     p("This dashboard presents cancer incidence and survival statistics."),
#'     plotOutput("mainPlot"),
#'
#'     # Full footer with contact info
#'     crukFooter()
#'   )
#' )
#'
#' server <- function(input, output, session) {
#'   output$mainPlot <- renderPlot({
#'     plot(1:10)
#'   })
#' }
#'
#' shinyApp(ui, server)
#'
#' # App without contact information (e.g., internal tool)
#' ui <- fluidPage(
#'   tags$head(crukTheme()),
#'   crukNavTitle(Title = "Internal Data Tool"),
#'   centralColumn(
#'     crukTitle("Analysis"),
#'     p("Internal use only - no public contact needed")
#'   ),
#'
#'   # Footer without contact section
#'   crukFooter(includeContact = FALSE)
#' )
#'
#' # In a Quarto document (full footer)
#' crukFooter()
#'
#' # In a Quarto document (minimal footer)
#' crukFooter(includeContact = FALSE)
#' }
#'
#' @export
crukFooter <- function(includeContact = TRUE) {
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

  citation_path <- system.file("markdown", "citation-text.html",
    package = "shinyCRUK", mustWork = TRUE
  )
  email_site_path <- system.file("markdown", "email-site-text.html",
    package = "shinyCRUK", mustWork = TRUE
  )

  htmltools::tagList(
    htmltools::htmlDependency(
      name = "shinyCRUK-footer",
      version = utils::packageVersion("shinyCRUK"),
      src = "www",
      package = "shinyCRUK",
      stylesheet = "css/crukFooter.css",
      all_files = TRUE
    ),
    # Optional info section with contact details
    if (includeContact) {
      htmltools::div(
        class = "info-footer",
        # CRUK logo
        htmltools::div(
          htmltools::a(
            htmltools::img(
              src = cruk_logo_path,
              class = "cruk-logo-footer",
              alt = "Cancer Research UK logo"
            ),
            href = "https://www.cancerresearchuk.org/"
          )
        ),
        bslib::layout_column_wrap(
          width = 1 / 2,
          htmltools::includeHTML(citation_path),
          htmltools::includeHTML(email_site_path)
        )
      )
    },
    htmltools::hr(class = "footer-hr"),
    htmltools::h3(
      class = "footer-strapline",
      "Together we are", htmltools::br(),
      " beating cancer"
    ),
    htmltools::div(
      class = "terms-and-conditions",
      htmltools::div(
        htmltools::tags$ul(
          class = "terms-and-conditions-list",
          htmltools::tags$li(
            htmltools::a(
              class = "terms-and-conditions-link",
              "Terms and conditions",
              href = "https://www.cancerresearchuk.org/terms-and-conditions"
            )
          ),
          htmltools::tags$li(
            htmltools::a(
              class = "terms-and-conditions-link",
              "Privacy",
              href = "https://www.cancerresearchuk.org/about-us/our-organisation/privacy-statement"
            )
          ),
          htmltools::tags$li(
            htmltools::a(
              class = "terms-and-conditions-link",
              "Modern slavery statement",
              href = "https://www.cancerresearchuk.org/about-us/our-organisation/responsible-organisation"
            )
          ),
          htmltools::tags$li(
            htmltools::a(
              class = "terms-and-conditions-link",
              "Cookies",
              href = "https://crukcancerintelligence.shinyapps.io/cookiespolicy"
            )
          )
        )
      )
    ),
    htmltools::a(
      htmltools::img(
        class = "regulator-logo",
        src = regulator_logo_path,
        height = "97px",
        alt = "Fundraising Regulator logo"
      ),
      href = "https://www.fundraisingregulator.org.uk/"
    ),
    htmltools::tags$address(
      "Cancer Research UK is a registered charity in England and Wales (1089464), Scotland (SC041666), the Isle of Man (1103) and Jersey (247). A company limited by guarantee. Registered company in England and Wales (4325234) and the Isle of Man (5713F). Registered address: 2 Redman Place, London, E20 1JQ."
    )
  )
}
