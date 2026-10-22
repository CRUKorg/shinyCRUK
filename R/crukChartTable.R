#' Border-less Card for Chart and Table Combined Output
#'
#' Creates a border-less bslib card with two panels: one for a chart and the other
#' for a table. This function has a requirement for alt text to ensure accessibility
#' best practice.
#'
#' @param chart A chart output in the form of a \code{shiny::plotOutput},
#'  \code{plotly::plotlyOutput}, or \code{highcharter::highchartOutput}.
#' @param table A table output in the form of a \code{shiny::tableOutput},
#'  \code{DT::dataTableOutput}, \code{gt::gt_output}, or \code{reactable::reactableOutput}.
#' @param alt Character. Alt text to include alongside the chart. Minimum 15
#'  characters; over 125 characters gives a warning (it may cause issues with
#'  some screen readers). Please ensure alt text is sufficiently descriptive. Supplied
#'  character string will be appended with the text " Please see table for the data
#'  in an accessible format."
#' @param dataSourceText Optional. Character, or a \code{shiny.tag}/UI output
#'  object (e.g. \code{shiny::textOutput}, \code{shiny::uiOutput}). The data
#'  source text displayed at the bottom of the table, after a static
#'  "Data source: " label on the same line. If a tag/output object is supplied it
#'  is inserted as rendered content rather than coerced to a string. Top-level
#'  \code{div} outputs (the default for \code{textOutput} and \code{uiOutput}) are
#'  converted to \code{span}s so they stay inline. If \code{NULL} (the default), no
#'  data source line is added and "Data source" does not appear.
#' @param dataSourceLink Optional. Where the user goes when they click
#'  \code{dataSourceText}. Either a single character URL, or a \code{shiny.tag}
#'  output (\code{shiny::textOutput} or \code{shiny::uiOutput}) whose rendered
#'  content is the URL, so the link can be reactive. The URL is never displayed.
#'  For a \code{renderUI} output you can return plain text, or a tag containing
#'  an \code{<a href>}, in which case its \code{href} is used. Only
#'  \code{http(s)://} URLs are used; if the rendered value is anything else the text is
#'  shown without a link. Needs \code{dataSourceText}: if supplied on its own,
#'  it is ignored with a warning.
#' @param ... Optional additional arguments
#'
#' @returns A \code{bslib::navset_card_tab} object with attached CSS dependencies
#'  for CRUK styling. The card includes:
#'  \itemize{
#'    \item A border-less, shadow-less card with two \code{bslib::nav_panel}s
#'    \item A tab with the heading "Chart".
#'    \item Attached alt text to the chart output, directing users to the table
#'    \item A tab with the heading "Table" and, if supplied, a data source
#'    \item Optional additional arguments placed above the card, e.g. a title
#'           using \code{htmltools::h1} or selectors using \code{shinyCRUK::crukPickerInput}
#'           or \code{shinyCRUK::crukSelectInput}.
#'  }
#' @section Usage Tips:
#' \itemize{
#'   \item Use descriptive but concise alt text
#'   \item By default, \code{plotly::plotlyOutput}s should scale to fill the div,
#'   so avoid manually setting chart sizes
#'   \item If you want a title or selectors to apply to the chart and table, pass
#'   these as additional arguments. They will be displayed about the chart table card
#'   \item Ideally give full data source. If this is not possible
#'   (for example because you are using UK data from several sources), then you can
#'   direct the user to a data sources/references box at the bottom of the page
#'   and supply the function the full URL of the app with the div id of the
#'   data sources/reference box
#'   \item \code{dataSourceText} can be a dynamic \code{shiny::textOutput} or
#'   \code{shiny::uiOutput} if you need the data source label to update
#'   reactively; just remember to bind it server-side with a matching
#'   \code{output$id <- renderText({...})} (or \code{renderUI}), since the
#'   output tag itself is only a placeholder until bound.
#'   \item \code{dataSourceLink} is the destination of the click on
#'   \code{dataSourceText}; the URL itself is never shown.
#'}
#'
#' @examples
#' \dontrun{
#' # Basic card with just chart and table
#' crukChartTable(
#'   chart = plotlyOutput(outputId = "mtcarsPlot"),
#'   table = gt::gt_output(outputId = "mtTable"),
#'   alt = "A chart showing how horsepower varies according to mpg in the mtcars dataset."
#' )
#'
#' # Card with a data source
#' crukChartTable(
#'   chart = plotlyOutput(outputId = "mtcarsPlot"),
#'   table = gt::gt_output(outputId = "mtTable"),
#'   alt = "A chart showing how horsepower varies according to mpg in the mtcars dataset.",
#'   dataSourceText = "mtcars: Motor Trend Car Road Tests",
#'   dataSourceLink = "https://www.rdocumentation.org/packages/datasets/versions/3.6.2/topics/mtcars"
#' )
#'
#' # Chart and table card with additional arguments passed
#' crukChartTable(
#'   chart = plotlyOutput(outputId = "mtcarsPlot"),
#'   table = gt::gt_output(outputId = "mtTable"),
#'   alt = "Some alt text to go with the chart.",
#'   dataSourceText = "mtcars: Motor Trend Car Road Tests",
#'   dataSourceLink = "https://www.rdocumentation.org/packages/datasets/versions/3.6.2/topics/mtcars",
#'   htmltools::h1("mtcars: higher horsepower decreases mpg"),
#'   htmltools::br(),
#'   prettyCheckbox(inputId = "showCIs",
#'                  label = strong("Show confidence intervals"),
#'                  shape = "square",
#'                  value = FALSE)
#' )
#'
#' # Chart and table card with a reactive data source label
#' crukChartTable(
#'   chart = plotlyOutput(outputId = "mtcarsPlot"),
#'   table = gt::gt_output(outputId = "mtTable"),
#'   alt = "Some alt text to go with the chart.",
#'   dataSourceText = shiny::textOutput("dataSourceLabel"),
#'   dataSourceLink = "https://www.rdocumentation.org/packages/datasets/versions/3.6.2/topics/mtcars"
#' )
#'
#' # Chart and table card with a reactive data source label and link.
#' # Server side: output$dataSourceLabel <- renderText(...);
#' #              output$dataSourceUrl <- renderText(url())
#' crukChartTable(
#'   chart = plotlyOutput(outputId = "mtcarsPlot"),
#'   table = gt::gt_output(outputId = "mtTable"),
#'   alt = "Some alt text to go with the chart.",
#'   dataSourceText = shiny::textOutput("dataSourceLabel"),
#'   dataSourceLink = shiny::textOutput("dataSourceUrl")
#' )
#' }
#' @export
crukChartTable <- function(chart, table, alt, dataSourceText = NULL, dataSourceLink = NULL, ...) {

  # Input validation
  if (missing(chart)) {
    stop("Parameter 'chart' is required and cannot be empty")
  }

  if (missing(table)) {
    stop("Parameter 'table' is required and cannot be empty")
  }

  if (missing(alt) || nchar(alt) == 0 ) {
    stop("Parameter 'alt' is required and cannot be empty")
  } else if (nchar(alt) < 15) {
    stop("Please provide more descriptive alt text")
  } else if (nchar(alt) > 125) {
    warning("Alt text is over 125 characters, which may cause issues with some screen readers. Please use shorter alt text.", call. = FALSE)
  }


  # Create and store the dependency
  css <- htmltools::htmlDependency(
    name = "crukChartTable",
    version = get_pkg_version(),
    src = "www",
    package = "shinyCRUK",
    stylesheet = "css/crukChartTable.css",
    all_files = TRUE
  )


  # Adjust alt text by adding additional info. Also add period if necessary
  if (!grepl("\\.$", alt)) {
    alt_processed <- glue::glue(alt, ". Please see the table for the data in an accessible format.")
  } else {
    alt_processed <- glue::glue(alt, " Please see the table for the data in an accessible format.")

  }

  # ---- Data source -------------------------------------------------------
  # Tag/UI-output objects must be inserted as child elements rather than pasted
  # into a string, otherwise as.character() serializes the tag's structure into
  # literal HTML, which is then escaped and shown as raw markup.
  is_tag_ish <- function(x) {
    inherits(x, c("shiny.tag", "shiny.tag.list", "html"))
  }

  # NULL or an empty string means "not supplied"
  is_absent <- function(x) {
    is.null(x) || (is.character(x) && length(x) == 1 && !is.na(x) && !nzchar(trimws(x)))
  }

  is_single_string <- function(x) {
    is.character(x) && !inherits(x, "html") && length(x) == 1 && !is.na(x)
  }

  # textOutput()/uiOutput() default to <div>, which is block-level and would
  # force a line break after "Data source:". Swap a top-level div for a span.
  as_inline <- function(x) {
    if (inherits(x, "shiny.tag") && identical(x$name, "div")) x$name <- "span"
    x
  }

  # Make `label` a hyperlink whose href follows the rendered value of a shiny
  # output. The output is kept in the DOM (Shiny suspends outputs that are not
  # visible, so display:none would stop it ever rendering) but visually hidden
  # and hidden from screen readers; a MutationObserver copies its value into the
  # href of the anchor. Until a valid http(s) URL arrives the anchor has no href,
  # so it displays as plain text.
  dynamic_link <- function(label, link_output) {
    out_id <- htmltools::tagGetAttribute(link_output, "id")
    if (is.null(out_id) || !grepl("^[A-Za-z0-9_.:-]+$", out_id)) {
      stop("'dataSourceLink' is a shiny output without a usable id")
    }
    link_id <- paste0(out_id, "-source-link")

    js <- sprintf(
      paste0(
        "(function() {",
        " var out = document.getElementById('%s'), link = document.getElementById('%s');",
        " if (!out || !link) return;",
        " var update = function() {",
        "  var inner = out.querySelector('a[href]');",
        "  var url = (inner ? inner.getAttribute('href') : (out.textContent || '')).trim();",
        "  if (/^https?:\\/\\//i.test(url)) { link.setAttribute('href', url); }",
        "  else { link.removeAttribute('href'); }",
        " };",
        " new MutationObserver(update).observe(out, {childList: true, characterData: true, subtree: true});",
        " update();",
        "})();"
      ),
      out_id, link_id
    )

    hidden_output <- htmltools::tagAppendAttributes(
      as_inline(link_output),
      style = "position:absolute;width:1px;height:1px;overflow:hidden;clip:rect(0,0,0,0);white-space:nowrap;",
      `aria-hidden` = "true"
    )

    htmltools::tagList(
      htmltools::a(id = link_id, label),
      hidden_output,
      htmltools::tags$script(htmltools::HTML(js))
    )
  }

  # Validate
  if (!is_absent(dataSourceText) && !is_tag_ish(dataSourceText) && !is_single_string(dataSourceText)) {
    stop("'dataSourceText' must be a single character string or a shiny output (textOutput/uiOutput)")
  }
  if (!is_absent(dataSourceLink) && !inherits(dataSourceLink, "shiny.tag") && !is_single_string(dataSourceLink)) {
    stop("'dataSourceLink' must be a single character string or a shiny output (textOutput/uiOutput)")
  }

  has_text <- !is_absent(dataSourceText)
  has_link <- !is_absent(dataSourceLink)

  # The link is attached to the displayed text, so it cannot be used on its own
  if (has_link && !has_text) {
    warning("'dataSourceLink' is ignored because 'dataSourceText' was not supplied: there is no text to attach the link to.", call. = FALSE)
    has_link <- FALSE
  }

  # Nothing to show: no source line at all, and no "Data source" label
  dataSource <- NULL

  if (has_text) {
    label <- if (is_tag_ish(dataSourceText)) as_inline(dataSourceText) else dataSourceText

    body <- if (!has_link) {
      if (is_tag_ish(label)) label else htmltools::span(label)
    } else if (inherits(dataSourceLink, "shiny.tag")) {
      dynamic_link(label, dataSourceLink)
    } else {
      htmltools::a(href = dataSourceLink, label)
    }

    dataSource <- htmltools::div(
      class = "no-border-card-source",
      htmltools::span("Data source: "),
      body
    )
  }

  # Create the card
  chartTableCard <- htmltools::div(
    class = "no-border-card",
    ...,
    bslib::navset_card_tab(
      bslib::nav_panel(
        "Chart",
        role = "img",
        `aria-label` = alt_processed,
        htmltools::div(
          style = "padding-top: 10px;",
          chart
        )
      ),
      bslib::nav_panel(
        "Table",
        htmltools::div(
          class = "no-border-card-table",
          table
        ),
        dataSource
      )
    )
  )

  # Attach the dependency and return
  htmltools::attachDependencies(chartTableCard, css)

}
