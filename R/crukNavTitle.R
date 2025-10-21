#' CRUK-branded Navigation Title
#'
#' Themes the navigation bar with the CRUK logo. Accomodates mobile layout and up
#' to two selectors
#'
#' @param Title Character string. The title text to display in the navigation bar.
#'   Can include HTML markup. Default is an empty string.
#' @param selectors Integer (0, 1, or 2). The number of selector elements to include
#'   in the navigation bar. This determines the responsive layout behavior:
#'   \itemize{
#'     \item 0: Simple layout with title and stacked logo
#'     \item 1: Layout with title, one selector, and responsive logo switching
#'     \item 2: Layout with title, two selectors, and responsive logo switching
#'   }
#'   Default is 0.
#' @param selector1 Shiny UI element or NULL. The first selector to display in the
#'   navigation bar. Only used when \code{selectors >= 1}. Typically a
#'   \code{selectInput()}, \code{pickerInput()}, or similar input element.
#'   Default is NULL.
#' @param selector2 Shiny UI element or NULL. The second selector to display in the
#'   navigation bar. Only used when \code{selectors == 2}. Typically a
#'   \code{selectInput()}, \code{pickerInput()}, or similar input element.
#'   Default is NULL.
#'
#' @return An \code{htmltools::tagList} containing the styled navigation bar with
#'   embedded CSS for responsive behavior.
#'
#' @section Responsive Behavior:
#' The function creates different layouts based on screen width:
#' \describe{
#'   \item{Mobile (< 992px)}{Vertical layout with stacked logo (50px height),
#'     full-width selectors stacked below the title}
#'   \item{Desktop (>= 992px)}{Horizontal layout with wide logo (35px or 70px height),
#'     selectors positioned alongside title (400px width each)}
#' }
#'
#' @section Action Link:
#' The title is wrapped in an \code{actionLink} with id \code{"app_title_link"},
#' allowing you to observe clicks with \code{observeEvent(input$app_title_link, ...)}.
#'
#' @section Dependencies:
#' Requires the shinyCRUK package with logo assets in \code{inst/www/images/}:
#' \itemize{
#'   \item \code{cruk-logo.svg} - Stacked logo for mobile view
#'   \item \code{cruk-logo-wide.png} - Wide logo for desktop view
#' }
#'
#' @examples
#' \dontrun{
#' # Simple navigation with no selectors
#' crukNavTitle(Title = "Local Stats Data Hub")
#'
#' # Navigation with one selector
#' crukNavTitle(
#'   Title = "Data Explorer",
#'   selectors = 1,
#'   selector1 = selectInput("dataset", "Choose dataset:", choices = c("A", "B"))
#' )
#'
#' # Navigation with two selectors
#' crukNavTitle(
#'   Title = "Analysis Dashboard",
#'   selectors = 2,
#'   selector1 = selectInput("year", "Year:", choices = 2020:2024),
#'   selector2 = selectInput("cancer-site", "Cancer site:",
#'     choices = c("All cancers", "Breast", "Bowel", "Lung", "Prostate")
#'   )
#' )
#' }
#'
#' @export
crukNavTitle <- function(Title = "", selectors = 0, selector1 = NULL, selector2 = NULL) {
  shiny::addResourcePath(
    prefix = "shinyCRUK",
    directoryPath = system.file("www", package = "shinyCRUK")
  )

  # Add at the start of the function:
  if (!selectors %in% 0:2) {
    stop("selectors must be 0, 1, or 2")
  }
  if (selectors >= 1 && is.null(selector1)) {
    warning("selector1 is NULL but selectors >= 1")
  }
  if (selectors == 2 && is.null(selector2)) {
    warning("selector2 is NULL but selectors == 2")
  }
  # Define media queries based on selector count
  media_query <- if (selectors == 0) {
    htmltools::tags$style(
      ".navbar-cruk {
        display: flex;
        flex-direction: row;
        justify-content: space-between;
      }

      @media (max-width: 991px) {
        .navbar-brand {
           width: 100%
        }

        .cruk-logo-nav {
          height: 50px;
        }
      }

      @media (min-width: 992px) {
        .cruk-logo-nav {
          height: 70px;
        }
      }
      "
    )
  } else if (selectors >= 1) {
    htmltools::tags$style(
      ".navbar-cruk {
          display: flex;
          justify-content: space-between;
        }

        @media (max-width: 991px) {
          .navbar-brand {
            width: 100%
          }
          .navbar-cruk {
            flex-direction: column;
          }
          .cruk-logo-wide-nav {
            display: none;
          }
          .cruk-logo-nav {
            height: 50px;
          }

          .title {
            margin-top: 10px;
            width: 100%;
            display: flex;
            justify-content: space-between;
          }

          .selector-1 {width:100%;}
        }

        @media (min-width: 992px) {
          .cruk-logo-nav {
            display: none;
          }

          .logo-wide {
            display: flex;
            justify-content: flex-end;
          }

          .cruk-logo-wide-nav {
            height: 35px;
          }

          .cruk-logo {
            display: none;
          }

          .selector-1 { width: 400px;}
          .selector-2 { width: 400px;}

        }

      "
    )
  }


  navbar_title <- if (selectors == 0) {
    htmltools::div(
      class = "navbar-cruk",
      htmltools::div(
        class = "title",
        shiny::actionLink(
          inputId = "app_title_link",
          class = "app-title",
          htmltools::HTML(Title)
        )
      ),
      htmltools::div(
        class = "logo",
        style = "justify-content: flex-end; margin: 0.5rem;",
        htmltools::a(
          shinyCRUK::crukLogo(class = "cruk-logo-nav"),
          href = "https://www.cancerresearchuk.org/"
        ),
      )
    )
  } else { # selectors >= 1
    htmltools::div(
      htmltools::div(
        class = "logo-wide",
        htmltools::a(
          shinyCRUK::crukLogoWide(class = "cruk-logo-wide-nav"),
          href = "https://www.cancerresearchuk.org/"
        )
      ),
      htmltools::div(
        class = "navbar-cruk",
        htmltools::div(
          class = "title",
          shiny::actionLink(
            inputId = "app_title_link",
            class = "app-title",
            htmltools::HTML(Title)
          ),
          htmltools::a(
            shinyCRUK::crukLogo(class = "cruk-logo-nav"),
            href = "https://www.cancerresearchuk.org/"
          )
        ),
        htmltools::div(class = "selector-1", selector1),
        if (selectors == 2) htmltools::div(class = "selector-2", selector2)
      )
    )
  }


  htmltools::tagList(
    media_query,
    navbar_title
  )
}
