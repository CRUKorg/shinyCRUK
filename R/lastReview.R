#' Last reviewed date with health professional tag
#'
#' @param last_review_date A date to display as the last date the page or content was reviewed
#'
#' @returns A div containing a styled internal only box and the date of last review to place at the top of pages
#' @export
#'
#' @examples
#' lastReviewHP("08 July 2025")
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

#' Last reviewed date with internal only flag
#'
#' @param last_review_date A date to display as the last date the page or content was reviewed
#'
#' @returns A div containing a styled internal only box and the date of last review to place at the top of pages
#' @export
#'
#' @examples
#' lastReviewInternal("08 July 2025")
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

#' Last reviewed date with no tag
#'
#' @param last_review_date A date to display as the last date the page or content was reviewed
#'
#' @returns A div containing the date of last review to place at the top of pages
#' @export
#'
#' @examples
#' lastReview("08 July 2025")
lastReview <- function(last_review_date) {
  htmltools::div(
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
