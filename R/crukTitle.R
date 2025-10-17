#' Page Title
#'
#' @param Title The title text to display as a h1
#' @param Subheading The subheading text to display as a h2
#'
#' @returns A div containing a title, subheading and horizontal rule in CRUK styling
#' @export
#'
#' @examples
#' crukTitle("Cancer Incidence")
#'
#' crukTitle(
#'   "Incidence for common cancers",
#'   "Latest cancer incidence statistics for the years 2017-2019"
#' )
crukTitle <- function(Title, Subheading = "") {
  htmltools::div(
    htmltools::h1(Title,
      style = "font-family: Progress Medium !important;
               font-weight: 500;
               margin: 0px;"
    ),
    htmltools::span(Subheading,
      class = "subheading",
      style = "font-family: Poppins;
               margin: 28px 0px 0px 0px;"
    ),
    htmltools::hr(style = "width: 4rem;
                           margin: 1rem 0rem 2rem 0rem;
                           height: 0.5rem;
                           color: black;
                           border-top: 0.5rem solid black;
                           opacity: 1;")
  )
}
