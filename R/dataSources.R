#' CRUK Data Sources Box with Zotero Integration
#'
#' Creates a styled box displaying data sources and optional notes for CRUK
#' applications. The function can automatically fetch and format bibliographic
#' references from a Zotero collection or accept custom HTML source lists. This
#' component helps users understand the provenance of data and comply with
#' citation requirements.
#'
#' @param notes Character string. Optional explanatory notes to display above
#'   the data sources list. Use this to provide context about data limitations,
#'   methodology, or important caveats. Appears with a "Notes:" header.
#'   Default is an empty string (no notes section).
#' @param zotero_path Character string or NULL. Path to a Zotero collection
#'   (e.g., \code{"General & Cross Pathway/Local Stats Dashboard"}). When
#'   provided, the function automatically fetches bibliographic references from
#'   Zotero and formats them as an HTML list. Takes precedence over
#'   \code{custom_sources}. Default is \code{NULL}.
#' @param custom_sources HTML tag list or NULL. Custom HTML list of data sources
#'   to display. Use this when not integrating with Zotero or when you need
#'   custom formatting. Should be created with \code{htmltools::tags$li()} or
#'   similar. Only used if \code{zotero_path} is \code{NULL}. Default is \code{NULL}.
#' @param boxBorder Logical. If \code{TRUE} (default), displays a border around
#'   the sources box. Set to \code{FALSE} for a borderless design.
#'
#' @return An \code{htmltools::div} element with class \code{"sources"} containing:
#'   \itemize{
#'     \item CSS dependency for sources box styling (\code{crukSources.css})
#'     \item Optional notes section with "Notes:" header
#'     \item "Data sources:" header
#'     \item Unordered list of sources (from Zotero or custom HTML)
#'   }
#'
#' @section Zotero Integration:
#' When using \code{zotero_path}, the function:
#' \enumerate{
#'   \item Connects to the Zotero API using credentials from environment variables
#'   \item Navigates to the specified collection path
#'   \item Formats each reference as: "Author(s). Title, Year. Last accessed Month, Year."
#'   \item Returns the formatted citations as an HTML list
#' }
#'
#' @section Environment Variables Required for Zotero:
#' To use Zotero integration, set these in your \code{.Renviron} file:
#' \itemize{
#'   \item \code{ZOTERO_API_KEY} - Your Zotero API key (from https://www.zotero.org/settings/keys)
#'   \item \code{ZOTERO_USER_ID} - Your Zotero user ID (from https://www.zotero.org/settings/security)
#' }
#' Use \code{\link{setup_zotero_credentials}} to help configure these.
#'
#' @section Custom Sources Format:
#' When providing \code{custom_sources}, create a list of \code{<li>} elements:
#' \preformatted{
#' custom_sources <- htmltools::tagList(
#'   htmltools::tags$li("First source citation"),
#'   htmltools::tags$li("Second source citation"),
#'   htmltools::tags$li(
#'     htmltools::a("Linked source", href = "https://example.com")
#'   )
#' )
#' }
#'
#' @section Usage Pattern:
#' Place this component near the bottom of your page content, typically after
#' all data visualizations and tables but before \code{\link{crukFooter}}.
#'
#' @section Styling:
#' The sources box uses custom CSS (\code{crukSources.css}) that provides:
#' \itemize{
#'   \item Distinct "Notes:" and "Data sources:" headers in bold
#'   \item Consistent spacing and typography
#'   \item Optional border (1px solid black when \code{boxBorder = TRUE})
#'   \item Responsive padding and margins
#'   \item Zotero list styling with class \code{"zotero-list"}
#' }
#'
#' @seealso
#' \code{\link{get_zotero_sources}} for the underlying Zotero fetching function
#'
#' \code{\link{setup_zotero_credentials}} for configuring Zotero API access
#'
#' \code{\link{find_zotero_group}} for finding your Zotero group ID
#'
#' \code{\link{crukFooter}} for the page footer component
#'
#' @examples
#' # With Zotero integration (requires API credentials)
#' \dontrun{
#' crukSources(
#'   notes = "Data extracted from published reports.
#'            Figures may differ from official statistics due to rounding.",
#'   zotero_path = "Cancer Statistics/Incidence Data"
#' )
#'
#' # With notes but without border
#' crukSources(
#'   notes = "Provisional data subject to revision.",
#'   zotero_path = "Cancer Statistics/Incidence Data",
#'   boxBorder = FALSE
#' )
#' }
#'
#' # With custom sources (no Zotero required)
#' crukSources(
#'   custom_sources = htmltools::tagList(
#'     htmltools::tags$li(
#'       "Office for National Statistics. ",
#'       htmltools::a(
#'         "Cancer Registration Statistics",
#'         href = "https://www.ons.gov.uk/peoplepopulationandcommunity/healthandsocialcare/
#'                 conditionsanddiseases"
#'       ),
#'       ", 2023."
#'     ),
#'     htmltools::tags$li(
#'       "NHS Digital. Hospital Episode Statistics, 2022-2023."
#'     )
#'   )
#' )
#'
#' # With both notes and custom sources
#' crukSources(
#'   notes = "Age-standardised rates calculated using the 2013 European Standard Population.",
#'   custom_sources = htmltools::tagList(
#'     htmltools::tags$li("Cancer Research UK. Cancer Incidence and Mortality, 2024."),
#'     htmltools::tags$li("Public Health England. Cancer Services Data, 2023.")
#'   ),
#'   boxBorder = TRUE
#' )
#'
#' # In a complete Shiny app
#' \dontrun{
#' library(shiny)
#' library(shinyCRUK)
#'
#' ui <- fluidPage(
#'   tags$head(crukTheme()),
#'   crukNavTitle(Title = "Cancer Statistics Dashboard"),
#'   centralColumn(
#'     crukTitle("Incidence Data"),
#'     plotOutput("incidencePlot"),
#'     tableOutput("incidenceTable"),
#'
#'     # Data sources at the bottom
#'     crukSources(
#'       notes = "Data represents cancer registrations in England, 2018-2020.",
#'       zotero_path = "General & Cross Pathway/Shiny Example"
#'     )
#'   ),
#'   crukFooter()
#' )
#'
#' server <- function(input, output, session) {
#'   output$incidencePlot <- renderPlot({
#'     # Your plotting code
#'   })
#'
#'   output$incidenceTable <- renderTable({
#'     # Your table code
#'   })
#' }
#'
#' shinyApp(ui, server)
#' }
#'
#' @export
crukSources <- function(notes = "", zotero_path = NULL, custom_sources = NULL, boxBorder = TRUE) {
  shiny::addResourcePath(
    prefix = "shinyCRUK",
    directoryPath = system.file("www", package = "shinyCRUK")
  )

  css <- htmltools::htmlDependency(
    name = "crukSources",
    version = get_pkg_version(),
    src = "www",
    package = "shinyCRUK",
    stylesheet = "css/crukSources.css",
    all_files = TRUE
  )

  # Convert sources to list items
  source_items <- if (!is.null(zotero_path)) {
    htmltools::tags$ul(
      class = "zotero-list",
      purrr::map(
        get_zotero_sources(zotero_path),
        ~ htmltools::tags$li(htmltools::HTML(.x))
      )
    )
  } else {
    custom_sources
  }


  sourcesBox <- htmltools::div(
    class = c("sources", ifelse(boxBorder, "border")),
    if (notes != "") {
      htmltools::p(
        htmltools::span("Notes:", class = "notes-header"), htmltools::br(),
        notes
      )
    },
    htmltools::span("Data sources:", class = "sources-header"),
    htmltools::tags$ul(source_items, style = "margin-top: 0px")
  )

  htmltools::attachDependencies(sourcesBox, css)
}

#' Get Formatted Sources from Zotero Collection
#'
#' Retrieves bibliographic references from a Zotero collection and formats them
#' as HTML-ready citation strings. This function connects to the Zotero API,
#' navigates to a specified collection path, and returns formatted citations
#' suitable for display in a shiny app.
#'
#' The function formats each reference as: "Author(s). Title, Year. Last accessed Month, Year."
#' with clickable links to the source URLs when available.
#'
#' @param collection_path Character string. Path to the Zotero collection using
#'   forward slashes to separate nested collections (e.g.,
#'   \code{"General & Cross Pathway/Local Stats Dashboard"}. The function navigates
#'   through the collection hierarchy to find the target collection.
#' @param group_id Numeric. Zotero group library ID. Default is \code{6230705}
#'   (CRUK team library). Use \code{\link{find_zotero_group}} to find your
#'   group ID if using a different library.
#' @param api_key Character string. Zotero API key for authentication. Default
#'   reads from the \code{ZOTERO_API_KEY} environment variable. Get your API
#'   key from https://www.zotero.org/settings/keys
#' @param last_accessed Character string or NULL. Optional custom "Last accessed"
#'   text to override the access date stored in Zotero. Useful for standardising
#'   access dates across multiple sources. Format: "Last accessed Month, Year"
#'   (e.g., \code{"Last accessed January, 2024"}). When \code{NULL} (default),
#'   uses the access date from each Zotero item's metadata.
#'
#' @return A character vector of HTML-formatted citation strings, one per
#'   reference in the collection. Each string includes:
#'   \itemize{
#'     \item Author name(s) (or "Unknown Author" if missing)
#'     \item Title (hyperlinked if URL available, or "Untitled" if missing)
#'     \item Year (if available)
#'     \item Access date (from Zotero metadata or \code{last_accessed} parameter)
#'   }
#'
#' @section Authentication:
#' This function requires valid Zotero API credentials. Set up your credentials by:
#' \enumerate{
#'   \item Getting an API key from https://www.zotero.org/settings/keys
#'   \item Adding \code{ZOTERO_API_KEY=your_key_here} to your \code{.Renviron} file
#'   \item Restarting R
#' }
#' Or use \code{\link{setup_zotero_credentials}} to help with this setup.
#'
#' @section Collection Paths:
#' Collection paths use forward slashes (\code{/}) to navigate nested collections:
#' \itemize{
#'   \item Top-level collection: \code{"My Collection"}
#'   \item Nested collection: \code{"Parent/Child"}
#'   \item Deeply nested: \code{"Grandparent/Parent/Child"}
#' }
#' Collection names are case-sensitive and must match exactly.
#'
#' @section Error Handling:
#' The function will stop with an informative error if:
#' \itemize{
#'   \item The API key is not found or invalid
#'   \item The specified collection path doesn't exist
#'   \item The collection exists but contains no references
#'   \item The API request fails
#' }
#'
#' @section Citation Format:
#' References are formatted according to CRUK guidelines:
#' \itemize{
#'   \item Multiple authors are concatenated with spaces
#'   \item Titles are hyperlinked when URLs are available
#'   \item Years are extracted from full dates when necessary
#'   \item Access dates are formatted as "Last accessed Month, Year"
#' }
#'
#' @seealso
#' \code{\link{crukSources}} for displaying the formatted sources in a styled box
#'
#' \code{\link{setup_zotero_credentials}} for configuring API access
#'
#' \code{\link{find_zotero_group}} for finding your Zotero group ID
#'
#' @examples
#' # Basic usage (requires ZOTERO_API_KEY in .Renviron)
#' \dontrun{
#' # Get sources from a collection
#' sources <- get_zotero_sources("General & Cross Pathway/Shiny Example")
#'
#' # Use with custom group ID
#' sources <- get_zotero_sources(
#'   collection_path = "My Research/Papers",
#'   group_id = 1234567
#' )
#'
#' # Override access dates
#' sources <- get_zotero_sources(
#'   collection_path = "General & Cross Pathway/Shiny Example",
#'   last_accessed = "Last accessed October, 2024"
#' )
#'
#' # Pass directly to crukSources
#' crukSources(
#'   notes = "All data sources were accessed in October 2024.",
#'   custom_sources = htmltools::tagList(
#'     purrr::map(
#'       get_zotero_sources("General/Dashboard Sources"),
#'       ~ htmltools::tags$li(htmltools::HTML(.x))
#'     )
#'   )
#' )
#'
#' # Example output format:
#' # "John Smith Jane Doe. Cancer Registration Statistics, 2023. Last accessed September, 2024."
#' # "Unknown Author. <a href='https://example.com'>Untitled</a>, 2022. Last accessed October, 2024."
#' }
#'
#' @export
get_zotero_sources <- function(collection_path,
                               group_id = 6230705,
                               api_key = Sys.getenv("ZOTERO_API_KEY"),
                               last_accessed = NULL) {
  # Check credentials
  if (api_key == "") {
    stop("Zotero API key not found. Set ZOTERO_API_KEY in .Renviron or use setup_zotero_credentials()")
  }

  # Get all collections
  collections_response <- httr2::request(
    glue::glue("https://api.zotero.org/groups/{group_id}/collections")
  ) |>
    httr2::req_headers(
      `Zotero-API-Key` = api_key,
      `Zotero-API-Version` = "3"
    ) |>
    httr2::req_perform() |>
    httr2::resp_body_json()

  # create a df of collections, their key and parent key
  collections_df <- purrr::map_dfr(collections_response, ~ tibble::tibble(
    key = .x$key,
    name = .x$data$name,
    parent_key = as.character(.x$data$parentCollection) # %||% NA_character_
  ))

  # Get id of collection by matching the given path to the df
  collection_id <- find_collection_by_path(collections_df, collection_path)

  if (is.na(collection_id)) {
    stop(
      "Collection not found: ", collection_path,
      "\nAvailable collections: ",
      paste(collections_df$name, collapse = ", ")
    )
  }

  # check if collection contains any references
  collection_ref_list <- httr2::request(
    glue::glue("https://api.zotero.org/groups/{group_id}/collections/{collection_id}/items")
  ) |>
    httr2::req_headers(
      `Zotero-API-Key` = api_key,
      `Zotero-API-Version` = "3"
    ) |>
    httr2::req_perform() |>
    httr2::resp_body_string()

  if (collection_ref_list == "[]") {
    stop("There are no references present in this collection.")
  }

  # Get items from collection as JSON (not formatted bibliography)
  items_json <- httr2::request(
    glue::glue("https://api.zotero.org/groups/{group_id}/collections/{collection_id}/items")
  ) |>
    httr2::req_headers(
      `Zotero-API-Key` = api_key,
      `Zotero-API-Version` = "3"
    ) |>
    httr2::req_perform() |>
    httr2::resp_body_json()


  # Filter out attachments and format bibliographic entries
  bibliography <- purrr::map(items_json, ~ .x$data) |>
    # Drop any sources that are an attachment
    purrr::keep(~ .x$itemType != "attachment") |>
    purrr::map_chr(~ {
      # Extract fields with fallbacks
      authors <- if (!is.null(.x$creators) && length(.x$creators) > 0) {
        author_names <- purrr::map_chr(.x$creators, ~ {
          if (!is.null(.x$lastName) && !is.null(.x$firstName)) { # try first name last name first
            paste(.x$firstName, .x$lastName)
          } else if (!is.null(.x$name)) { # Otherwise use the name field
            .x$name
          } else { # if there is no name, use Unknown
            "Unknown"
          }
        })
        paste(author_names, collapse = " ")
      } else {
        "Unknown Author"
      }
      # Get the title, if it doesn't exist use "Untitled"
      title <- .x$title %||% "Untitled,"
      # Get the year, if it doesn't exist use ""
      year <- .x$date %||% ""

      # Extract year if full date provided
      if (stringr::str_detect(year, "\\d{4}")) {
        year_extracted <- stringr::str_extract(year, "\\d{4}")
        year <- glue::glue(", {year_extracted}")
      }

      # Get URL
      url <- .x$url %||% ""
      title_formatted <- if (url != "") {
        glue::glue('<a href="{url}">{title}</a>')
      } else {
        title
      }

      # Get accessed date from Zotero
      accessed <- if (!is.null(.x$accessDate) && .x$accessDate != "") {
        access_date <- zoo::as.yearmon(.x$accessDate)
        glue::glue("Last accessed {format(access_date, '%B, %Y')}.")
      } else {
        ""
      }

      if (is.null(last_accessed)) {
        glue::glue("{authors}. {title_formatted}{year}. {accessed}")
      } else {
        glue::glue("{authors}. {title_formatted}{year}. {last_accessed}")
      }
    })

  return(bibliography)
}

#' Find Collection by Hierarchical Path
#'
#' Internal helper function to navigate through nested Zotero collections and
#' return the key of the target collection. Used by \code{\link{get_zotero_sources}}
#' to resolve collection paths like \code{"Parent/Child/Grandchild"}.
#'
#' @param collections_df Data frame with columns \code{key}, \code{name}, and
#'   \code{parent_key} representing the collection hierarchy.
#' @param path Character string with forward-slash-separated collection names
#'   (e.g., \code{"Statistics/England/Incidence"}).
#'
#' @return Character string containing the collection key, or \code{NA_character_}
#'   if the path is not found.
#'
#' @details
#' The function walks through the path hierarchy:
#' \enumerate{
#'   \item Starts with top-level collections (those without a parent)
#'   \item For each part of the path, finds the matching collection name
#'   \item Moves to the children of that collection for the next iteration
#'   \item Returns the key when the final path component is reached
#' }
#'
#' @keywords internal
#' @importFrom rlang .data
#' @noRd
find_collection_by_path <- function(collections_df, path) {
  path_parts <- stringr::str_split(path, "/")[[1]]

  # Start with top-level collections (no parent)
  current_collections <- collections_df |>
    # dplyr::filter(is.na(parent_key) | parent_key == "" | parent_key == "FALSE")
    dplyr::filter(is.na(.data$parent_key) | .data$parent_key == "" | .data$parent_key == "FALSE")

  # Walk down the path
  for (part in path_parts) {
    matching <- current_collections |>
      dplyr::filter(.data$name == part)

    if (nrow(matching) == 0) {
      # Print available names for debugging
      message(
        "Available collections at this level: ",
        paste(current_collections$name, collapse = ", ")
      )
      return(NA_character_)
    }

    current_key <- matching$key[1]

    # If this is the last part of the path, return it
    if (part == path_parts[length(path_parts)]) {
      return(current_key)
    }

    # Get children of this collection for next iteration
    current_collections <- collections_df |>
      dplyr::filter(.data$parent_key == current_key)
  }

  return(current_key)
}

#' Setup Zotero API Credentials
#'
#' Interactive helper function to configure Zotero API credentials in your
#' \code{.Renviron} file. This function guides you through adding your API key
#' and user ID, which are required for \code{\link{get_zotero_sources}} to
#' access your Zotero library.
#'
#' @param api_key Character string. Your Zotero API key. Create a new private
#'   API key at https://www.zotero.org/settings/keys with read access to your
#'   library.
#' @param user_id Character string or numeric. Your Zotero user ID. Find this
#'   at https://www.zotero.org/settings/security (look for "Your userID for
#'   use in API calls").
#'
#' @return Invisibly returns \code{NULL}. Opens your \code{.Renviron} file in
#'   the editor and prints instructions for adding the credentials.
#'
#' @section Setup Steps:
#' \enumerate{
#'   \item Create a new API key at https://www.zotero.org/settings/keys
#'     \itemize{
#'       \item Give it a descriptive name (e.g., "R Shiny Apps")
#'       \item Select "Allow library access" (read-only is sufficient)
#'       \item Leave "Allow notes access" and "Allow write access" unchecked
#'       \item Save and copy the generated key
#'     }
#'   \item Find your user ID at https://www.zotero.org/settings/security
#'   \item Run \code{setup_zotero_credentials(api_key = "your_key", user_id = "your_id")}
#'   \item Add the printed lines to your \code{.Renviron} file
#'   \item Restart R (Ctrl+Shift+F10 on Windows/Linux, Cmd+Shift+0 on Mac)
#'   \item Test with \code{Sys.getenv("ZOTERO_API_KEY")} - should return your key
#' }
#'
#' @section Security Note:
#' The \code{.Renviron} file stores credentials as plain text. Keep this file
#' secure and never commit it to version control. Add \code{.Renviron} to your
#' \code{.gitignore} file.
#'
#' @seealso
#' \code{\link{get_zotero_sources}} for using the credentials to fetch sources
#'
#' \code{\link{find_zotero_group}} for finding your Zotero group ID
#'
#' \code{\link[usethis]{edit_r_environ}} for manually editing \code{.Renviron}
#'
#' @examples
#' \dontrun{
#' # Interactive setup
#' setup_zotero_credentials(
#'   api_key = "a1b2c3d4e5f6g7h8i9j0",
#'   user_id = "1234567"
#' )
#'
#' # After adding to .Renviron and restarting R, test:
#' Sys.getenv("ZOTERO_API_KEY")
#' Sys.getenv("ZOTERO_USER_ID")
#'
#' # Then try fetching sources:
#' sources <- get_zotero_sources("My Collection/Subcollection")
#' }
#'
#' @export
setup_zotero_credentials <- function(api_key, user_id) {
  usethis::edit_r_environ()
  message(
    "Add this line to your .Renviron file:\n",
    "ZOTERO_API_KEY=", api_key, "\n",
    "Then go to https://www.zotero.org/settings/security and find your user ID\n",
    "ZOTERO_USER_ID=", user_id, "\n",
    "Then restart R with Ctrl+Shift+F10 (or Cmd+Shift+0 on Mac)\n"
  )
}


#' Find Your Zotero Group ID
#'
#' Retrieves a list of your Zotero group libraries and their IDs. Use this
#' function to find the correct \code{group_id} parameter for
#' \code{\link{get_zotero_sources}} when working with group libraries.
#'
#' @param group_name Character string or NULL. Optional group name to filter
#'   results. If provided, only returns groups matching this name (case-sensitive).
#'   If \code{NULL} (default), returns all groups you have access to.
#' @param user_id Character string or numeric. Your Zotero user ID. Default
#'   reads from the \code{ZOTERO_USER_ID} environment variable. Find your ID
#'   at https://www.zotero.org/settings/security
#' @param api_key Character string. Your Zotero API key. Default reads from
#'   the \code{ZOTERO_API_KEY} environment variable. Get your key from
#'   https://www.zotero.org/settings/keys
#'
#' @return A data frame (tibble) with columns:
#'   \describe{
#'     \item{group_id}{Character. The group library ID to use in API calls}
#'     \item{name}{Character. The human-readable group name}
#'   }
#'   The data frame is also printed to the console for easy viewing.
#'
#' @section Authentication:
#' This function requires:
#' \itemize{
#'   \item A valid Zotero API key with group library access
#'   \item Your Zotero user ID
#' }
#' Set these up using \code{\link{setup_zotero_credentials}}.
#'
#' @section Usage:
#' Once you've found your group ID, use it in \code{\link{get_zotero_sources}}:
#' \preformatted{
#' # Find your group
#' groups <- find_zotero_group()
#' # Note the group_id for your desired group
#'
#' # Use it to fetch sources
#' sources <- get_zotero_sources(
#'   "Collection Path",
#'   group_id = 1234567  # Your group_id
#' )
#' }
#'
#' @seealso
#' \code{\link{get_zotero_sources}} for fetching sources from a group library
#'
#' \code{\link{setup_zotero_credentials}} for configuring API access
#'
#' @examples
#' \dontrun{
#' # List all groups you belong to
#' find_zotero_group()
#'
#' # Find a specific group
#' find_zotero_group(group_name = "CRUK Research Team")
#'
#' # With explicit credentials (not recommended - use .Renviron instead)
#' find_zotero_group(
#'   user_id = "1234567",
#'   api_key = "a1b2c3d4e5f6g7h8i9j0"
#' )
#'
#' # Example output:
#' # # A tibble: 3 × 2
#' #   group_id name
#' #   <chr>    <chr>
#' # 1 6230705  CRUK Cancer Intelligence
#' # 2 1234567  Research Collaboration
#' # 3 9876543  Statistics Working Group
#' }
#'
#' @export
find_zotero_group <- function(group_name = NULL,
                              user_id = Sys.getenv("ZOTERO_USER_ID"),
                              api_key = Sys.getenv("ZOTERO_API_KEY")) {
  groups <- httr2::request(glue::glue("https://api.zotero.org/users/{user_id}/groups")) |>
    httr2::req_headers(
      `Zotero-API-Key` = api_key,
      `Zotero-API-Version` = "3"
    ) |>
    httr2::req_perform() |>
    httr2::resp_body_json()

  groups_df <- purrr::map_dfr(groups, ~ tibble::tibble(
    group_id = as.character(.x$id),
    name = .x$data$name
  ))

  if (!is.null(group_name)) {
    groups_df <- groups_df |> dplyr::filter(.data$name == group_name)
  }

  print(groups_df)
  invisible(groups_df)
}
