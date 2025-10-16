#' Health Professional Last Review
#'
#' @param last_review_date A date to display as the last date the page or content was reviewed
#'
#' @returns A div containing a styled health professional box and the date of last review
#' @export
#'
#' @examples
#' hpReview("08 July 2025")
#'
lastReviewHP <- function(last_review_date) {
  htmltools::div(
    htmltools::span("Health professionals",
      style = "background: #e2f4fd;
                  color: #52627a;
                  font-family: Poppins;
                  display: inline-flex;
                  align-items: center;
                  padding: 8px 12px 8px 12px;"
    ),
    htmltools::div(style = "flex: 1;
                   align-self: stretch;"),
    htmltools::span(htmltools::HTML("Last reviewed:", last_review_date),
      style = "color: #666666;
                  font-family: Poppins;
                  padding: 8px 12px 8px 12px;
                  text-align: right;"
    ),
    style = "margin-bottom: 8px;
             display: flex;"
  )
}

lastReviewInternal <- function(last_review_date) {
  htmltools::div(
    htmltools::span("Internal only",
                    style = "background: #fff0f8;
                  color: #cc006c;
                  font-family: Poppins;
                  display: inline-flex;
                  align-items: center;
                  padding: 8px 12px 8px 12px;"
    ),
    htmltools::div(style = "flex: 1;
                   align-self: stretch;"),
    htmltools::span(htmltools::HTML("Last reviewed:", last_review_date),
                    style = "color: #666666;
                  font-family: Poppins;
                  padding: 8px 12px 8px 12px;
                  text-align: right;"
    ),
    style = "margin-bottom: 8px;
             display: flex;"
  )
}
