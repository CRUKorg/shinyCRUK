# Setup Zotero API Credentials

Interactive helper function to configure Zotero API credentials in your
`.Renviron` file. This function guides you through adding your API key
and user ID, which are required for
[`get_zotero_sources`](https://verbose-guacamole-l18vr83.pages.github.io/reference/get_zotero_sources.md)
to access your Zotero library.

## Usage

``` r
setup_zotero_credentials(api_key, user_id)
```

## Arguments

- api_key:

  Character string. Your Zotero API key. Create a new private API key at
  https://www.zotero.org/settings/keys with read access to your library.

- user_id:

  Character string or numeric. Your Zotero user ID. Find this at
  https://www.zotero.org/settings/security (look for "Your userID for
  use in API calls").

## Value

Invisibly returns `NULL`. Opens your `.Renviron` file in the editor and
prints instructions for adding the credentials.

## Setup Steps

1.  Create a new API key at https://www.zotero.org/settings/keys

    - Give it a descriptive name (e.g., "R Shiny Apps")

    - Select "Allow library access" (read-only is sufficient)

    - Leave "Allow notes access" and "Allow write access" unchecked

    - Save and copy the generated key

2.  Find your user ID at https://www.zotero.org/settings/security

3.  Run
    `setup_zotero_credentials(api_key = "your_key", user_id = "your_id")`

4.  Add the printed lines to your `.Renviron` file

5.  Restart R (Ctrl+Shift+F10 on Windows/Linux, Cmd+Shift+0 on Mac)

6.  Test with `Sys.getenv("ZOTERO_API_KEY")` - should return your key

## Security Note

The `.Renviron` file stores credentials as plain text. Keep this file
secure and never commit it to version control. Add `.Renviron` to your
`.gitignore` file.

## See also

[`get_zotero_sources`](https://verbose-guacamole-l18vr83.pages.github.io/reference/get_zotero_sources.md)
for using the credentials to fetch sources

[`find_zotero_group`](https://verbose-guacamole-l18vr83.pages.github.io/reference/find_zotero_group.md)
for finding your Zotero group ID

[`edit_r_environ`](https://usethis.r-lib.org/reference/edit.html) for
manually editing `.Renviron`

## Examples

``` r
if (FALSE) { # \dontrun{
# Interactive setup
setup_zotero_credentials(
  api_key = "a1b2c3d4e5f6g7h8i9j0",
  user_id = "1234567"
)

# After adding to .Renviron and restarting R, test:
Sys.getenv("ZOTERO_API_KEY")
Sys.getenv("ZOTERO_USER_ID")

# Then try fetching sources:
sources <- get_zotero_sources("My Collection/Subcollection")
} # }
```
