# Make an Element Navigate to a Page and Scroll to a Section

Makes one or more elements (typically
[`crukValueBox`](https://crukorg.github.io/shinyCRUK/reference/crukValueBox.md)es)
clickable. A click selects a page in a navbar or tabset, then scrolls to
a div on that page once it is visible, and closes any navbar dropdown
menu left open by the navigation. Call
[`crukNavLinkSetup`](https://crukorg.github.io/shinyCRUK/reference/crukNavLinkSetup.md)
once in the UI first.

## Usage

``` r
crukNavLink(
  valueBoxId,
  navId,
  targetPage,
  targetDiv = NULL,
  session = NULL,
  timeoutMs = 5000,
  asis = FALSE
)
```

## Arguments

- valueBoxId:

  Character vector. Id(s) of the element(s) to make clickable, i.e. the
  `id` passed to
  [`crukValueBox()`](https://crukorg.github.io/shinyCRUK/reference/crukValueBox.md).
  Inside a module, give the id as written in the module (the same string
  you wrapped in `ns()` in the UI); shinyjs adds the module namespace.

- navId:

  Character string. The `id` of the navbar or tabset that contains
  `targetPage`, for example the `id` of
  [`bslib::page_navbar()`](https://rstudio.github.io/bslib/reference/page_navbar.html).
  Not namespaced.

- targetPage:

  Character vector. The `value` of the
  [`bslib::nav_panel()`](https://rstudio.github.io/bslib/reference/nav-items.html)
  to open. Recycled to the length of `valueBoxId`.

- targetDiv:

  Character vector or `NULL`. The full DOM id of the div to scroll to,
  including any module namespace (for example if module id is
  "ScreeningModule" and the div id is "BowelScreening", then pass
  "ScreeningModule-BowelScreening). Recycled to the length of
  `valueBoxId`. If `NULL` (the default) the page is opened without
  scrolling.

- session:

  The Shiny session that owns `navId`. Default is `NULL`, which uses the
  root session of the app. Only supply this if `navId` lives inside a
  module.

- timeoutMs:

  Numeric. How long, in milliseconds, the browser keeps waiting for
  `targetDiv` to become visible before giving up. Default is 5000.

- asis:

  Logical. If `TRUE`, `valueBoxId` is used exactly as given instead of
  being namespaced inside a module. Default is `FALSE`.

## Value

Invisibly, a tibble with one row per link registered.

## Details

Built on [`onclick`](https://rdrr.io/pkg/shinyjs/man/onevent.html) and
[`nav_select`](https://rstudio.github.io/bslib/reference/nav_select.html).
Call it from the server function (or module server) that owns the
clickable elements.

## Setup

Requires
[`crukNavLinkSetup()`](https://crukorg.github.io/shinyCRUK/reference/crukNavLinkSetup.md)
in the UI, which loads shinyjs and the scroll helper. Without it the
navigation still happens, but nothing scrolls and the browser console
reports that `scrollToDivWhenReady` is not defined.

## Things to watch

- Calling `crukNavLink()` more than once for the same `valueBoxId`
  replaces the earlier link rather than adding to it (shinyjs
  `onclick(add = FALSE)` behaviour), so the last call wins.

- `targetDiv` must be the id as it appears in the page. Use the
  namespaced id for divs created inside modules.

- If `targetDiv` never becomes visible (wrong id, wrong page), a warning
  is written to the browser console after `timeoutMs`.

## See also

[`crukValueBox`](https://crukorg.github.io/shinyCRUK/reference/crukValueBox.md),
[`crukNavLinkSetup`](https://crukorg.github.io/shinyCRUK/reference/crukNavLinkSetup.md),
[`onclick`](https://rdrr.io/pkg/shinyjs/man/onevent.html),
[`nav_select`](https://rstudio.github.io/bslib/reference/nav_select.html)

## Examples

``` r
if (FALSE) { # \dontrun{
library(shiny)
library(bslib)
library(shinyCRUK)

ui <- page_navbar(
  id = "main_navbar",
  header = tagList(
    tags$head(crukTheme()),
    crukNavLinkSetup()
  ),
  nav_panel(
    title = "Overview",
    crukValueBox(id = "bowel_box", title = "Bowel screening", value = "70%")
  ),
  nav_panel(
    title = "Screening",
    value = "screening_page",
    div(style = "height: 1500px;", "Some other content"),
    div(id = "bowel_section", h2("Bowel screening"))
  )
)

server <- function(input, output, session) {
  crukNavLink(
    valueBoxId = "bowel_box",
    navId = "main_navbar",
    targetPage = "screening_page",
    targetDiv = "bowel_section"
  )
}

shinyApp(ui, server)

# Inside a module: several boxes at once, each with its own target
# (module server code)
crukNavLink(
  valueBoxId = c("BowelScreening_Eng", "BreastScreening_Eng"),
  navId = "main_navbar",
  targetPage = "Screening_Eng",
  targetDiv = c(
    "screening_Eng-screeningBowelScreening",
    "screening_Eng-screeningBreastScreening"
  )
)
} # }
```
