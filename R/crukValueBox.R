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
#'              detail = "detail text",
#' )
crukValueBox <- function(id, title= "", value = "", icon = "",
                         icon_colour = "#00007e", detail = "") {
  # ns <- NS(id)


  bslib::value_box(
    id = id,
    title = htmltools::p(title,
              htmltools::hr(style="width:100%;
                 text-align:left;
                 margin-left:0;
                 border-top: 5px solid #000;
                 margin-top: 5px;
                 margin-bottom: 5px;
                 opacity: 1;")),
    value = htmltools::div(style = "display: flex;
                         justify-content: space-between;",
                htmltools::span(value,
                     style = "font-family: Progress Medium;"),
                htmltools::tags$i('arrow_forward',
                       class = "material-icons",
                       style = 'font-size: 1.8rem;
                                align-content: center;')
    ),
    showcase_layout = bslib::showcase_left_center(width = 0.25),
    showcase = htmltools::span(icon,
                    style = paste0("color: ", icon_colour, ";")),
    theme = bslib::value_box_theme(bg = "#ffffff", fg = "#000000"),
    detail)
}
