crukNavTitle <- function(Title = "", selectors = 0, selector1 = NULL, selector2 = NULL) {
  shiny::addResourcePath(
    prefix = "shinyCRUK",
    directoryPath = system.file("www", package = "shinyCRUK")
  )
  cruk_logo_path <- "shinyCRUK/images/cruk-logo.svg"
  cruk_logo_wide_path <- "shinyCRUK/images/cruk-logo-wide.png"

  # Define media queries based on selector count
  media_query <- if (selectors == 0) {
    htmltools::tags$style(
      ".navbar-cruk {
        display: flex;
        flex-direction: row;
        justify-content: space-between;
      }

      @media (max-width: 991px) {
        .navbar-brand {
           width: 100%
        }

        .cruk-logo-stacked {
          height: 50px;
        }
      }

      @media (min-width: 992px) {
        .cruk-logo-stacked {
          height: 70px;
        }
      }
      "
    )
  } else if (selectors == 1) {
    htmltools::tags$style(
      ".navbar-cruk {
          display: flex;
          justify-content: space-between;
        }

        @media (max-width: 991px) {
          .navbar-brand {
            width: 100%
          }
          .navbar-cruk {
            flex-direction: column;
          }
          .cruk-logo-wide {
            display: none;
          }
          .cruk-logo {
            height: 50px;
          }

          .title {
            margin-top: 10px;
            width: 100%;
            display: flex;
            justify-content: space-between;
          }

          .selector-1 {width:100%;}
        }

        @media (min-width: 992px) {
          .cruk-logo-stacked {
            display: none;
          }

          .logo-wide {
            display: flex;
            justify-content: flex-end;
          }

          .cruk-logo-wide {
            height: 35px;
          }

          .cruk-logo {
            display: none;
          }

          .selector-1 { width: 400px;}
        }

      "
    )
  } else if (selectors == 2) {
    htmltools::tags$style(
      ".navbar-cruk {
          display: flex;
          justify-content: space-between;
        }

        @media (max-width: 991px) {
          .navbar-brand {
            width: 100%
          }
          .navbar-cruk {
            flex-direction: column;
          }
          .cruk-logo-wide {
            display: none;
          }
          .cruk-logo-nav {
            height: 50px;
          }

          .title {
            margin-top: 10px;
            width: 100%;
            display: flex;
            justify-content: space-between;
          }

          .selector-1 {width:100%;}
          .selector-2 {width:100%;}
        }

        @media (min-width: 992px) {
          .cruk-logo-stacked {
            display: none;
          }

          .logo-wide {
            display: flex;
            justify-content: flex-end;
          }

          .cruk-logo-wide {
            height: 35px;
          }

          .cruk-logo-nav {
            display: none;
          }

          .selector-1 { width: 400px;}
          .selector-2 { width: 400px;}
        }

      "
    )
  }


  navbar_title <- if (selectors == 0) {
    div(
      class = "navbar-cruk",
      div(
        class = "title",
        actionLink(
          inputId = "app_title_link",
          class = "app-title",
          HTML(Title)
        )
      ),
      div(
        class = "logo",
        style = "justify-content: flex-end; margin: 0.5rem;",
        a(
          img(
            src = cruk_logo_path,
            class = "cruk-logo-stacked"
          ),
          href = "https://www.cancerresearchuk.org/"
        ),
      )
    )
  } else if (selectors == 1) {
    htmltools::div(
      htmltools::div(
        class = "logo-wide",
        htmltools::a(shinyCRUK::crukLogoWide(),
          href = "https://www.cancerresearchuk.org/"
        )
      ),
      htmltools::div(
        class = "navbar-cruk",
        htmltools::div(
          class = "title",
          shiny::actionLink(
            inputId = "app_title_link",
            class = "app-title",
            htmltools::HTML(Title)
          ),
          htmltools::a(
            # Adding another class to this logo so display: none won't affect other cruk-logo
            shinyCRUK::crukLogo(class = "cruk-logo-nav"),
            href = "https://www.cancerresearchuk.org/"
          )
        ),
        htmltools::div(
          class = "selector-1",
          selector1
        )
      )
    )
  } else if (selectors == 2) {
    htmltools::div(
      htmltools::div(
        class = "logo-wide",
        htmltools::a(shinyCRUK::crukLogoWide(),
          href = "https://www.cancerresearchuk.org/"
        )
      ),
      htmltools::div(
        class = "navbar-cruk",
        htmltools::div(
          class = "title",
          shiny::actionLink(
            inputId = "app_title_link",
            class = "app-title",
            htmltools::HTML(Title)
          ),
          htmltools::a(shinyCRUK::crukLogo(), href = "https://www.cancerresearchuk.org/")
        ),
        htmltools::div(
          class = "selector-1",
          selector1
        ),
        htmltools::div(
          class = "selector-2",
          selector2
        )
      )
    )
  }


  htmltools::tagList(
    media_query,
    navbar_title
  )
}
