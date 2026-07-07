library(shiny)
#library(shinyCRUK)
devtools::load_all() # Comment out above line and comment this in to test package edits made locally
library(bslib)
library(shinyWidgets)
library(dplyr)
library(plotly)
library(gt)

options(shiny.autoreload = TRUE)

# Define UI
ui <- bslib::page_navbar(
  window_title = "shinyCRUK",
  fillable = FALSE,
  navbar_options = navbar_options(underline = FALSE),
  # Apply CRUK theme and Google Analytics
  tags$head(
    crukTheme(),
    crukGA()
  ),

  # Navigation bar with two selectors
  title = crukNavTitle(
    Title = "shinyCRUK"
    # selectors = 2,
    # selector1 = crukPickerInput(
    #   inputId = "demo_section",
    #   label = "Choose a section:",
    #   choices = c("Overview", "Data Viz", "Typography", "Components"),
    #   livesearch = FALSE
    # ),
    # selector2 = crukSelectInput(
    #   inputId = "theme_option",
    #   label = "Theme:",
    #   choices = c("Light", "Dark"),
    #   selectize = FALSE
    # )
  ),

  # Window size tracking (hidden UI component)
  window_size_ui("window_tracker"),

  # Footer at bottom
  footer = centralColumn(
    crukFooter(includeContact = TRUE)
  ),

  # Overview Panel
  nav_panel(
    title = "Overview",
    centralColumn(
      lastReview(Sys.Date(), tag = "internal"),

      crukTitle(
        "Welcome to the shinyCRUK Package Demo",
        "A quick showcase of all the things it can help with"
      ),

      p("This application demonstrates most of the functions available in the shinyCRUK package,
        which provides themed and on-brand components for Shiny applications (and occasionally quarto)."),
      p("If this is your first time here, you'll have just seen the cookie banner which comes with google analytics.
        Alongside that is the crukTheme() which sorts out the navbar and a number of other bits."),
      p("For full installation instructions have a look at the ", a("package documentation site",
                                                                    href = "https://crukorg.github.io/shinyCRUK/index.html"),
        " which also includes the code for this app if you want to run it yourself."),

      h3("Value Boxes"),
      p("The package includes styled value boxes for displaying key metrics:"),

      bslib::layout_column_wrap(
        width = 1/2,
        crukValueBox(
          id = "vbox1",
          title = "Total Users",
          value = crukRounding(15678),
          icon = icon("users"),
          icon_colour = "#00007e",
          detail = "Last 30 days"
        ),
        crukValueBox(
          id = "vbox2",
          title = "Success Rate",
          value = crukRoundingPercentage(0.847),
          icon = icon("chart-line"),
          icon_colour = "#e60078",
          detail = "Quarterly average"
        )
      ),

      br(),

      h3("Buttons and Inputs"),
      div(
        h4("Buttons"),
        p("Buttons are available in two styles, 'primary' or 'secondary', with on-brand icons."),
        layout_column_wrap(
          width = 1/3,
          crukButton("btn_primary", "Primary Button", type = "primary", icon = "check_circle"),
          crukButton("btn_secondary", "Secondary Button", type = "secondary", icon = "download"),
          crukButton("btn_upload", "Upload File", type = "primary", icon = "upload_file")
        )),
      div(
        h4("Radio buttons and dropdowns"),
        p("crukRadioButton() creates radio buttons that rely on the shinyWidgets::RadioGroupButton() function, and anything you could use there can be used here too."),
        crukRadioButton(
          inputId = "radio_example_A",
          label = "Select an option:",
          choices = c("Option A", "Option B", "Option C"),
          width = "100%",
          justified = FALSE
        ),
        crukRadioButton(
          inputId = "radio_example_B",
          label = "Select an option:",
          choices = c("Option A", "Option B", "Option C"),
          justified = TRUE,
          direction = 'vertical'),
        p("Two dropdown selectors are available, crukSelectInput() and crukPickerInput().
          crukSelectInput is well suited to short dropdowns, and on mobile will use the native selector. Whereas crukPickerInput() has better support for long lists, allowing searching and multiple selections."),
        layout_column_wrap(
          width = 1/2,
          crukSelectInput(inputId = "select-input",
                        label = "crukSelectInput()",
                        choices = c("Hobnob", "Digestive", "Bourbon", "Custard cream", "Rich tea")),
        crukPickerInput(inputId = "pick-input",
                        label = "crukPickerInput()",
                        choices = c("Axolotl", "Naked mole rat", "Sloth", "Blobfish", "Pangolin",
                                    "Aye-aye", "Quokka", "Giraffe", "Cobra", "Goliath squid")),
      ),
      p("We also have a date selector"),
      crukDatePicker(inputId = "date-input",
                     start = "2019-01",
                     end = "2025-12",
                     label = "crukDatePicker()",
                     view = "months",
                     minView = "months",
                     startView = "2025-06",
                     value = "2025-06")
      ),
      h3("Content for the bottom of your pages"),
      p("If you're making something for internal use, I've added in a little CI team box you can drop in the footer or at the bottom of a page."),
      ciBox(boxBorder = TRUE),

      p("And there is a standardised footer that available, which comes with all the links to our legal/privacy bits, and an optional contact box for use on external shiny apps.")
    )
  ),

  # Data Visualization Panel
  nav_menu("Showcases",
  # Typography Panel
  nav_panel(
    title = "Typography",
    centralColumn(
      lastReview("20/10/2025"),

      crukTitle(
        "Typography Components",
        "Titles, headings, and text styling"
      ),
      onThisPage(
        c("page-titles", "Page Titles"),
        c("last-review", "Last Review Dates"),
        c("logos", "Logos"),
        include_top_button = TRUE
      ),
      h3("Page Titles", id = "page-titles"),
      p("The crukTitle() function creates styled page headings:"),

      div(style = "border: 1px solid #ccc; padding: 20px; margin: 20px 0;",
          crukTitle("Example Page Title", "With an optional subheading")
      ),

      br(),

      h3("Last Review Dates", id = "last-review"),
      p("Different styles for different audiences through lastReview()."),

      div(style = "border: 1px solid #ccc; padding: 20px; margin: 20px 0;",
          p("Public Content"),
          lastReview(Sys.Date()),
          br(),
          p("Health Professional Content"),
          lastReview(Sys.Date(), tag = "health professional"),
          br(),
          p("Internal Content"),
          lastReview(Sys.Date(), tag = "internal")
      ),

      br(),

      h3("CRUK Logos", id = "logos"),
      p("Two logo formats are available:"),

      div(style = "border: 1px solid #ccc; padding: 20px; margin: 20px 0;",
          p("Stacked Logo (Preferred)"),
          crukLogo(height = "75px"),
          br(), br(),
          p("Wide Logo (Use Sparingly)"),
          crukLogoWide(height = "50px")
      )
    )
  ),
  nav_panel(
    title = "Data Visualization",
    centralColumn(
      lastReviewHP(as.Date("2025-10-15")),

      crukTitle(
        "Data Visualization Components",
        "Chart and table display with accessibility features"
      ),
      h3("Rounding Functions"),
      p("Cancer Intelligence rounding rules are now wrapped up in handy functions with two versions available, one for numbers and another for frequencies and percentages:"),

      tags$ul(
        tags$li(HTML(paste0("<strong>crukRounding(1234)</strong> = ", crukRounding(1234)))),
        tags$li(HTML(paste0("<strong>crukRounding(156789)</strong> = ", crukRounding(156789)))),
        tags$li(HTML(paste0("<strong>crukRounding(1234567)</strong> = ", crukRounding(1234567)))),
        tags$li(HTML(paste0("<strong>crukRoundingPercentage(0.25)</strong> = ", crukRoundingPercentage(0.25)))),
        tags$li(HTML(paste0("<strong>crukRoundingPercentage(0.847)</strong> = ", crukRoundingPercentage(0.847))))
      ),
      br(),
      p("We've built a styled card to hold your graphs and encourage a data table to support the graph for better accessibility standards."),
      crukPickerInput(
        inputId = "car_filter",
        label = "Filter by number of cylinders:",
        choices = c("All", "4", "6", "8"),
        selected = "All",
        placeholder = "Select cylinders..."
      ),
      crukChartTable(
        chart = plotlyOutput("demo_plot", height = "500px"),
        table = gt::gt_output("demo_table"),
        alt = "A scatter plot showing the relationship between car weight and miles per gallon from the mtcars dataset",
        dataSourceText = "mtcars dataset from R",
        dataSourceLink = "https://www.rdocumentation.org/packages/datasets/versions/3.6.2/topics/mtcars",
        h3("A nice little chart based on mtcars")
      ),

      br(),

      h3("Data sources box"),
      p("A data sources box allows you to build out your sources list and we are working on an integration with Zotero
        so you can pull sources from there."),
      crukSources(
        notes = "This demo app showcases the shinyCRUK package components.",
        custom_sources = tagList(
          tags$li(HTML("<a href='https://github.com/CRUKorg/shinyCRUK'>shinyCRUK GitHub Repository</a>")),
          tags$li("Cancer Research UK Design System")
        ),
        boxBorder = TRUE
      )
    )
  )

  ),

  # Components Panel
  nav_panel(
    title = "All Components",
    centralColumn(
      crukTitle(
        "Complete Component List",
        "Every function in the shinyCRUK package"
      ),
      p("A full reference list is available on ",
        a("the package website", href = "https://crukorg.github.io/shinyCRUK/reference/index.html"),
        "along with documentation on each of the arguments and examples how to use them. "),
      onThisPage(
        c("layout", "Layout Components"),
        c("navigation", "Navigation"),
        c("inputs", "Input Controls"),
        c("display", "Display Components"),
        c("utilities", "Utility Functions"),
        include_top_button = TRUE
      ),

      div(id = "layout", style = "margin-top: 30px;",
          h3("Layout Components"),
          tags$ul(
            tags$li(tags$strong("centralColumn()"), " - Main content container (900px max width)"),
            tags$li(tags$strong("crukTheme()"), " - Apply CRUK CSS theme to the app"),
            tags$li(tags$strong("window_size_ui() / window_size_server()"), " - Track browser window dimensions")
          )
      ),

      div(id = "navigation", style = "margin-top: 30px;",
          h3("Navigation"),
          tags$ul(
            tags$li(tags$strong("crukNavTitle()"), " - Branded navigation bar with logo and selectors"),
            tags$li(tags$strong("onThisPage()"), " - Contents navigation box with scroll-to-top button")
          )
      ),

      div(id = "inputs", style = "margin-top: 30px;",
          h3("Input Controls"),
          tags$ul(
            tags$li(tags$strong("crukButton()"), " - Styled action buttons (primary/secondary)"),
            tags$li(tags$strong("crukRadioButton()"), " - Styled radio button groups"),
            tags$li(tags$strong("crukPickerInput()"), " - Enhanced dropdown with search"),
            tags$li(tags$strong("crukSelectInput()"), " - Basic styled dropdown")
          ),

          p("Examples:"),
          bslib::layout_column_wrap(
            width = 1/2,
            div(
              crukSelectInput(
                "select_demo",
                "Choose a fruit:",
                choices = c("Apple", "Banana", "Orange")
              )
            ),
            div(
              crukPickerInput(
                "picker_demo",
                "Choose multiple:",
                choices = letters[1:10],
                options = list(`actions-box` = TRUE),
                multiple = TRUE
              )
            )
          )
      ),

      div(id = "display", style = "margin-top: 30px;",
          h3("Display Components"),
          tags$ul(
            tags$li(tags$strong("crukTitle()"), " - Page titles with optional subheadings"),
            tags$li(tags$strong("crukValueBox()"), " - Metric display boxes"),
            tags$li(tags$strong("crukChartTable()"), " - Combined chart/table with alt text"),
            tags$li(tags$strong("lastReview()"), " - Last reviewed date with audience tags"),
            tags$li(tags$strong("crukLogo() / crukLogoWide()"), " - CRUK logos"),
            tags$li(tags$strong("crukFooter()"), " - Complete footer with legal info"),
            tags$li(tags$strong("crukSources()"), " - Data sources box"),
            tags$li(tags$strong("ciBox()"), " - Cancer Intelligence team footer")
          )
      ),

      div(id = "utilities", style = "margin-top: 30px;",
          h3("Utility Functions"),
          tags$ul(
            tags$li(tags$strong("crukRounding()"), " - Format numbers per CI guidelines"),
            tags$li(tags$strong("crukRoundingPercentage()"), " - Format percentages with descriptive text"),
            tags$li(tags$strong("crukGA()"), " - Add Google Analytics tracking"),
            tags$li(tags$strong("get_zotero_sources()"), " - Retrieve Zotero bibliography")
          ),

          h4("Rounding Examples:"),
          tableOutput("rounding_table")
      ),

      br(), br(),
      p("The window_size_server() and window_size_ui() allow the app to read in what size the window is,
        which is handy for resizing graphs better. (Resize this window and the numbers below should change.)"),
      verbatimTextOutput("window_size_display")
    )
  )
)

# Define server
server <- function(input, output, session) {

  # Track window size
  win_size <- window_size_server("window_tracker", debounce_ms = 300, verbose = FALSE)

  # Display window size
  output$window_size_display <- renderText({
    ws <- win_size()
    req(ws)
    paste0("Current Window Size: ", ws$width, " x ", ws$height, " pixels")
  })

  # Filter mtcars data based on cylinder selection
  filtered_data <- reactive({
    data <- mtcars
    if (input$car_filter != "All") {
      data <- data %>% filter(cyl == as.numeric(input$car_filter))
    }
    data
  })

  # Create plotly chart
  output$demo_plot <- renderPlotly({
    plot_ly(filtered_data(),
            x = ~wt,
            y = ~mpg,
            type = 'scatter',
            mode = 'markers',
            marker = list(size = 10, color = '#e60078'),
            text = ~paste("Car:", rownames(filtered_data()),
                          "<br>Weight:", wt,
                          "<br>MPG:", mpg),
            hoverinfo = 'text') %>%
      config(displayModeBar = FALSE) %>%
      layout(
        showlegend = FALSE, #change to true if not using annotations
        yaxis = list(
          title = "Miles per gallon",
          zeroline = T,
          zerolinewidth = 2,
          showgrid = T,
          titlefont = list(family = "Poppins", color = "#000000", size = 18),
          tickfont = list(family = "Poppins", color= "#000000", size= 14),
          range = c(0, max(filtered_data()$mpg) + 5)
        ),
        xaxis = list(
          title = "Weight (1000 lbs)",
          zeroline = T,
          showgrid = F,
          tickfont = list(family = "Poppins", color= "#000000", size= 14),
          titlefont = list(family = "Poppins", color = "#000000", size = 18)),
        margin = list(l = 50, r = 20, t = 20, b = 50)
      )
  })

  # Create gt table
  output$demo_table <- gt::render_gt({
    filtered_data() %>%
      select(mpg, cyl, wt, hp) %>%
      mutate(car = rownames(filtered_data())) %>%
      select(car, everything()) %>%
      gt() %>%
      gt::cols_label(
        car = "Car Model",
        mpg = "MPG",
        cyl = "Cylinders",
        wt = "Weight",
        hp = "Horsepower"
      ) %>%
      gt::fmt_number(
        columns = c(mpg, wt),
        decimals = 1
      ) %>%
      gt::tab_header(
        title = "Motor Trend Car Data"
      )
  })

  # Create rounding examples table
  output$rounding_table <- renderTable({
    data.frame(
      Input = c("1234", "156789", "1234567", "0.25", "0.847", "0.33"),
      Function = c("crukRounding()", "crukRounding()", "crukRounding()",
                   "crukRoundingPercentage()", "crukRoundingPercentage()",
                   "crukRoundingPercentage()"),
      Output = c(
        crukRounding(1234),
        crukRounding(156789),
        crukRounding(1234567),
        crukRoundingPercentage(0.25),
        crukRoundingPercentage(0.847),
        crukRoundingPercentage(0.33)
      )
    )
  }, striped = TRUE, hover = TRUE)

  # Button observers
  observeEvent(input$btn_primary, {
    showNotification("Primary button clicked!", type = "message")
  })

  observeEvent(input$btn_secondary, {
    showNotification("Secondary button clicked!", type = "message")
  })

  observeEvent(input$btn_upload, {
    showNotification("Upload button clicked!", type = "message")
  })

  # Observe app title link click
  observeEvent(input$app_title_link, {
    showNotification("Title clicked! This can be used for navigation.", type = "message")
  })
}

# Run the application
shinyApp(ui = ui, server = server)
