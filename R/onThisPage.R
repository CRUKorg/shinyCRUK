#' Create "On This Page" Contents Box with Scroll-to-Top Button
#'
#' Creates a styled navigation box that provides quick links to sections within
#' a page, along with a button that appears when scrolling to allows users to
#' return to the top of the page.
#'
#' @param ... Pairs of values where the first element is the div ID to link to
#'   and the second element is the display text for the link. Each pair should
#'   be provided as a vector `c(id, text)`. The div ID should be the heading of
#'   the content to link to can be provided with or without a leading `#`.
#' @param include_top_button Logical. Whether to include the scroll-to-top
#'   button that appears after scrolling down 200px. Default is `TRUE`.
#'
#' @return A `tagList` containing the styled navigation box, Material Symbols
#'   dependencies, and optionally the scroll-to-top button with its JavaScript
#'   functionality.
#'
#' @details
#' The function creates two main components:
#' \itemize{
#'   \item A fixed navigation box with styled links to page sections
#'   \item A scroll-to-top button that appears when the user scrolls down more
#'     than 200px and smoothly returns them to the top when clicked
#' }
#'
#' The function automatically includes:
#' \itemize{
#'   \item CSS styling from `css/onThisPage.css`
#'   \item Google Material Symbols Sharp font for icons
#'   \item JavaScript for scroll detection and smooth scrolling behavior
#' }
#'
#' @examples
#' \dontrun{
#' # In your Shiny UI
#' ui <- fluidPage(
#'   onThisPage(
#'     c("introduction", "Introduction"),
#'     c("methods", "Methods"),
#'     c("results", "Results"),
#'     c("conclusion", "Conclusion")
#'   ),
#'
#'   # Your page content with matching IDs
#'   div(id = "introduction", h2("Introduction"), p("...")),
#'   div(id = "methods", h2("Methods"), p("...")),
#'   div(id = "results", h2("Results"), p("...")),
#'   div(id = "conclusion", h2("Conclusion"), p("..."))
#' )
#'
#' # Without the scroll-to-top button
#' onThisPage(
#'   c("section1", "First Section"),
#'   c("section2", "Second Section"),
#'   include_top_button = FALSE
#' )
#' }
#'
#' @export
onThisPage <- function(..., include_top_button = TRUE) {
  css <- htmltools::htmlDependency(
    name = "onThisPage",
    version = get_pkg_version(),
    src = "www",
    package = "shinyCRUK",
    stylesheet = "css/onThisPage.css",
    all_files = TRUE
  )

  googleSymbols <- htmltools::tags$link(
    href = "https://fonts.googleapis.com/css2?family=Material+Symbols+Sharp:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200",
    rel = "stylesheet"
  )

  # Process arguments
  args <- list(...)
  div_ids <- sapply(args, function(x) x[1])
  link_texts <- sapply(args, function(x) x[2])

  # Ensure div_ids and link_texts are the same length
  if (length(div_ids) != length(link_texts)) {
    stop("Number of div_ids must match number of link_texts")
  }

  # Create links for each pair
  links <- lapply(1:length(div_ids), function(i) {
    # Pre-append # to div_id if it doesn't already start with #
    href_id <- ifelse(!startsWith(div_ids[i], "#"), paste0("#", div_ids[i]), div_ids[i])
    htmltools::div(
      class = "otp-link-div",
      htmltools::HTML(paste0(
        htmltools::span(
          class = c("material-symbols-sharp", "otp-link-icon"),
          "arrow_downward"
        ),
        htmltools::a(
          href = href_id, link_texts[i],
          class = "otp-link"
        )
      )),
    )
  })

  # Build the main container with all links
  main_container <- htmltools::div(
    class = "otp-link-container",
    # htmltools::tags$link(href = "https://fonts.googleapis.com/icon?family=Material+Symbols+Sharp", rel = "stylesheet"),
    htmltools::div(
      class = "otp-header",
      "On this page"
    ),
    do.call(htmltools::tagList, links)
  )

  # Conditionally add the scroll-to-top button
  if (include_top_button) {
    # JavaScript functionality
    js_script <- htmltools::tags$script(
      htmltools::HTML("
      // Define the scroll function globally
      window.scrollToTop = function () {
        window.scrollTo({
          top: 0,
          behavior: 'smooth'
        });
      };
      document.addEventListener('DOMContentLoaded', function () {
        // Select all scroll-to-top buttons
        const scrollToTopButtons = document.querySelectorAll('.scroll-to-top-button');
        // Handle scroll event once for all buttons
        window.addEventListener('scroll', () => {
          const shouldShow = window.scrollY > 200;
          scrollToTopButtons.forEach(button => {
            button.style.display = shouldShow ? 'block' : 'none';
          });
        });
        // Attach click listener to each button
        scrollToTopButtons.forEach(button => {
          button.addEventListener('click', scrollToTop);
        });
      });
    ")
    )

    # R HTML button element
    button_element <- htmltools::tags$button(
      class = "scroll-to-top-button",
      htmltools::tags$i("arrow_upward",
        class = c("material-symbols-sharp", "scroll-to-top-arrow")
      )
    )

    return(
      htmltools::tagList(
        css,
        googleSymbols,
        main_container,
        js_script,
        button_element
      )
    )
  } else {
    return(
      htmltools::tagList(
        css,
        googleSymbols,
        main_container
      )
    )
  }
}
