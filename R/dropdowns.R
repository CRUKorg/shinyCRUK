crukSelectInput <- function(inputId, label, choices, selectize = FALSE, class = "", ...) {
  css <- htmltools::htmlDependency(
    name = "dropdowns",
    version = utils::packageVersion("shinyCRUK"),
    src = "www",
    package = "shinyCRUK",
    stylesheet = "css/dropdowns.css",
    all_files = TRUE
  )

  dropdown <- div(class = c("crukSelectInput", class),
                  selectInput(
                    inputId = "select",
                    label = "label",
                    choices = c("Hobnob", "Digestive", "Bourbon", "Custard cream", "Rich tea"),
                    selectize = FALSE,
                    ...
                  )
  )

  htmltools::attachDependencies(dropdown, css)

}
crukPickerInput <- function(inputId, label, choices, class = "", livesearch = TRUE, placeholder = NULL, ..., options = list()) {
  css <- htmltools::htmlDependency(
    name = "dropdowns",
    version = utils::packageVersion("shinyCRUK"),
    src = "www",
    package = "shinyCRUK",
    stylesheet = "css/dropdowns.css",
    all_files = TRUE
  )

  #define default options
  default_options <- list(
    `live-search` = livesearch,
    selectOnTab = TRUE,
    title = placeholder
  )

  # Merge user-provided options with defaults
  merged_options <- modifyList(default_options, options)

  # Pass ... to pickerInput, and merged options to the options argument
  dropdown <- div(
    class = "crukPickerInput",
    pickerInput(
      inputId = inputId,
      label = label,
      choices = choices,
      options = merged_options,
      ...
    )
  )

  htmltools::attachDependencies(dropdown, css)
}
