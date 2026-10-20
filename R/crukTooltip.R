#' CRUK-styled tooltip
#'
#' Wraps a word or phrase in a span (font-weight 600, colour `#00007e`), appends
#' an info icon after it, and attaches a CRUK-styled [bslib::tooltip()] to that
#' icon. The tooltip shows on hover/focus (desktop) or tap (touch devices).
#'
#' @param text A single string: the word or phrase shown before the icon.
#' @param tip The tooltip content. A string or any htmltools tags.
#' @param placement Where the tooltip appears relative to the icon. One of
#'   `"bottom"` (default), `"top"`, `"left"` or `"right"`.
#' @param id Optional id passed to [bslib::tooltip()], so the tooltip can be
#'   controlled from the server with [bslib::toggle_tooltip()].
#'
#' @return An [htmltools::tag()] with the shinyCRUK tooltip dependency attached.
#'
#' @examples
#' if (interactive()) {
#'   library(shiny)
#'   ui <- bslib::page_fluid(
#'     shinyCRUK::crukTheme(),
#'     shiny::p(
#'       "Here is some ",
#'       shinyCRUK::crukTooltip("information", "Here is some useful information"),
#'       " in a sentence."
#'     )
#'   )
#'   shinyApp(ui, function(input, output, session) {})
#' }
#'
#' @export
crukTooltip <- function(text,
                        tip,
                        placement = c("bottom", "top", "left", "right"),
                        id = NULL) {
  placement <- match.arg(placement)

  if (!is.character(text) || length(text) != 1L || is.na(text)) {
    stop("`text` must be a single string.", call. = FALSE)
  }

  # The word AND the icon are the trigger. tabindex/role make it reachable by
  # keyboard, which is also how bslib's tooltip is shown on focus.
  trigger <- htmltools::tags$span(
    class = "cruk-tooltip-trigger",
    tabindex = "0",
    role = "button",
    htmltools::tags$span(class = "cruk-tooltip-label", text),
    htmltools::tags$span(class = "cruk-tooltip-trigger-icon", bsicons::bs_icon("info-circle"))
  )

  # Deliberately only uses span/div: Bootstrap's HTML sanitiser (if bslib leaves
  # it on) strips <svg> and <button>, so the icon is drawn in CSS instead.
  tip_content <- htmltools::tags$div(
    class = "cruk-tooltip-content",
    htmltools::tags$span(class = "cruk-tooltip-icon", `aria-hidden` = "true"),
    htmltools::tags$div(class = "cruk-tooltip-message", tip)
  )

  tooltip <- bslib::tooltip(
    trigger,
    tip_content,
    id = id,
    placement = placement,
    options = list(
      customClass = "cruk-tooltip",
      # Bootstrap's default offset (6px) is sized for its 6px arrow; ours is 16px
      offset = list(0, 18)
    )
  )

  out <- htmltools::tags$span(class = "cruk-tooltip-wrap", tooltip)

  dep <- htmltools::htmlDependency(
    name = "crukTooltip",
    version = get_pkg_version(),
    src = "www",
    package = "shinyCRUK",
    stylesheet = "css/crukTooltip.css",
    all_files = TRUE
  )

  htmltools::attachDependencies(out, dep, append = TRUE)
}
