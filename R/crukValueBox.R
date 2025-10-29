#' CRUK-Branded Value Box
#'
#' Creates a branded value box component for displaying key metrics or statistics
#' in CRUK applications. The value box features a title, prominent value display,
#' optional icon, and detail text, all styled according to CRUK design guidelines.
#'
#' Value boxes are useful for highlighting important numbers, KPIs, or summary
#' statistics in dashboards and data visualizations. The CRUK value box includes
#' a distinctive horizontal rule under the title and a forward arrow icon next to
#' the value.
#'
#' @param id Character string. The HTML id attribute for the value box element.
#'   Used for targeting with CSS or JavaScript. Required.
#' @param title Character string. The title text displayed at the top of the
#'   value box, describing what the value represents. A horizontal rule appears
#'   below the title. Default is an empty string.
#' @param value Character string or numeric. The main value to display prominently
#'   in the value box (e.g., "250", "45.2%", "1,234"). Appears in large text
#'   with the Progress Medium font. Default is an empty string.
#' @param icon A Shiny icon object or Material Symbols icon. The icon to display
#'   in the showcase area on the left side of the value box. Can be created with
#'   \code{shiny::icon()} for Font Awesome icons or other icon systems.
#'   Default is an empty string (no icon).
#' @param icon_colour Character string. The color of the showcase icon, specified
#'   as a CSS color value (hex code, RGB, or named color). Default is
#'   \code{"#00007e"} (CRUK dark blue). Note: Uses British spelling to align
#'   with CRUK conventions.
#' @param detail Character string. Optional detail text displayed below the main
#'   value, providing additional context or information. Appears in smaller text.
#'   Default is an empty string.
#'
#' @return A \code{bslib::value_box} object with attached CSS dependencies for
#'   CRUK styling and Google Material Symbols font. The value box includes:
#'   \itemize{
#'     \item Title with horizontal rule separator
#'     \item Large, prominent value display with forward arrow icon
#'     \item Left-aligned showcase area for custom icon
#'     \item Detail text below the value
#'     \item White background with black text (CRUK theme)
#'   }
#'
#' @section Styling:
#' The value box uses custom CSS (\code{crukValueBox.css}) that applies:
#' \itemize{
#'   \item Progress Medium font for the value display
#'   \item CRUK-styled horizontal rule under the title
#'   \item Material Symbols "arrow_forward" icon next to the value
#'   \item Showcase layout with icon on the left (25\% width)
#'   \item White background with black text
#' }
#'
#' @section Dependencies:
#' This function loads:
#' \itemize{
#'   \item \code{crukValueBox.css} - Custom CRUK value box styling
#'   \item Google Material Symbols Outlined font - For the arrow icon
#'   \item \code{bslib} package - For the base value box component
#' }
#'
#' @section Usage Tips:
#' \itemize{
#'   \item Use concise titles that clearly describe the metric
#'   \item Format values appropriately (e.g., add commas for thousands, \% signs)
#'   \item Choose icons that visually represent the metric
#'   \item Use the default CRUK blue for icons unless brand guidelines specify otherwise
#'   \item Keep detail text brief - one or two lines maximum
#' }
#'
#' @seealso
#' \code{\link[bslib]{value_box}} for the underlying value box component
#' \code{\link[shiny]{icon}} for creating Font Awesome icons
#'
#' @examples
#' # Basic value box with title and value
#' crukValueBox(
#'   id = "valueBox1",
#'   title = "Total Cases",
#'   value = "250"
#' )
#'
#' # Value box with icon and detail
#' crukValueBox(
#'   id = "valueBox2",
#'   title = "Average Weight",
#'   value = "74.5 kg",
#'   icon = shiny::icon("weight-scale"),
#'   detail = "Based on 1,234 patients"
#' )
#'
#' # Value box with custom icon color
#' crukValueBox(
#'   id = "valueBox3",
#'   title = "Survival Rate",
#'   value = "89.2%",
#'   icon = shiny::icon("heart-pulse"),
#'   icon_colour = "#009cee",
#'   detail = "5-year net survival"
#' )
#'
#' # Multiple value boxes in a layout
#' \dontrun{
#' library(shiny)
#' library(shinyCRUK)
#'
#' ui <- fluidPage(
#'   tags$head(crukTheme()),
#'   crukNavTitle(Title = "Cancer Statistics Dashboard"),
#'   centralColumn(
#'     crukTitle("Key Metrics", "Overview of cancer statistics"),
#'
#'     # Layout value boxes in a grid
#'     bslib::layout_column_wrap(
#'       width = 1 / 3,
#'       crukValueBox(
#'         id = "incidence",
#'         title = "New Cases",
#'         value = "367,000",
#'         icon = shiny::icon("user-plus"),
#'         detail = "Annual incidence in UK"
#'       ),
#'       crukValueBox(
#'         id = "survival",
#'         title = "Survival Rate",
#'         value = "50%",
#'         icon = shiny::icon("heart"),
#'         icon_colour = "#e40087",
#'         detail = "10-year survival"
#'       ),
#'       crukValueBox(
#'         id = "mortality",
#'         title = "Deaths",
#'         value = "167,000",
#'         icon = shiny::icon("chart-line-down"),
#'         detail = "Annual mortality in UK"
#'       )
#'     )
#'   )
#' )
#'
#' server <- function(input, output, session) {
#'   # Server logic here
#' }
#'
#' shinyApp(ui, server)
#'
#' # Reactive value boxes with server-side updates
#' ui <- fluidPage(
#'   tags$head(crukTheme()),
#'   crukNavTitle(Title = "Live Dashboard"),
#'   centralColumn(
#'     selectInput("cancer_type", "Cancer Type:",
#'       choices = c("Breast", "Lung", "Bowel")
#'     ),
#'     uiOutput("dynamicValueBoxes")
#'   )
#' )
#'
#' server <- function(input, output, session) {
#'   output$dynamicValueBoxes <- renderUI({
#'     # Get data based on selection
#'     cases <- switch(input$cancer_type,
#'       "Breast" = "55,900",
#'       "Lung" = "48,500",
#'       "Bowel" = "42,900"
#'     )
#'
#'     bslib::layout_column_wrap(
#'       width = 1 / 2,
#'       crukValueBox(
#'         id = "cases_box",
#'         title = paste(input$cancer_type, "Cancer Cases"),
#'         value = cases,
#'         icon = shiny::icon("hospital"),
#'         detail = "Annual incidence"
#'       ),
#'       crukValueBox(
#'         id = "rate_box",
#'         title = "Incidence Rate",
#'         value = "123.4",
#'         icon = shiny::icon("chart-line"),
#'         detail = "Per 100,000 population"
#'       )
#'     )
#'   })
#' }
#'
#' shinyApp(ui, server)
#' }
#'
#' @export
crukValueBox <- function(id, title = "", value = "", icon = "",
                         icon_colour = "#00007e", detail = "") {
  # Input validation
  if (missing(id) || nchar(id) == 0) {
    stop("Parameter 'id' is required and cannot be empty")
  }

  # Create and store the dependency
  css <- htmltools::htmlDependency(
    name = "crukValueBox",
    version = get_pkg_version(),
    src = "www",
    package = "shinyCRUK",
    stylesheet = "css/crukValueBox.css",
    all_files = TRUE
  )

  googleSymbols <- htmltools::htmlDependency(
    name = "google-material-symbols",
    version = "1.0.0",
    src = c(href = "https://fonts.googleapis.com"),
    stylesheet = "css2?family=Material+Symbols+Sharp:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200"
  )

  # Create the value box
  valueBox <- bslib::value_box(
    id = id,
    title = htmltools::p(
      title,
      htmltools::hr(class = "value-box-hr")
    ),
    value = htmltools::div(
      class = "value-box-value",
      htmltools::span(value,
        style = "font-family: Progress Medium;"
      ),
      htmltools::tags$i("arrow_forward",
        class = c("material-symbols-sharp", "value-box-value-arrow")
      )
    ),
    showcase_layout = bslib::showcase_left_center(width = 0.25),
    showcase = htmltools::span(icon,
      style = paste0("color: ", icon_colour, ";")
    ),
    theme = bslib::value_box_theme(bg = "#ffffff", fg = "#000000"),
    detail
  )

  # Attach the dependency and return
  htmltools::attachDependencies(valueBox, list(css, googleSymbols))
}
