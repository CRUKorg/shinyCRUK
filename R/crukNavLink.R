#' Make an Element Navigate to a Page and Scroll to a Section
#'
#' Makes one or more elements (typically \code{\link{crukValueBox}}es) clickable.
#' A click selects a page in a navbar or tabset, then scrolls to a div on that
#' page once it is visible, and closes any navbar dropdown menu left open by the
#' navigation. Call \code{\link{crukNavLinkSetup}} once in the UI first.
#'
#' Built on \code{\link[shinyjs]{onclick}} and \code{\link[bslib]{nav_select}}.
#' Call it from the server function (or module server) that owns the clickable
#' elements.
#'
#' @param valueBoxId Character vector. Id(s) of the element(s) to make clickable,
#'   i.e. the \code{id} passed to \code{crukValueBox()}. Inside a module, give the
#'   id as written in the module (the same string you wrapped in \code{ns()} in
#'   the UI); shinyjs adds the module namespace.
#' @param navId Character string. The \code{id} of the navbar or tabset that
#'   contains \code{targetPage}, for example the \code{id} of
#'   \code{bslib::page_navbar()}. Not namespaced.
#' @param targetPage Character vector. The \code{value} of the
#'   \code{bslib::nav_panel()} to open. Recycled to the length of
#'   \code{valueBoxId}.
#' @param targetDiv Character vector or \code{NULL}. The full DOM id of the div
#'   to scroll to, including any module namespace (for example if module id is
#'   "ScreeningModule" and the div id is "BowelScreening", then pass
#'   "ScreeningModule-BowelScreening). Recycled to the length of \code{valueBoxId}.
#'    If \code{NULL} (the default) the page is opened without scrolling.
#' @param session The Shiny session that owns \code{navId}. Default is
#'   \code{NULL}, which uses the root session of the app. Only supply this if
#'   \code{navId} lives inside a module.
#' @param timeoutMs Numeric. How long, in milliseconds, the browser keeps waiting
#'   for \code{targetDiv} to become visible before giving up. Default is 5000.
#' @param asis Logical. If \code{TRUE}, \code{valueBoxId} is used exactly as
#'   given instead of being namespaced inside a module. Default is
#'   \code{FALSE}.
#'
#' @return Invisibly, a tibble with one row per link registered.
#'
#' @section Setup:
#' Requires \code{crukNavLinkSetup()} in the UI, which loads shinyjs and the
#' scroll helper. Without it the navigation still happens, but nothing scrolls
#' and the browser console reports that \code{scrollToDivWhenReady} is not
#' defined.
#'
#' @section Things to watch:
#' \itemize{
#'   \item Calling \code{crukNavLink()} more than once for the same
#'     \code{valueBoxId} replaces the earlier link rather than adding to it
#'     (shinyjs \code{onclick(add = FALSE)} behaviour), so the last call wins.
#'   \item \code{targetDiv} must be the id as it appears in the page. Use the
#'     namespaced id for divs created inside modules.
#'   \item If \code{targetDiv} never becomes visible (wrong id, wrong page), a
#'     warning is written to the browser console after \code{timeoutMs}.
#' }
#'
#' @seealso \code{\link{crukValueBox}}, \code{\link{crukNavLinkSetup}},
#'   \code{\link[shinyjs]{onclick}}, \code{\link[bslib]{nav_select}}
#'
#' @examples
#' \dontrun{
#' library(shiny)
#' library(bslib)
#' library(shinyCRUK)
#'
#' ui <- page_navbar(
#'   id = "main_navbar",
#'   header = tagList(
#'     tags$head(crukTheme()),
#'     crukNavLinkSetup()
#'   ),
#'   nav_panel(
#'     title = "Overview",
#'     crukValueBox(id = "bowel_box", title = "Bowel screening", value = "70%")
#'   ),
#'   nav_panel(
#'     title = "Screening",
#'     value = "screening_page",
#'     div(style = "height: 1500px;", "Some other content"),
#'     div(id = "bowel_section", h2("Bowel screening"))
#'   )
#' )
#'
#' server <- function(input, output, session) {
#'   crukNavLink(
#'     valueBoxId = "bowel_box",
#'     navId = "main_navbar",
#'     targetPage = "screening_page",
#'     targetDiv = "bowel_section"
#'   )
#' }
#'
#' shinyApp(ui, server)
#'
#' # Inside a module: several boxes at once, each with its own target
#' # (module server code)
#' crukNavLink(
#'   valueBoxId = c("BowelScreening_Eng", "BreastScreening_Eng"),
#'   navId = "main_navbar",
#'   targetPage = "Screening_Eng",
#'   targetDiv = c(
#'     "screening_Eng-screeningBowelScreening",
#'     "screening_Eng-screeningBreastScreening"
#'   )
#' )
#' }
#'
#' @export
crukNavLink <- function(valueBoxId,
                        navId,
                        targetPage,
                        targetDiv = NULL,
                        session = NULL,
                        timeoutMs = 5000,
                        asis = FALSE) {
  # Input validation. Done before the session is touched so it can be tested
  # without a running app.
  if (!is.character(valueBoxId) || length(valueBoxId) == 0 || anyNA(valueBoxId)) {
    stop("`valueBoxId` must be a character vector with no missing values.", call. = FALSE)
  }
  if (!is.character(navId) || length(navId) != 1 || is.na(navId)) {
    stop("`navId` must be a single character string.", call. = FALSE)
  }
  if (!is.character(targetPage) || length(targetPage) == 0 || anyNA(targetPage)) {
    stop("`targetPage` must be a character vector with no missing values.", call. = FALSE)
  }
  if (!is.null(targetDiv) && (!is.character(targetDiv) || anyNA(targetDiv))) {
    stop("`targetDiv` must be NULL or a character vector with no missing values.", call. = FALSE)
  }
  if (!is.numeric(timeoutMs) || length(timeoutMs) != 1 || is.na(timeoutMs) || timeoutMs < 0) {
    stop("`timeoutMs` must be a single non-negative number.", call. = FALSE)
  }
  if (!is.logical(asis) || length(asis) != 1 || is.na(asis)) {
    stop("`asis` must be TRUE or FALSE.", call. = FALSE)
  }

  n <- length(valueBoxId)
  if (!all(c(length(targetPage), length(targetDiv)) %in% c(0L, 1L, n))) {
    stop(
      "`targetPage` and `targetDiv` must have length 1 or the same length as `valueBoxId`.",
      call. = FALSE
    )
  }

  timeoutMs <- as.integer(round(timeoutMs))

  # Default to the root session: inside a module the default reactive domain is
  # the module's session proxy, which would namespace `navId`.
  if (is.null(session)) {
    session <- shiny::getDefaultReactiveDomain()
    if (is.null(session)) {
      stop("`crukNavLink()` must be called inside a Shiny server function or module.", call. = FALSE)
    }
    session <- session$rootScope()
  }

  # Force everything now. The click handler runs later, and shinyjs evaluates
  # it in this function's frame, so nothing should be left as a lazy promise.
  force(navId)
  force(session)
  force(timeoutMs)
  force(asis)

  links <- tibble::tibble(
    valueBoxId = valueBoxId,
    targetPage = targetPage,
    targetDiv = if (is.null(targetDiv)) NA_character_ else targetDiv
  )

  purrr::pwalk(links, function(valueBoxId, targetPage, targetDiv) {
    shinyjs::onclick(valueBoxId, asis = asis, expr = {
      bslib::nav_select(id = navId, selected = targetPage, session = session)
      if (!is.na(targetDiv)) {
        shinyjs::runjs(sprintf(
          "scrollToDivWhenReady(%s, %d);",
          jsonlite::toJSON(targetDiv, auto_unbox = TRUE),
          timeoutMs
        ))
      }
    })
  })

  invisible(links)
}

#' Page Setup for crukNavLink
#'
#' Loads the JavaScript helper used by \code{\link{crukNavLink}} and calls
#' \code{shinyjs::useShinyjs()}. Place it once in the UI, for example in the
#' \code{header} of \code{bslib::page_navbar()}.
#'
#' @return An \code{htmltools::tagList} containing \code{shinyjs::useShinyjs()}
#'   and an \code{htmlDependency} that loads
#'   \code{javascript/scrollToDivWhenReady.js} from the package's \code{www/}
#'   directory. The dependency is versioned according to the shinyCRUK package
#'   version.
#'
#' @seealso \code{\link{crukNavLink}}
#'
#' @examples
#' \dontrun{
#' bslib::page_navbar(
#'   id = "main_navbar",
#'   header = shiny::tagList(
#'     shiny::tags$head(crukTheme()),
#'     crukNavLinkSetup()
#'   )
#' )
#' }
#'
#' @export
crukNavLinkSetup <- function() {
  htmltools::tagList(
    shinyjs::useShinyjs(),
    htmltools::htmlDependency(
      name = "crukNavLink",
      version = get_pkg_version(),
      src = "www",
      package = "shinyCRUK",
      script = "javascript/scrollToDivWhenReady.js",
      all_files = TRUE
    )
  )
}
