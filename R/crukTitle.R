#' Page Title with Optional Subheading
#'
#' Creates a styled page title element with an optional subheading and decorative
#' horizontal rule. This function generates the main heading (h1) for content pages
#' in CRUK applications, providing consistent typography and spacing per CRUK brand
#' guidelines.
#'
#' The title appears in the Progress Medium font, followed by an optional subheading
#' in Poppins font, and a distinctive thick horizontal rule that serves as a visual
#' separator.
#'
#' @param Title Character string. The main page title text to display as an h1
#'   heading. This should be a concise, descriptive title for the page content.
#'   Required.
#' @param Subheading Character string. Optional subheading text to display below
#'   the main title. Use this to provide additional context or description for
#'   the page. Appears in a smaller font below the title. Default is an empty
#'   string (no subheading).
#'
#' @return An \code{htmltools::tagList} containing:
#'   \itemize{
#'     \item CSS dependency for title styling (\code{crukTitle.css})
#'     \item A \code{div} container with class \code{"cruk-title-container"}
#'     \item An \code{h1} element with the main title (Progress Medium font)
#'     \item A \code{p} element with the subheading (Poppins font), if provided
#'     \item A thick horizontal rule (\code{hr}) as a visual separator
#'   }
#'
#' @section Styling:
#' The title uses CRUK brand typography:
#' \describe{
#'   \item{Title (h1)}{Font: Progress Medium, Weight: 500, Margin: 0px}
#'   \item{Subheading (p)}{Font: Poppins, Margin: 28px top, 0px other sides, Class: "cruk-title-subheading"}
#'   \item{Horizontal Rule}{Width: 4rem (~64px), Height: 0.5rem (~8px), Color: Black, Margin: 1rem top, 2rem bottom}
#' }
#'
#' @section Usage Pattern:
#' Place this at the beginning of each page's content, typically as the first
#' element within \code{\link{centralColumn}}. Use descriptive titles that
#' clearly communicate the page's purpose.
#'
#' @seealso
#' \code{\link{centralColumn}} for the container that typically wraps page content
#'
#' \code{\link{crukNavTitle}} for the application-level navigation title
#'
#' @examples
#' # Simple title without subheading
#' crukTitle("Cancer Incidence")
#'
#' # Title with descriptive subheading
#' crukTitle(
#'   "Incidence for Common Cancers",
#'   "Latest cancer incidence statistics for the years 2017-2019"
#' )
#'
#' # Longer, more descriptive title and subheading
#' crukTitle(
#'   "Five-Year Survival Rates by Cancer Type",
#'   "Age-standardised net survival for adults diagnosed 2013-2017, followed up to 2018"
#' )
#'
#' # Title only (empty subheading is default)
#' crukTitle("Data Methods and Sources")
#'
#' \dontrun{
#' # In a complete Shiny app
#' library(shiny)
#' library(shinyCRUK)
#'
#' ui <- fluidPage(
#'   tags$head(crukTheme()),
#'   crukNavTitle(Title = "Cancer Statistics Dashboard"),
#'   centralColumn(
#'     # Page title at the start of content
#'     crukTitle(
#'       "Incidence Trends",
#'       "Explore cancer incidence rates from 2000 to 2020"
#'     ),
#'
#'     # Main page content follows
#'     plotOutput("incidencePlot"),
#'     tableOutput("incidenceTable")
#'   )
#' )
#' }
#'
#' @export
crukTitle <- function(Title, Subheading = "") {
  # Add CSS dependency
  htmltools::tagList(
    htmltools::htmlDependency(
      name = "crukTitle",
      version = utils::packageVersion("shinyCRUK"),
      src = "www",
      package = "shinyCRUK",
      stylesheet = "css/crukTitle.css",
      all_files = TRUE
    ),
    htmltools::div(
      class = "cruk-title-container",
      htmltools::h1(Title, class = "cruk-title-heading"),
      if (nchar(Subheading) > 0) {
        htmltools::p(Subheading, class = "cruk-title-subheading")
      },
      htmltools::hr(class = "cruk-title-rule")
    )
  )
}
