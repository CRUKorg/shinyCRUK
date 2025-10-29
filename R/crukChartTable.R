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
#' @param height Height of the card. Default is 600 pixels.
#' @param dataSourceText Character. Data source text that is displayed at the
#'  bottom of the table. Text is appended with "Data source: " in front.
#' @param dataSourceLink Character. URL for the data source hyperlink.
#' @param ... Optional additional arguments
#'
#' @returns A \code{bslib::navset_card_tab} object with attached CSS dependencies
#'  for CRUK styling. The card includes:
#'  \itemize{
#'    \item A border-less, shadow-less card with two \code{bslib::nav_panel}s
#'    \item A tab with the heading "Chart".
#'    \item Attached alt text to the chart output, directing users to the table
#'    \item A tab with the heading "Title" and a data source
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
#'}
#'
#' @examples
#' \dontrun{
#' #' # Basic card with just chart and table
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
#' }
#' @export
crukChartTable <- function(chart, table, alt, dataSourceText, dataSourceLink, ..., height = 600) {

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
    version = utils::packageVersion("shinyCRUK"),
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


  # Adjust link, depending on it if it's a div.
  if (startsWith(dataSourceLink, "https://crukcancerintelligence.shinyapps.io/") && grepl("#$", dataSourceLink)) {
    dataSource <- htmltools::div(
      class = "no-border-card-source",
      htmltools::span("Data source: "),
      htmltools::a(href = dataSourceLink, dataSourceText)
    )
  } else {
    dataSource <- htmltools::div(
      class = "no-border-card-source",
      htmltools::span(paste0("Data source: ", dataSourceText, ". ")),
      htmltools::a(href = dataSourceLink, dataSourceLink)
    )
  }

  # Create the card
  chartTableCard <- htmltools::div(
    class = "no-border-card",
    ...,
    bslib::navset_card_tab(
      height = height,
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
