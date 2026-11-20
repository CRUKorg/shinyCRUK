#' Download a plotly chart as a PNG, with a heading
#'
#' A CRUK-branded button that saves a rendered plotly chart as a PNG
#' **including a heading**, without using plotly's modebar or any plotly.js
#' export function. The browser takes a snapshot of the chart's rendered SVG
#' with html2canvas, placed under a heading, and downloads it. Nothing is sent
#' to or rendered by the server, so it does not need Chrome, kaleido or Python
#' on shinyapps.io / Posit Connect.
#'
#' The heading can come from an existing element on the page (`headingId`),
#' from a fixed string (`heading`), or both. If both are given, `heading` wins.
#' Use `headingId` when the on-screen heading is dynamic (for example a
#' `textOutput()` or `uiOutput()` inside an [shiny::h3()]), because the text is
#' read at click time.
#'
#' The button is styled to match [crukDownloadButton()] and [crukButton()].
#'
#' @param plotId The output id of the plotly chart (the id passed to
#'   [plotly::plotlyOutput()]). Inside a module, pass `ns("plot")`.
#' @param filename File name without extension. Characters that are unsafe in
#'   file names are replaced with `-`.
#' @param heading Optional fixed heading text.
#' @param headingId Optional id of an element on the page whose text is used as
#'   the heading. Inside a module, pass `ns("heading")`.
#' @param subheading Optional fixed subheading text, shown under the heading in
#'   the PNG. Can be used with or without a heading.
#' @param subheadingId Optional id of an element on the page (typically an
#'   [shiny::h4()]) whose text is used as the subheading. It is read at click
#'   time, like `headingId`. If both `subheading` and `subheadingId` are given,
#'   `subheading` wins. Inside a module, pass `ns("subheading")`.
#' @param text Button label.
#' @param type Either `"primary"` (magenta background) or `"secondary"`
#'   (default, white background with magenta border).
#' @param icon Optional Google Material Symbol shown after the label. One of
#'   `"upload_file"`, `"download"` (default), `"check_circle"`, `"open_in_new"`,
#'   `"content_copy"`, `"mail"` or `"share"`. Use `NULL` for no icon.
#' @param align Horizontal alignment of the button within its container,
#'   `"right"` (default) or `"left"`.
#' @param scale Resolution multiplier for the PNG. `2` gives a sharper image.
#' @param class Optional extra CSS classes for the button.
#' @param ... Further attributes passed to the button tag.
#'
#' @return A button tag with CRUK branding and its CSS/JavaScript dependencies
#'   attached.
#' @export
#'
#' @examples
#' if (interactive() && requireNamespace("plotly", quietly = TRUE)) {
#'   library(shiny)
#'   ui <- fluidPage(
#'     h3(id = "cars_title", "Stopping distance by speed"),
#'     plotly::plotlyOutput("cars"),
#'     crukDownloadChartButton("cars", filename = "cars", headingId = "cars_title")
#'   )
#'   server <- function(input, output, session) {
#'     output$cars <- plotly::renderPlotly(plotly::plot_ly(cars, x = ~speed, y = ~dist))
#'   }
#'   shinyApp(ui, server)
#' }
crukDownloadChartButton <- function(plotId,
                                    filename = "chart",
                                    heading = NULL,
                                    headingId = NULL,
                                    subheading = NULL,
                                    subheadingId = NULL,
                                    text = "Download chart",
                                    type = "secondary",
                                    icon = "download",
                                    align = "right",
                                    scale = 2,
                                    class = NULL,
                                    ...) {
  is_string <- function(x) is.character(x) && length(x) == 1 && !is.na(x) && nzchar(x)

  # Validation checks
  if (!is_string(plotId)) {
    stop("`plotId` must be a single non-empty string.", call. = FALSE)
  }
  if (!is_string(filename)) {
    stop("`filename` must be a single non-empty string.", call. = FALSE)
  }
  if (!is.null(heading) && !is_string(heading)) {
    stop("`heading` must be NULL or a single non-empty string.", call. = FALSE)
  }
  if (!is.null(headingId) && !is_string(headingId)) {
    stop("`headingId` must be NULL or a single non-empty string.", call. = FALSE)
  }
  if (!is.null(subheading) && !is_string(subheading)) {
    stop("`subheading` must be NULL or a single non-empty string.", call. = FALSE)
  }
  if (!is.null(subheadingId) && !is_string(subheadingId)) {
    stop("`subheadingId` must be NULL or a single non-empty string.", call. = FALSE)
  }
  if (!is_string(text)) {
    stop("You need to give your button a label via the text argument!", call. = FALSE)
  }
  if (!is_string(type) || !type %in% c("primary", "secondary")) {
    stop("type must be primary or secondary", call. = FALSE)
  }
  if (!is.null(icon) && (!is_string(icon) || !icon %in% c(
    "upload_file", "download", "check_circle", "open_in_new", "content_copy", "mail", "share"
  ))) {
    stop(
      "Available icons are: upload_file, download, check_circle, ",
      "open_in_new, content_copy, mail, or share.",
      call. = FALSE
    )
  }
  if (!is_string(align) || !align %in% c("right", "left")) {
    stop("align must be right or left", call. = FALSE)
  }
  if (!is.numeric(scale) || length(scale) != 1 || is.na(scale) || scale <= 0) {
    stop("`scale` must be a single positive number.", call. = FALSE)
  }

  # Dependencies. The CSS dependency deliberately has the same name and version
  # as the one in crukButton()/crukDownloadButton() so that htmltools only
  # includes it once per page.
  css <- htmltools::htmlDependency(
    name = "crukButton",
    version = get_pkg_version(),
    src = "www",
    package = "shinyCRUK",
    stylesheet = "css/buttons.css",
    all_files = TRUE
  )
  chart_js <- htmltools::htmlDependency(
    name = "crukDownloadChart",
    version = get_pkg_version(),
    src = "www",
    package = "shinyCRUK",
    script = c("javascript/html2canvas.min.js", "javascript/crukDownloadChart.js"),
    all_files = TRUE
  )
  googleSymbols <- htmltools::tags$link(
    href = "https://fonts.googleapis.com/css2?family=Material+Symbols+Sharp:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200",
    rel = "stylesheet"
  )

  # Button content: label, plus optional icon span (same markup as crukDownloadButton())
  content <- if (!is.null(icon)) {
    htmltools::tagList(
      text, " ",
      htmltools::tags$span(
        class = c("material-symbols-sharp", paste0("cruk-btn-icon-", type)),
        icon
      )
    )
  } else {
    text
  }

  # "cruk-download-chart" is the hook the JavaScript listens for.
  # "btn btn-default" mirrors the classes shiny puts on its own buttons, which
  # buttons.css is written against.
  button <- htmltools::tags$button(
    type = "button",
    class = paste(
      c("btn btn-default cruk-btn", paste0("cruk-btn-", type), "cruk-download-chart", class),
      collapse = " "
    ),
    `data-plot-id` = plotId,
    `data-filename` = filename,
    `data-heading` = heading,
    `data-heading-id` = headingId,
    `data-subheading` = subheading,
    `data-subheading-id` = subheadingId,
    `data-scale` = scale,
    content,
    ...
  )

  # Alignment wrapper (same approach as crukDownloadButton())
  align_items <- if (align == "right") "flex-end" else "flex-start"
  wrapper <- htmltools::tags$div(
    style = paste0("display: flex; flex-direction: column; align-items: ", align_items, ";"),
    button
  )

  htmltools::tagList(
    googleSymbols,
    htmltools::attachDependencies(wrapper, list(css, chart_js))
  )
}
