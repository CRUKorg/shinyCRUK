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
#'  characters. Please ensure alt text is sufficiently descriptive. Supplied
#'  character string will be appended with the text " Please see table for the data
#'  in an accessible format."
#' @param dataSourceText Character or Shiny UI object. Data source text that is displayed at the
#'  bottom of the table. Text is appended with "Data source: " in front.
#' @param dataSourceLink Character. URL for the data source hyperlink.
#' @param ... Optional additional arguments
#'
#' @returns A \code{bslib::navset_card_tab} object with attached CSS dependencies
#' @export
crukChartTable <- function(chart, table, alt, dataSourceText, dataSourceLink, ...) {

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
    stop("Alt text is over 125 characters, which may cause issues with some screen readers. Please use shorter alt text.")
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
    alt_processed <- glue::glue(
      alt,
      ". Please see the table for the data in an accessible format."
    )
  } else {
    alt_processed <- glue::glue(
      alt,
      " Please see the table for the data in an accessible format."
    )
  }

  # Treat dataSourceText as either plain text or a Shiny/htmltools object
  if (
    inherits(dataSourceText, "shiny.tag") &&
    identical(dataSourceText$name, "div") &&
    "shiny-text-output" %in% dataSourceText$attribs$class
  ) {

    # Convert textOutput() to inline textOutput()
    dataSourceContent <- shiny::textOutput(
      outputId = dataSourceText$attribs$id,
      inline = TRUE
    )

  } else if (
    inherits(dataSourceText, "shiny.tag") ||
    inherits(dataSourceText, "shiny.tag.list")
  ) {

    dataSourceContent <- dataSourceText

  } else {

    dataSourceContent <- htmltools::span(dataSourceText)

  }

  # Adjust link, depending on if it's a div.
  if (
    startsWith(dataSourceLink, "https://crukcancerintelligence.shinyapps.io/") &&
    grepl("#$", dataSourceLink)
  ) {

    dataSource <- htmltools::div(
      class = "no-border-card-source",
      htmltools::span("Data source: "),
      dataSourceContent
    )

  } else {

    dataSource <- htmltools::div(
      class = "no-border-card-source",
      htmltools::span("Data source: "),
      dataSourceContent,
      htmltools::span(". "),
      htmltools::a(
        href = dataSourceLink,
        dataSourceLink
      )
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
