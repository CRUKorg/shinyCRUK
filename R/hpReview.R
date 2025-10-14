hpReview <- function(last_review_date) {
  div(
    # span("Health professionals",
    #      style = "background: #e2f4fd;
    #               color: #0076b4;
    #               display: inline-flex;
    #               align-items: center;
    #               padding: 8px 12px 8px 12px;"),
    div(style = "flex: 1;
                   align-self: stretch;"),
    span(HTML("Last reviewed: ", last_review_date),
         style = "color: #666666;
                  padding: 8px 12px 8px 12px;
                  text-align: right;"),
    # span(paste0("Next review due: ", next_review_date),
    #      style = "color: #666666;
    #                 padding: 8px 12px 8px 12px;"),
    style = "margin-bottom: 8px;
             display: flex;")
}
