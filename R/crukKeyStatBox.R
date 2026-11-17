# CRUK brand colours accepted for `boxColour` without a warning. Names are for
# the warning message only; matching is on the (upper-cased, 6-digit) hex code.
cruk_brand_box_colours <- c(
  Black = "#000000",
  Cyan = "#009CEE",
  `Light Cyan` = "#BCE4FA",
  `Medium Cyan` = "#5BC5F2",
  Magenta = "#E60078",
  Magenta = "#E60079",
  `Light Magenta` = "#F8C9DF",
  `Medium Magenta` = "#F088B6",
  Navy = "#00007E",
  `Light Navy` = "#CCCCE6",
  `Medium Navy` = "#6666B2",
  Grey = "#BBC7D9",
  `Light Grey` = "#C6C6C6",
  `Medium Grey` = "#878787"
)

#' Key statistic box
#'
#' A bordered box containing a key statement and, optionally, an image. The
#' image sits to the left of the statement when there is room, and above it
#' otherwise. The image and the statement are both aligned to the top of the
#' box.
#'
#' @param statement A single character string, or a Shiny output such as
#'   [shiny::textOutput()] or [shiny::uiOutput()].
#' @param image Optional. The `src` of the image to show: either a file name in
#'   the app's `www` folder, e.g. `"magnifying-glass.svg"`, or a path served by
#'   a registered resource path. Displayed 140px wide, with its aspect ratio
#'   kept and a maximum height of 140px, aligned to the top left. Defaults to
#'   the Cancer Research UK logo mark shipped with this package. `NULL` means
#'   no image.
#' @param showImage `TRUE` (the default) to show `image`, `FALSE` to hide it.
#' @param boxColour Colour of the box border, as a hex code (`"#RRGGBB"` or
#'   `"#RGB"`, case-insensitive; the leading `#` is required). Defaults to
#'   `"#bbc7d9"` (CRUK grey). A warning is given if the colour is not one of the
#'   CRUK brand colours: black `#000000`; cyan `#009CEE`, `#BCE4FA`, `#5BC5F2`;
#'   magenta `#E60078`, `#E60079`, `#F8C9DF`, `#F088B6`; navy `#00007E`,
#'   `#CCCCE6`, `#6666B2`; grey `#BBC7D9`, `#C6C6C6`, `#878787`.
#'
#' @return A [htmltools::tag] object.
#' @export
#'
#' @examples
#' crukKeyStatBox("Nearly 1 in 2 of us will get cancer in our lifetimes.")
#' crukKeyStatBox("A statement", image = "magnifying-glass.svg")
#' crukKeyStatBox("No image here", showImage = FALSE)
#' crukKeyStatBox("A navy box", boxColour = "#00007e")
crukKeyStatBox <- function(statement,
                           image = "shinyCRUK/images/CI-logo-no-text.svg",
                           showImage = TRUE,
                           boxColour = "#bbc7d9") {
  is_tag <- inherits(statement, c("shiny.tag", "shiny.tag.list"))
  is_string <- is.character(statement) && length(statement) == 1 && !is.na(statement)

  if (!is_tag && !is_string) {
    rlang::abort(
      "`statement` must be a single character string, or a shiny tag such as `textOutput()` or `uiOutput()`."
    )
  }

  if (!is.null(image) &&
      !(is.character(image) && length(image) == 1 && !is.na(image))) {
    rlang::abort("`image` must be `NULL` or a single file name in the app's `www` folder.")
  }

  if (!(is.logical(showImage) && length(showImage) == 1 && !is.na(showImage))) {
    rlang::abort("`showImage` must be `TRUE` or `FALSE`.")
  }

  is_hex <- is.character(boxColour) && length(boxColour) == 1 &&
    !is.na(boxColour) &&
    grepl("^#([0-9A-Fa-f]{3}|[0-9A-Fa-f]{6})$", boxColour)

  if (!is_hex) {
    rlang::abort(
      "`boxColour` must be a single hex code such as `\"#bbc7d9\"` (`#RRGGBB` or `#RGB`)."
    )
  }

  # Normalise to upper-case #RRGGBB so that "#0cf" and "#00CCFF" compare equal.
  box_colour <- toupper(boxColour)
  if (nchar(box_colour) == 4) {
    box_colour <- sub("^#(.)(.)(.)$", "#\\1\\1\\2\\2\\3\\3", box_colour)
  }

  if (!box_colour %in% cruk_brand_box_colours) {
    rlang::warn(c(
      sprintf("`boxColour` (%s) is outside CRUK brand guidelines.", boxColour),
      i = paste0(
        "Brand colours: ",
        paste0(names(cruk_brand_box_colours), " ", cruk_brand_box_colours, collapse = ", "),
        "."
      )
    ))
  }

  image_tag <- if (showImage && !is.null(image)) {
    # Needed for the default image, which is served from the package's `www`
    # folder under the "shinyCRUK" resource path.
    shiny::addResourcePath("shinyCRUK", system.file("www", package = "shinyCRUK"))
    htmltools::tags$img(
      src = image,
      alt = "",
      class = "cruk-key-stat-box__image"
    )
  }

  box <- htmltools::div(
    class = "cruk-key-stat-box",
    htmltools::div(
      class = "cruk-key-stat-box__box",
      # Safe to interpolate: `box_colour` has been validated as a hex code.
      style = paste0("--cruk-key-stat-box-colour: ", box_colour, ";"),
      image_tag, # NULL is dropped by htmltools
      htmltools::div(class = "cruk-key-stat-box__statement", statement)
    )
  )

  htmltools::attachDependencies(
    box,
    htmltools::htmlDependency(
      name = "crukKeyStatBox",
      version = get_pkg_version(),
      src = "www",
      package = "shinyCRUK",
      stylesheet = "css/crukKeyStatBox.css",
      all_files = TRUE
    )
  )
}
