#' Cancer Intelligence Team Attribution Box
#'
#' Only for use in internal apps.
#'
#' Creates a styled box that credits the Cancer Intelligence team as the creators
#' of the application. Includes the Cancer Intelligence logo and contact
#' information.
#'
#' The box is typically placed at the bottom of the page, within
#' \code{\link{centralColumn}}, and can be displayed with or without a border.
#'
#' @param boxBorder Logical. If \code{TRUE} (default), displays the attribution
#'   box with a 1px solid black border. Set to \code{FALSE} for a borderless
#'   version that blends more seamlessly with surrounding content.
#'
#' @return An \code{htmltools::div} element with attached CSS dependencies containing:
#'   \itemize{
#'     \item Cancer Intelligence logo (SVG format)
#'     \item Attribution text explaining the team's role
#'     \item Contact email link (cancerintelligence@cancer.org.uk) for feedback
#'       and bug reports
#'   }
#'
#' @section Styling:
#' The component uses custom CSS (\code{ciBox.css}) that provides:
#' \itemize{
#'   \item Flexible layout with logo and text positioned side-by-side on desktop
#'   \item Responsive stacking of logo and text on mobile devices
#'   \item Optional border styling controlled by the \code{boxBorder} parameter
#'   \item CRUK brand-compliant typography and spacing
#' }
#'
#' @section Dependencies:
#' \itemize{
#'   \item CSS: \code{inst/www/css/ciBox.css}
#'   \item Logo: \code{inst/www/images/CI-logo.svg}
#' }
#'
#' @section Usage Context:
#' This component is specifically designed for apps created by the Cancer Intelligence
#' team to showcase work and provide attribution. Only us it for internal apps.
#'
#' @section Placement:
#' The attribution box should be placed at the end of your UI definition, typically:
#' \itemize{
#'   \item As the last element within \code{\link{centralColumn}}
#'   \item Before or after \code{\link{crukFooter}} depending on your layout needs
#'   \item At the bottom of the page to maintain clear visual hierarchy
#' }
#'
#' @seealso
#' \code{\link{crukFooter}} for the main CRUK footer with legal information
#'
#' \code{\link{centralColumn}} for the main content container
#'
#' @examples
#' # Basic usage with border (default)
#' ciBox()
#'
#' # Without border for seamless integration
#' ciBox(boxBorder = FALSE)
#'
#' \dontrun{
#' # Complete Shiny app with attribution box
#' library(shiny)
#' library(shinyCRUK)
#'
#' ui <- fluidPage(
#'   tags$head(crukTheme()),
#'   crukNavTitle(Title = "Cancer Statistics Dashboard"),
#'   centralColumn(
#'     crukTitle("Analysis Results"),
#'     p("Main content goes here..."),
#'     plotOutput("mainPlot"),
#'
#'     # Add attribution box at the end
#'     ciBox()
#'   ),
#'   # Optional: Add main CRUK footer after
#'   crukFooter()
#' )
#'
#' server <- function(input, output, session) {
#'   output$mainPlot <- renderPlot({
#'     plot(1:10)
#'   })
#' }
#'
#' shinyApp(ui, server)
#' }
#'
#' @export
ciBox <- function(boxBorder = TRUE) {
  shiny::addResourcePath(
    prefix = "shinyCRUK",
    directoryPath = system.file("www", package = "shinyCRUK")
  )

  ci_logo_path <- "shinyCRUK/images/CI-logo.svg"

  css <- htmltools::htmlDependency(
    name = "ciBox",
    version = get_pkg_version(),
    src = "www",
    package = "shinyCRUK",
    stylesheet = "css/ciBox.css",
    all_files = TRUE
  )

  ciBox <- htmltools::div(
    class = "ci-box",
    style = if (boxBorder) {
      "border: 2px solid black;"
    },
    htmltools::div(
      class = "ci-logo",
      htmltools::tags$img(src = ci_logo_path)
    ),
    htmltools::div(
      class = "ci-child",
      htmltools::p(
        class = "ci-text",
        "This app was made by the Cancer Intelligence team. If you have feedback or have found a bug, then please email",
        htmltools::a("cancerintelligence@cancer.org.uk", href = "mailto:cancerintelligence@cancer.org.uk")
      )
    )
  )

  htmltools::attachDependencies(ciBox, css)
}
