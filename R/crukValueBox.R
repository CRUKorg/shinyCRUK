# CRUK-branded value box -------------------------------------------------------
#' CRUK value box
#'
#' @param id id for the value box
#' @param title the title
#' @param value the value
#' @param icon the icon of the value box
#' @param icon_colour the colour of the icon
#' @param detail the detail of the value box
#'
#' @returns a branded CRUK value box
#' @export
#'
#' @examples
#' crukValueBox(id = "valuBox1",
#'              title = "Title of the first value box",
#'              value = "250",
#'              icon = shiny::icon("weight-scale"),
#'              detail = "detail text"
#' )
crukValueBox <- function(id, title= "", value = "", icon = "",
                         icon_colour = "#00007e", detail = "") {
  # Create and store the dependency
  css <- htmltools::htmlDependency(
    name = "crukValueBox",
    version = utils::packageVersion("shinyCRUK"),
    src = "www",
    package = "shinyCRUK",
    stylesheet = "css/crukValueBox.css",
    all_files = TRUE
  )

  googleSymbols <- htmltools::htmlDependency(
    name = "google-material-symbols",
    version = "1.0.0",
    src = c(href = "https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined"),
    stylesheet = ""
  )

  # Create the value box
  valueBox <- bslib::value_box(
    id = id,
    title = htmltools::p(title,
                         htmltools::hr(class = "value-box-hr")),  # Remove the dot
    value = htmltools::div(class = "value-box-value",
                           htmltools::span(value,
                                           style = "font-family: Progress Medium;"),
                           htmltools::tags$i('arrow_forward',
                                             class = c("material-symbols-outlined", "value-box-value-arrow"))
    ),
    showcase_layout = bslib::showcase_left_center(width = 0.25),
    showcase = htmltools::span(icon,
                               style = paste0("color: ", icon_colour, ";")),
    theme = bslib::value_box_theme(bg = "#ffffff", fg = "#000000"),
    detail)

  # Attach the dependency and return
  htmltools::attachDependencies(valueBox, list(css, googleSymbols))
}
